//
//  SearchInView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import SwiftUI

struct SearchInView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: SearchInViewModel
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Search In").titleFont()
                    SwitchView(title: "Title", value: $viewModel.title)
                    SwitchView(title: "Description", value: $viewModel.description)
                    SwitchView(title: "Content", value: $viewModel.content)
                    Spacer().frame(height: 30)
                }.padding(.top, 30)
                    .padding(.horizontal, SizeUtils.padding)
            }
            .padding(.top, SizeUtils.smallBarHeight)
            .padding(.bottom, SizeUtils.buttonHeight/2)
            VStack {
                Spacer()
                Button {
                    viewModel.apply()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Apply").foregroundColor(Color.white)
                            .titleFont()
                        Spacer()
                    }.frame(height: SizeUtils.buttonHeight)
                }.background(Color.accentColor)
                    .clipShape(Capsule())
            }.padding(.horizontal, SizeUtils.padding)
            LogoBar(roundedCorners: false, onBackButton: {
                viewModel.reset()
            }, onClearAction: {
                viewModel.onClear()
                viewModel.apply()
                self.presentationMode.wrappedValue.dismiss()
            })
        }.hiddenNavigationBarStyle()
    }
}

struct SearchInView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInView(viewModel: SearchInViewModel(selections: DEFAULT_SEARCH_IN_SELECTIONS, onApply: { val in
            print(val)
        }))
    }
}
