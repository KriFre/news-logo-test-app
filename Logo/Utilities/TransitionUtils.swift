//
//  TransitionUtils.swift
//  Logo
//
//  Created by Kristaps Freibergs on 20/08/2022.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
}
