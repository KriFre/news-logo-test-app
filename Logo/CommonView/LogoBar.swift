//
//  LogoBar.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import SwiftUI

struct LogoBar: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var roundedCorners = true
    var onBackButton: (() -> Void)?
    var onClearAction: (() -> Void)?
    var searchBarVM: SearchBarViewModel?
    
    func backgroundView() -> some View {
        return Color.background
            .cornerRadius(roundedCorners ? 20 : 0, corners: [.bottomLeft, .bottomRight])
    }
    
    var body: some View {
        ZStack {
            
            if (roundedCorners) {
                backgroundView()
                    .bottomShadow()
            }
            backgroundView()
            VStack {
                HStack {
                    HStack() {
                        if (onBackButton != nil) {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                                onBackButton?()
                            } label: {
                                Image(systemName: "chevron.backward")
                            }.frame(width: SizeUtils.buttonHeight, height: SizeUtils.smallBarHeight)
                        }
                        Spacer()
                    }.frame(maxWidth: .infinity)
                    
                    Image("Logo")
                        .frame(height:36)
                    HStack() {
                        Spacer()
                        if (onClearAction != nil) {
                            Button(action: onClearAction!) {
                                HStack {
                                    Text("Clear")
                                        .foregroundColor(Color.accentColor)
                                        .subtitleFont()
                                    Image("TrashCan")
                                }.foregroundColor(Color.accentColor).padding(.trailing, SizeUtils.padding)
                            }.frame(height: SizeUtils.smallBarHeight)
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(height: SizeUtils.smallBarHeight)
                if (searchBarVM != nil) {
                    Spacer()
                    SearchBarView(viewModel: searchBarVM!).padding(.bottom, 10)
                }
            }
        }.frame(height: searchBarVM != nil ? SizeUtils.bigBarHeight : SizeUtils.smallBarHeight)
        
    }
}

struct LogoBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top) {
            Color.yellow
            VStack(spacing: 20) {
                LogoBar()
                LogoBar(roundedCorners: false)
                LogoBar(onBackButton: {})
                LogoBar(onClearAction: {
                    print("cleared")
                })
                LogoBar(roundedCorners: false, onClearAction: {
                    print("cleared2")
                })
                LogoBar(searchBarVM: SearchBarViewModel(onFilterClick: {}, onSortClick: {_ in}, onSearchSumbmit: {_ in}))
            }
        }.previewLayout(.fixed(width: 400, height: 600))
    }
}
