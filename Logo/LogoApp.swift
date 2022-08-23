//
//  LogoApp.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import SwiftUI

@main
struct LogoApp: App {
    
    init() {
        
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
        }
    }
}
