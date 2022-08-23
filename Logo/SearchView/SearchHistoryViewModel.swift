//
//  SearchHistoryViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import Foundation
import Combine

class SearchHistoryViewModel: NSObject, ObservableObject {
    var onSelection: (String) -> Void
    
    @Published var searchHistory: [String]
    
    private var ud = UserDefaults.standard
    
    private var cancelable: AnyCancellable?
    
    init(onSelection: @escaping (String) -> Void) {
        self.onSelection = onSelection
        searchHistory = ud.searchHistory
        super.init()
        
        cancelable = UserDefaults.standard.publisher(for: \.searchHistory)
            .sink(receiveValue: { [weak self] newValue in
                if newValue != self?.searchHistory {
                    self?.searchHistory = newValue
                }
            })
    }
}
