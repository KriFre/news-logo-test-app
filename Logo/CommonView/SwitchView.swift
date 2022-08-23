//
//  SwitchView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import SwiftUI

struct SwitchView: View {
    
    var title: String
    @Binding var value: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(title)
                    .subtitleFont()
                Spacer()
                Toggle(isOn: $value) {
                    Text("title")
                }.toggleStyle(SwitchToggleStyle())
                    .labelsHidden()
                // For what ever reason the switch get's clipped
                    .padding(.trailing, 2)
                    .tint(Color.accentColor)
            }
            Divider().frame(height: SizeUtils.dividerHeight).overlay(Color.seperators)
        }
    }
}

struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        let bindingOn: Binding<Bool> = Binding(get: { true }, set: {_ in })
        let bindingOff: Binding<Bool> = Binding(get: { false }, set: {_ in })
        VStack {
            SwitchView(title: "Switch On", value: bindingOn)
            SwitchView(title: "Switch Off", value: bindingOff)
        }.previewLayout(.fixed(width: 400, height: 400))
    }
}
