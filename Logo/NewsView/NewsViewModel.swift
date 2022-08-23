//
//  NewsViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import Foundation
import Combine
import CoreData

class NewsViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var canLoadMore = true
    private var loadTask: Task<(), Never>?
    
    
    private let persistance = NewsPersistanceModel()
    
    func loadMoreData() {
        if (loadTask != nil) {
            return
        }
        loadTask = Task {
            let preFetchedArticles = await persistance.loadTopNews(lastArticle: articles.last)
            
            DispatchQueue.main.async {
                let newArticles: [Article]
                if let safeArticles = preFetchedArticles {
                    newArticles = safeArticles
                } else {
                    let fromIndex = self.articles.last != nil ? Int(truncatingIfNeeded: self.articles.last!.index) - 1 : .max
                    newArticles = self.persistance.fetchTopArticles(fromIndex: fromIndex, toIndex: fromIndex == .max ? nil : fromIndex - ARTICLE_PAGINATION)
                }
                
                if (newArticles.count < ARTICLE_PAGINATION) {
                    self.canLoadMore = false
                    
                }
                if let lastArticle = self.articles.last {
                    if let firstNewArticle = newArticles.first {
                        if (lastArticle.index > firstNewArticle.index) {
                            self.articles.append(contentsOf: newArticles)
                        }
                    }
                } else {
                    self.articles.append(contentsOf: newArticles)
                }
                self.loadTask = nil
            }
        }
    }
    
    func refreshData() {
        loadTask?.cancel()
        loadTask = nil
        articles = []
        persistance.reset()
        canLoadMore = true
    }
    
}
