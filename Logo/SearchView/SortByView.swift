//
//  SortByView.swift
//  Logo
//
//  Created by Kristaps Freibergs on 20/08/2022.
//

import SwiftUI

struct SortByView: View {
    
    @Binding var uploadDate: Bool
    @Binding var relevance: Bool
    
    func backgroundView() -> some View {
        return Color.background
            .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sort by").titleFont().frame(height: 58).padding(.horizontal, SizeUtils.padding)
            Divider().frame(height: SizeUtils.dividerHeight).overlay(Color.seperators).padding(.leading, SizeUtils.padding)
            ToggleView(title: "Upload date",
                       toggled: $uploadDate,
                       onToggle: {
                uploadDate.toggle()
                relevance.toggle()
            }).padding(.horizontal, SizeUtils.padding)
            Divider().frame(height: SizeUtils.dividerHeight).overlay(Color.seperators).padding(.leading, SizeUtils.padding)
            ToggleView(title: "Relevance",
                       toggled: $relevance,
                       onToggle: {
                uploadDate.toggle()
                relevance.toggle()
            }).padding(.horizontal, SizeUtils.padding)
        }.background(content: {
            ZStack {
                backgroundView()
                    .shadow(color: Color.shadow, radius: 6, x: 0, y: -10)
                backgroundView()
            }
        })
        
    }
}

struct SortByView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.yellow
            SortByView(uploadDate: Binding(get: {true}, set: {_ in}),
                       relevance: Binding(get: {false}, set: {_ in}))
        }
        .previewLayout(.fixed(width: 400, height: 300))
    }
}
