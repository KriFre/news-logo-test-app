//
//  FilterView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 19/08/2022.
//

import SwiftUI
import Combine

struct FilterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FilterViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Filter").titleFont()
                    Text("Date").subtitleFont()
                    CalendarView(title: "From", displayTitle: $viewModel.fromDateDisplay, date: Binding(get: {
                        self.viewModel.fromDate ?? Date.now
                    }, set: { newVal in
                        self.viewModel.fromDate = newVal
                    }))
                    CalendarView(title: "To", displayTitle: $viewModel.toDateDisplay, date: Binding(get: {
                        self.viewModel.toDate ?? Date.now
                    }, set: { newVal in
                        self.viewModel.toDate = newVal
                    }))
                    NavigationLink(destination: SearchInView(viewModel: viewModel.getSearchInVM())) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Search in")
                                    .subtitleFont()
                                Spacer()
                                Text(viewModel.searchInDisplay)
                                    .subtitleFont()
                            }
                            Divider().frame(height: SizeUtils.dividerHeight).overlay(Color.seperators)
                        }
                    }
                    Spacer().frame(height: 30)
                }.padding(.top, 30)
                    .padding(.horizontal, SizeUtils.padding)
            }
            .padding(.top, SizeUtils.smallBarHeight)
            .padding(.bottom, 25)
            VStack {
                Spacer()
                Button {
                    viewModel.apply()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Apply Filter").foregroundColor(Color.white)
                            .titleFont()
                        Spacer()
                    }.frame(height: SizeUtils.buttonHeight)
                }.background(Color.accentColor)
                    .clipShape(Capsule())
            }.padding(.horizontal, SizeUtils.padding)
            LogoBar( roundedCorners: false, onBackButton: {
                viewModel.clearData()
            }, onClearAction: {
                viewModel.clearData()
                viewModel.apply()
                self.presentationMode.wrappedValue.dismiss()
            })
        }.hiddenNavigationBarStyle()
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewModel: FilterViewModel(searchParams: DEFAULT_SEARCH_PARAMS, onApply: { newSearchParams in
            print(newSearchParams)
        }))
    }
}
