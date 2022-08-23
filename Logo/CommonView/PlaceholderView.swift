//
//  PlaceholderView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 12/08/2022.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("ContentBackground")
            VStack {
                Spacer()
                Text("⚠️ This is a placeholder because area wasn't specified. ⚠️")
                    .descriptionFont()
                Spacer()
            }
            LogoBar()
        }.hiddenNavigationBarStyle()
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView()
    }
}
