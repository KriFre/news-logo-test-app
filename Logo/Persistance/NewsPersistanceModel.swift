//
//  NewsPersistanceModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import Foundation
import CoreData

fileprivate let DEMO_MODE_DATE: Date = "2022-08-21T19:30:15Z".toNewsApiDate()!

class NewsPersistanceModel {
    
    let container = NSPersistentContainer(name: "Model")
    var date: Date = Date.now
    var articleCount = 0
    
    lazy var context: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    init () {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        })
    }
    
    func save(){
        if context.hasChanges {
            do{
                try context.save()
            } catch let error{
                print("Error saving Core Data. \(error.localizedDescription)")
            }
        }
    }
    
    func reset() {
        date = Date.now
        articleCount = 0
    }
    
    private func createArticleEntity(dictionary: [String: AnyObject], index: Int64?) -> Article? {
        
        // TODO: Make this check a bit nicer...
        guard let title = dictionary["title"] as? String else { return nil }
        guard let description = dictionary["description"] as? String else { return nil }
        guard let content = dictionary["content"] as? String else { return nil }
        guard let url = dictionary["url"] as? String else { return nil }
        guard let image = dictionary["image"] as? String else { return nil }
        guard let publishedAt = dictionary["publishedAt"] as? String else { return nil }
        
        let articleFetchReq = Article.fetchRequest()
        articleFetchReq.fetchLimit = 1
        // Assuming the url of the article is unique
        articleFetchReq.predicate = NSPredicate(format: "url = %@", url)
        
        do {
            if let article = try context.fetch(articleFetchReq).first {
                if let safeIndex = index {
                    article.index = safeIndex
                }
                return article
            }
        } catch {
            
        }
        
        let article = Article(context: context)
        if let safeIndex = index {
            article.index = safeIndex
        }
        article.title = title
        article.desc = description
        article.content = content
        article.url = URL(string: url)
        article.image = URL(string: image)
        article.publishedAt = publishedAt.toNewsApiDate()
        
        return article
    }
    
    func loadTopNews(lastArticle: Article? = nil) async -> [Article]? {
        var fromDate: Date = date
        // Check if we have it already in cache
        var preFetchedArticles: [Article] = []
        context.performAndWait {
            if let article = lastArticle {
                fromDate = (article.publishedAt != nil) ? (article.publishedAt)!.addingTimeInterval(-1) : date
                let articleIndex = Int(truncatingIfNeeded: article.index) - 1
                let articles = fetchTopArticles(fromIndex: articleIndex, toIndex: articleIndex - ARTICLE_PAGINATION)
                if (articles.count == ARTICLE_PAGINATION) {
                    preFetchedArticles = articles
                }
            }
        }
        
        if (preFetchedArticles.count == ARTICLE_PAGINATION) {
            return preFetchedArticles
        }
        
        guard let response = await NewsReqUtil.getTopHeadlines(fromDate: fromDate) else { return nil }
        guard let articles = response["articles"] as? [[String: AnyObject]] else { return nil }
        guard let totalArticles = response["totalArticles"] as? Int64 else { return nil }
        
        context.performAndWait {
            for (index, item) in articles.enumerated() {
                _ = createArticleEntity(dictionary: item, index: totalArticles - Int64(index))
            }
            save()
        }
        return nil
    }
    
    func fetchTopArticles(fromIndex: Int, toIndex: Int?) -> [Article] {
        let articleFetchReq = Article.fetchRequest()
        
        if let safeToIndex = toIndex {
            let predicate1 = NSPredicate(format: "index < %i", fromIndex + 1)
            let predicate2 = NSPredicate(format: "index > %i", safeToIndex)
            let compound = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2])
            articleFetchReq.predicate = compound
        } else {
            articleFetchReq.fetchLimit = ARTICLE_PAGINATION
        }
        articleFetchReq.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        
        var articles: [Article] = []
        context.performAndWait {
            do {
                articles = try context.fetch(articleFetchReq)
            } catch {
                
            }
        }
        return articles
    }
    
    func loadAndFetchSearchArticles(searchText: String,
                                    searchParams: SearchParams,
                                    sortingOrder: SearchParamSorting,
                                    lastArticle: Article? = nil) async -> [Article]? {
        var toDate: Date = date
        context.performAndWait {
            // This will not really work in case of "relevance" filter...
            // But free users don't have paging, so will do this just to show data.
            
            if let article = lastArticle {
                toDate = (article.publishedAt != nil) ? (article.publishedAt)!.addingTimeInterval(-1) : date
            } else {
                toDate = searchParams.toDate ?? date
            }
        }
        
        
        guard let response = await NewsReqUtil.getSearch(text: searchText,
                                                         fromDate: searchParams.fromDate,
                                                         toDate: toDate,
                                                         searchIn: searchParams.searchIn,
                                                         sortOrder: sortingOrder) else { return nil }
        
        guard let articles = response["articles"] as? [[String: AnyObject]] else { return nil }
        guard let totalArticles = response["totalArticles"] as? Int64 else { return nil }
        var cdArticles: [Article] = []
        context.performAndWait {
            articleCount = Int(totalArticles)
            articles.forEach {
                let article = createArticleEntity(dictionary: $0, index: nil)
                if let anArticle = article {
                    cdArticles.append(anArticle)
                }
            }
            save()
        }
        return cdArticles
    }
}


