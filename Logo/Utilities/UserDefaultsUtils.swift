//
//  UserDefaultsUtils.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import Foundation

let UD_SEARCH_HISTORY_KEY = "searchHistory"

extension UserDefaults {
    @objc dynamic var searchHistory: [String] {
        get { array(forKey: UD_SEARCH_HISTORY_KEY) as? [String] ?? [] }
        set { setValue(newValue, forKey: UD_SEARCH_HISTORY_KEY) }
    }
}
