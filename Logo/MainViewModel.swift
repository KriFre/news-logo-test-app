//
//  MainViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import Foundation

class MainViewModel: ObservableObject {
    
    // Bad, but avoiding importing swiftUI
    @Published var modalView: Any?
    @Published var showModalView: Bool = false
    
    private lazy var newsVM: NewsViewModel = {
        NewsViewModel()
    }()
    
    func getNewsVM() -> NewsViewModel {
        return newsVM
    }
    
    private lazy var searchVM: SearchViewModel = {
        SearchViewModel { modalView in
            self.modalView = modalView
            self.showModalView = self.modalView != nil
        }
    }()
    
    func getSearchVM() -> SearchViewModel {
        return searchVM
    }
    
}
