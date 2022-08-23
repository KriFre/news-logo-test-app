//
//  WebView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 18/08/2022.
//

import SwiftUI

struct WebView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var url: URL
    
    var body: some View {
        ZStack(alignment: .top) {
            WebViewRepresentable(url: url).padding(.top, SizeUtils.smallBarHeight)
            LogoBar(onBackButton: {})
        }.hiddenNavigationBarStyle()
    }
}

struct WebViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: URL(string: "https://www.apollo.lv/")!)
    }
}

