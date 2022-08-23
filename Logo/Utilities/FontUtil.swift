//
//  FontUtil.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import SwiftUI

extension View {
    
    func titleFont() -> some View {
        return modifier(TitleFont())
    }
    
    func subtitleFont() -> some View {
        return modifier(SubtitleFont())
    }
    
    func articleTitleFont() -> some View {
        return modifier(ArticleTitleFont())
    }
    
    func descriptionFont() -> some View {
        return modifier(DescriptionFont())
    }
    
    func smallFont() -> some View {
        return modifier(SmallFont())
    }
}

fileprivate struct TitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("OpenSans", size: 17)
                .weight(.bold))
            .foregroundColor(Color.textColor)
    }
}

fileprivate struct SubtitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("OpenSans", size: 15)
                .weight(.semibold))
            .foregroundColor(Color.textColor)
    }
}

fileprivate struct ArticleTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("OpenSans", size: 15)
                .weight(.semibold))
            .foregroundColor(Color.textColor)
    }
}

fileprivate struct DescriptionFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("OpenSans", size: 12)
                .weight(.regular))
            .foregroundColor(Color.textColor)
    }
}

fileprivate struct SmallFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("OpenSans", size: 10)
                .weight(.semibold))
            .foregroundColor(Color.textColor)
    }
}

