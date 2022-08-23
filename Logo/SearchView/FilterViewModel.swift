//
//  FilterViewModel.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import Foundation
import Combine

fileprivate let kAllSelection = "All"
fileprivate let kNoneSelection = "None"
fileprivate let kSearchInTitleMap: [SearchParamSearchIn: String] = [.title: "Title", .content: "Content", .description: "Description"]

let kNoDateDisplay = "yyyyy/mm/dd"
let DEFAULT_SEARCH_IN_SELECTIONS: [SearchParamSearchIn] = [.title, .description]
let DEFAULT_SEARCH_PARAMS: SearchParams = SearchParams(fromDate: nil, toDate: nil, searchIn: DEFAULT_SEARCH_IN_SELECTIONS)

class FilterViewModel: ObservableObject {
    
    @Published var fromDateDisplay: String? = nil
    @Published var toDateDisplay: String? = nil
    @Published var searchInDisplay: String = kNoneSelection
    
    @Published var fromDate: Date? = nil
    @Published var toDate: Date? = nil
    @Published var searchInSelections: [SearchParamSearchIn] = DEFAULT_SEARCH_IN_SELECTIONS
    
    private var onApply: (SearchParams) -> Void
    private var searchParams: SearchParams
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(searchParams: SearchParams, onApply: @escaping (SearchParams) -> Void) {
        self.searchParams = searchParams
        self.onApply = onApply
        $fromDate
            .map {
                if let safeToDate = self.toDate, let safeFromDate = $0 {
                    if (safeToDate < safeFromDate) {
                        self.toDate = safeFromDate
                    }
                }
                return self.formatDateToDisplay(aDate: $0)
            }.assign(to: \.fromDateDisplay, on: self)
            .store(in: &subscriptions)
        $toDate
            .map {
                if let safeFromDate = self.fromDate, let safeToDate = $0 {
                    if (safeToDate < safeFromDate) {
                        self.fromDate = safeToDate
                    }
                }
                return self.formatDateToDisplay(aDate: $0)
            }.assign(to: \.toDateDisplay, on: self)
            .store(in: &subscriptions)
        
        $searchInSelections
            .map {
                if ($0.count == 0) {
                    return kNoneSelection
                } else if ($0.contains(.title) && $0.contains(.content) && $0.contains(.description)){
                    return kAllSelection
                } else {
                    return $0.compactMap{ kSearchInTitleMap[$0] }.joined(separator: ", ")
                }
            }.assign(to: \.searchInDisplay, on: self)
            .store(in: &subscriptions)
        
        self.parseSearchParams(searchParams)
    }
    
    private func parseSearchParams(_ searchParams: SearchParams) {
        fromDate = searchParams.fromDate
        toDate = searchParams.toDate
        searchInSelections = searchParams.searchIn
    }
    
    private func formatDateToDisplay(aDate: Date?) -> String? {
        if let date = aDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func clearData() {
        parseSearchParams(DEFAULT_SEARCH_PARAMS)
    }
    
    func apply() {
        let searchParams = SearchParams(fromDate: fromDate, toDate: toDate, searchIn: searchInSelections)
        self.searchParams = searchParams
        onApply(searchParams)
    }
    
    func getSearchInVM() -> SearchInViewModel {
        return SearchInViewModel(selections: searchInSelections) { newSelections in
            self.searchInSelections = newSelections
        }
    }
}

