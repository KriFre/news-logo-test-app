//
//  SearchBarView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 18/08/2022.
//

import SwiftUI

fileprivate let buttonHeight = 46.0

struct SearchBarView: View {
    
    @ObservedObject var viewModel: SearchBarViewModel
    @FocusState private var searchFocused
    
    var body: some View {
        HStack {
            ZStack {
                Capsule().fill(Color.contentBackground)
                HStack(alignment: .center) {
                    Image("Search")
                        .resizable()
                        .foregroundColor(searchFocused ? Color.textColor : Color.textColor)
                        .frame(width: SizeUtils.smallIconSize, height: SizeUtils.smallIconSize)
                    TextField("Search", text: $viewModel.searchText)
                        .frame(height: buttonHeight)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($searchFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.submitSearch()
                        }
                        .subtitleFont()
                }.padding(.horizontal, SizeUtils.padding)
            }.frame(height: buttonHeight)
            
            
            ZStack {
                Circle().fill(Color.contentBackground)
                Button {
                    viewModel.onFilterClick()
                } label: {
                    Image("Filter").tint(Color.textColor)
                }
                if (viewModel.filterBadgeNumber > 0) {
                    VStack {
                        HStack {
                            Spacer()
                            Text(String(viewModel.filterBadgeNumber))
                                .frame(width: SizeUtils.smallIconSize, height: SizeUtils.smallIconSize)
                                .background(Color.red)
                                .foregroundColor(Color.white)
                                .smallFont()
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
            }.frame(width: buttonHeight, height: buttonHeight)
            
            ZStack {
                Circle().fill(viewModel.sortToggled ? Color.accentColor : Color.contentBackground)
                Button {
                    viewModel.sortClicked()
                } label: {
                    Image("Sort").tint(viewModel.sortToggled ? Color.white : Color.textColor)
                }
            }.frame(width: buttonHeight, height: buttonHeight)
            
        }.frame(height: 56)
            .padding(.horizontal, SizeUtils.padding)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SearchBarViewModel(onFilterClick: {
            print("clicked filter")
        }, onSortClick: { _ in
            print("clicked Sort")
        }) { text in
            print(text)
        }
        ZStack(alignment: .top) {
            Color.yellow
            VStack(spacing: 20) {
                SearchBarView(viewModel: vm)
            }
        }.previewLayout(.fixed(width: 400, height: 400))
        
    }
}
