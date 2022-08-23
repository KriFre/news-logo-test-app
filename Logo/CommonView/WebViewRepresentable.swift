//
//  WebViewRepresentable.swift
//  Logo
//
//  Created by Kristaps Freibergs on 18/08/2022.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebViewRepresentable(url: URL(string: "https://www.apollo.lv/")!)
    }
}
