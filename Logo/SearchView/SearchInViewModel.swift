//
//  SearchInViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import Foundation

class SearchInViewModel: ObservableObject {
    @Published var title: Bool = false
    @Published var description: Bool = false
    @Published var content: Bool = false
    
    private var selections: [SearchParamSearchIn] = []
    
    private var onApply: (([SearchParamSearchIn]) -> Void)
    
    
    init(selections: [SearchParamSearchIn], onApply: @escaping ([SearchParamSearchIn]) -> Void) {
        self.selections = selections
        self.onApply = onApply
        parseSelections(selections)
    }
    
    func onClear() {
        parseSelections(DEFAULT_SEARCH_IN_SELECTIONS)
    }
    
    func reset() {
        parseSelections(selections)
    }
    
    func apply() {
        var newSelections: [SearchParamSearchIn] = []
        if title {
            newSelections.append(.title)
        }
        if description {
            newSelections.append(.description)
        }
        if content {
            newSelections.append(.content)
        }
        selections = newSelections
        onApply(newSelections)
    }
    
    private func parseSelections(_ selections: [SearchParamSearchIn]) {
        title = selections.contains(.title)
        description = selections.contains(.description)
        content = selections.contains(.content)
    }
    
}
