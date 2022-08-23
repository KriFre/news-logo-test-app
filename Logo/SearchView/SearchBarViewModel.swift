//
//  SearchBarViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 18/08/2022.
//

import Foundation
import Combine

class SearchBarViewModel: ObservableObject {
    
    @Published var filterBadgeNumber = 0
    @Published var searchText = ""
    @Published var sortToggled = false
    
    var onFilterClick: () -> Void
    var onSortClick: (Bool) -> Void
    var onSearchSumbmit: (String) -> Void
    
    init(onFilterClick: @escaping () -> Void, onSortClick: @escaping (Bool) -> Void, onSearchSumbmit: @escaping (String) -> Void) {
        self.onFilterClick = onFilterClick
        self.onSortClick = onSortClick
        self.onSearchSumbmit = onSearchSumbmit
    }
    
    func sortClicked() {
        sortToggled.toggle()
        self.onSortClick(sortToggled)
    }
    
    func sortClosed() {
        sortToggled = false
    }
    
    func submitSearch() {
        onSearchSumbmit(searchText)
    }
    
    func updateSearchText(text: String) {
        searchText = text
        submitSearch()
    }
    
    func updateBadge(_ badgeNumber: Int) {
        filterBadgeNumber = badgeNumber
    }
    
}
