//
//  ToggleView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 20/08/2022.
//

import SwiftUI

struct ToggleView: View {
    var title: String
    @Binding var toggled: Bool
    var onToggle: () -> Void
    
    var body: some View {
        Button {
            if (!toggled) {
                onToggle()
            }
        } label: {
            Text(title).subtitleFont()
            Spacer()
            Circle()
                .strokeBorder(Color.accentColor, lineWidth: toggled ? 7 : 0)
                .background(Circle()
                    .fill(Color.seperators))
                .frame(width: 24, height: 24)
        }.frame(height: 58)
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            VStack(spacing: 20) {
                ToggleView(title: "Upload date", toggled: Binding(get: {true}, set: {_ in}), onToggle: {
                    print("toggle 1")
                })
                ToggleView(title: "Relevence", toggled: Binding(get: {false}, set: {_ in}), onToggle: {
                    print("toggle 2")
                })
            }
        }.previewLayout(.fixed(width: 400, height: 200))
    }
}
