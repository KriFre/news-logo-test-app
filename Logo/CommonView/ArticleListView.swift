//
//  ArticleListView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 18/08/2022.
//

import SwiftUI

struct ArticleListView: View {
    var title: String
    @Binding var articles: [Article]
    @Binding var canLoadMore: Bool
    var onRefreshData: () -> Void
    var loadMore: () -> Void
    
    var body: some View {
        List() {
            Text(title)
                .titleFont()
                .removeListRowDefaults()
                .padding(.leading, SizeUtils.padding)
                .padding(.top, SizeUtils.padding*2)
                .padding(.bottom, 10)
            ForEach(articles, id: \.url) { article in
                ZStack {
                    ArticleView(viewModel: ArticleViewModel(article: article))
                    NavigationLink(destination: WebView(url: article.url!)) {
                        EmptyView()
                    }.opacity(0)
                }
                
            }.removeListRowDefaults()
            if (canLoadMore) {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }.removeListRowDefaults()
                    .frame(height: SizeUtils.buttonHeight)
                    .onAppear {
                        loadMore()
                    }
            }
        }.refreshable {
            onRefreshData()
        }
        .listStyle(.plain)
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(title: "News",
                        articles: Binding(get: {[]}, set: {_ in}),
                        canLoadMore: Binding(get: {true}, set: {_ in}),
                        onRefreshData: {}, loadMore: {})
    }
}
