//
//  ArticleView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import SwiftUI

struct ArticleView: View {
    
    @ObservedObject var viewModel: ArticleViewModel
    
    var body: some View {
        
        ZStack {
            Color.background
                .bottomShadow()
            HStack(alignment: .top) {
                AsyncImage(url: viewModel.image, content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                    
                }, placeholder: {
                    ProgressView()
                }).frame(width: 124, height: 108)
                    .clipped()
                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.title)
                        .articleTitleFont()
                        .lineLimit(1)
                    Text(viewModel.description)
                        .descriptionFont()
                        .lineLimit(3)
                }.padding(.horizontal, 20)
                    .padding(.vertical, SizeUtils.padding)
                Spacer()
            }.background(Color.background)
        }.frame(height: 108)
            .padding(.horizontal, SizeUtils.padding)
            .padding(.vertical, 5)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        
        let article = Article()
        article.title = "some Title"
        article.desc = "some Desc"
        article.image = URL(string: "https://www.apollo.lv/")!
        let vm = ArticleViewModel(article: article)
        
        return ArticleView(viewModel: vm)
    }
}
