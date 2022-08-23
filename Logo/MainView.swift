//
//  MainView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 1
    
    @ObservedObject var viewModel: MainViewModel
    @State var showModal = false
    
    init(viewModel: MainViewModel) {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.init(name: "OpenSans-Semibold", size: 10)!], for: .normal)
        
        UITabBar.appearance().backgroundColor = UIColor(Color.background)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.inactiveTint)
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundImage = UIImage()
        
        UINavigationBar.appearance().backgroundColor = UIColor(Color.background)
        UINavigationBar.appearance().isTranslucent = true
        
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        NavigationView {
            TabView(selection:$selection) {
                PlaceholderView().tabItem {
                    Label("Home", image: "Home")
                }.tag(0)
                NewsView(viewModel: viewModel.getNewsVM()).tabItem {
                    Label("News", image: "News")
                }.tag(1)
                SearchView(viewModel: viewModel.getSearchVM()).tabItem {
                    Label("Search", image: "Search")
                }.tag(2)
                PlaceholderView().tabItem {
                    Label("Profile", image: "Person")
                }.tag(3)
                PlaceholderView().tabItem {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }.tag(4)
            }.accentColor(Color("AccentColor"))
        }.overlay(alignment: .bottom) {
            if (showModal) {
                (viewModel.modalView as? AnyView)
                    .transition(.moveAndFade)
            }
        }.onReceive(viewModel.$showModalView) { value in
            withAnimation {
                showModal = value
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
