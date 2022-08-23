//
//  ViewUtils.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func bottomShadow() -> some View {
        return modifier(BottomShadow())
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

fileprivate struct BottomShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.shadow, radius: 6, x: 0, y: 6)
    }
}
