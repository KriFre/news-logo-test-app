//
//  ListViewUtils.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import SwiftUI

extension View {
    func removeListRowDefaults() -> some View {
        return modifier(DefaultListModifierRemoval())
    }
}


fileprivate struct DefaultListModifierRemoval: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}
