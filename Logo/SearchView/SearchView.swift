//
//  SearchView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    private var cancelable: AnyCancellable?
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        viewModel.getSortByView = getSortByView
    }
    
    func getSortByView() -> Any {
        return AnyView(SortByView(uploadDate: $viewModel.uploadDateOrder, relevance: $viewModel.relevanceOrder))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationLink(destination:
                            FilterView(viewModel: viewModel.getFilterVM()),
                           isActive: Binding(get: {
                viewModel.filterPushed
            }, set: {
                viewModel.filterPushed = $0
            })) {
                EmptyView()
            }.hidden()
            
            Color.contentBackground
            VStack {
                if (viewModel.showSearchResults) {
                    ArticleListView(title: viewModel.title,
                                    articles: $viewModel.articles,
                                    canLoadMore: $viewModel.canLoadMore,
                                    onRefreshData: {
                        viewModel.refreshData()
                    }) {
                        viewModel.loadMore()
                    }
                } else {
                    SearchHistoryView(viewModel: viewModel.getSearchHistoryVM())
                }
            }.padding(.top, SizeUtils.bigBarHeight)
            LogoBar(searchBarVM: viewModel.getSearchBarVM())
        }.hiddenNavigationBarStyle()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel(showModalView: { _ in}))
    }
}
