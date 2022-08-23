//
//  NewsView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.contentBackground
            VStack {
                ArticleListView(title: "News", articles: $viewModel.articles, canLoadMore: $viewModel.canLoadMore, onRefreshData: {
                    viewModel.refreshData()
                }, loadMore: {
                    viewModel.loadMoreData()
                })
                .padding(.top, SizeUtils.smallBarHeight)
                
            }
            LogoBar()
        }
        .hiddenNavigationBarStyle()
        
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(viewModel: NewsViewModel())
    }
}
