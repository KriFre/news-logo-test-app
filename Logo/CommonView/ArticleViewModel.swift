//
//  ArticleViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import Foundation

class ArticleViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var image: URL?
    
    private var item: Article
    
    init(article: Article) {
        item = article
        title = article.title ?? ""
        description = article.desc ?? ""
        image = article.image
    }
    
    
}
