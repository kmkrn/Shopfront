//
//  FruitCardModifier.swift
//  Shopfront (iOS)
//
//  Created by denpazakura on 27/08/2021.
//

import SwiftUI

protocol CardStyler {
    func basicOverlayColor() -> Color
    func headlineFont() -> Font
    func borderColor() -> Color
}

struct FruitCardStyler {
    private let style: CardStyle
    
    init(style: CardStyle) {
        self.style = style
    }
}

extension FruitCardStyler: CardStyler {
    func headlineFont() -> Font {
        switch self.style {
        case .minimalistic:
            return Font.system(size: 30).weight(.light)
        default:
            return Font.system(size: 30).weight(.light)
        }
    }
    
    func basicOverlayColor() -> Color {
        switch self.style {
        case .minimalistic:
            return Color.white
        case .roundedCorners:
            return Color.black
        }
    }
    
    func borderColor() -> Color {
        switch self.style {
        case .minimalistic:
            return Color.clear
        case .roundedCorners:
            return Color.black
        }
    }
}

struct CardModifierMinimal: ViewModifier {
    private let styler = FruitCardStyler(style: .minimalistic)
    
    func body(content: Content) -> some View {
        content
            .border(styler.borderColor(), width: 0)
            .font(styler.headlineFont())
            .foregroundColor(styler.basicOverlayColor())
    }}

struct CardModifierRounded: ViewModifier {
    private let styler = FruitCardStyler(style: .roundedCorners)
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .font(styler.headlineFont())
            .foregroundColor(styler.basicOverlayColor())
    }
}
