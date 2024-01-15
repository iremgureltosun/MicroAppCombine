//
//  NavAppearenceModifier.swift
//  QuizApp
//
//  Created by Tosun, Irem on 2.06.2023.
//

import Foundation
import SwiftUI
import UIKit

struct NavAppearanceModifier: ViewModifier {
    init(foregroundColor: UIColor, tintColor: UIColor?, hideSeperator: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        if hideSeperator {
            appearance.shadowColor = .clear
        }
        let backImage = UIImage(systemName: "chevron.left.circle")
        backImage?.withTintColor(.tintColor, renderingMode: .alwaysOriginal)

        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = tintColor
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func customizeNavigation(foregroundColor: UIColor, tintColor: UIColor, hideSeperator: Bool) -> some View {
        modifier(NavAppearanceModifier(foregroundColor: foregroundColor, tintColor: tintColor, hideSeperator: hideSeperator))
    }
}
