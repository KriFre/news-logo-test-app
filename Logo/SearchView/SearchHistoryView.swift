//
//  SearchHistoryView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import SwiftUI

struct SearchHistoryView: View {
    
    @ObservedObject var viewModel: SearchHistoryViewModel
    
    var body: some View {
        List {
            Text("Search History")
                .titleFont()
                .removeListRowDefaults()
                .padding(SizeUtils.padding)
            ForEach(viewModel.searchHistory, id: \.self) { item in
                VStack {
                    Button {
                        viewModel.onSelection(item)
                    } label: {
                        HStack {
                            Text(item)
                                .subtitleFont()
                            Spacer()
                        }
                    }
                    Divider().frame(height: SizeUtils.dividerHeight).overlay(Color.background)
                }.padding(.leading, SizeUtils.padding)
                
            }.removeListRowDefaults()
            
        }.listStyle(.plain)
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(viewModel: SearchHistoryViewModel(onSelection: { selection in
            print(selection)
        })).previewLayout(.fixed(width: 400, height: 600))
    }
}
