//
//  SearchViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import Foundation
import Combine

enum SearchParamSearchIn: String {
    case title = "title"
    case description = "description"
    case content = "content"}

enum SearchParamSorting: String {
    case uploadDate = "publishedAt"
    case relevance = "relevance"
}

struct SearchParams {
    let fromDate: Date?
    let toDate: Date?
    let searchIn: [SearchParamSearchIn]
}

fileprivate let kDefaultSortingOrder: SearchParamSorting = .uploadDate

class SearchViewModel : ObservableObject {
    
    @Published var filterPushed = false
    @Published var sortingShown = false
    
    @Published var uploadDateOrder = true
    @Published var relevanceOrder = false
    @Published var showSearchResults = false
    
    @Published var title = "news"
    @Published var articles: [Article] = []
    @Published var canLoadMore = true
    
    var getSortByView: (() -> Any)?
    var showModalView: (Any?) -> Void
    
    private var loadTask: Task<(), Never>?
    
    private var searchParams = DEFAULT_SEARCH_PARAMS
    private var searchText = ""
    private var sortingOrder = kDefaultSortingOrder
    
    private let persistance = NewsPersistanceModel()
    
    private var cancelable: AnyCancellable?
    
    private lazy var searchBarVM: SearchBarViewModel = {
        SearchBarViewModel(onFilterClick: {
            self.filterPushed = true
        }, onSortClick: { showSort in
            self.sortingShown = showSort
            if (self.sortingShown) {
                self.showSorting()
            } else {
                self.hideSorting()
            }
        }) { searchText in
            if (self.searchText == searchText) {
                return
            }
            self.searchText = searchText
            self.refreshData()
            self.doSearch(searchText: searchText)
        }
    }()
    
    init(showModalView: @escaping (Any?) -> Void) {
        self.showModalView = showModalView
        cancelable = $uploadDateOrder.sink(receiveValue: { value in
            self.sortingShown = false
            self.hideSorting()
            if (value) {
                self.sortingOrder = .uploadDate
            } else {
                self.sortingOrder = .relevance
            }
            self.refreshData()
        })
    }
    
    private func showSorting() {
        if let sortByViewFetch = getSortByView {
            showModalView(sortByViewFetch())
        }
    }
    
    private func hideSorting() {
        showModalView(nil)
        searchBarVM.sortClosed()
    }
    
    private func doSearch(searchText: String) {
        // Do search if good
        if (!searchText.isEmpty){
            showSearchResults = true
            let ud = UserDefaults.standard
            var history = ud.searchHistory
            if (history.contains(searchText)) {
                history = history.filter { $0 != searchText }
            }
            history.insert(searchText, at: 0)
            
            let maxHistoryCount = 10
            
            if (history.count > maxHistoryCount) {
                history.removeLast(history.count - maxHistoryCount)
            }
            ud.searchHistory = history
        } else {
            showSearchResults = false
        }
    }
    
    func getSearchHistoryVM() -> SearchHistoryViewModel {
        return SearchHistoryViewModel { searchText in
            self.searchBarVM.updateSearchText(text: searchText)
        }
    }
    
    func getSearchBarVM() -> SearchBarViewModel {
        return searchBarVM
    }
    
    private func getBadgeNumber(_ searchParams: SearchParams) -> Int {
        var badgeNumber = 0
        if (searchParams.fromDate != nil){
            badgeNumber += 1
        }
        if (searchParams.toDate != nil) {
            badgeNumber += 1
        }
        if (searchParams.searchIn != DEFAULT_SEARCH_IN_SELECTIONS) {
            badgeNumber += 1
        }
        return badgeNumber
    }
    
    func getFilterVM() -> FilterViewModel {
        return FilterViewModel(searchParams: searchParams) { searchParams in
            self.searchParams = searchParams
            self.searchBarVM.updateBadge(self.getBadgeNumber(searchParams))
            self.refreshData()
        }
    }
    
    func refreshData() {
        loadTask?.cancel()
        loadTask = nil
        articles = []
        persistance.reset()
        canLoadMore = true
        title = "news"
    }
    
    func loadMore() {
        if (loadTask != nil || searchText.isEmpty) {
            return
        }
        loadTask = Task {
            let preFetchedArticles = await persistance.loadAndFetchSearchArticles(searchText: searchText,
                                                                                  searchParams: searchParams,
                                                                                  sortingOrder: sortingOrder,
                                                                                  lastArticle: articles.last)
            DispatchQueue.main.async {
                let newArticles: [Article]
                if let safeArticles = preFetchedArticles {
                    newArticles = safeArticles
                } else {
                    newArticles = []
                }
                if (self.articles.count == 0) {
                    self.title = String(format: "%i news", self.persistance.articleCount)
                }
                if (newArticles.count < ARTICLE_PAGINATION) {
                    self.canLoadMore = false
                    
                }
                self.articles.append(contentsOf: newArticles)
                self.loadTask = nil
            }
        }
    }
}
