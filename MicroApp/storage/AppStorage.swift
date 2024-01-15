//
//  AppStorage.swift
//  QuizApp
//
//  Created by Tosun, Irem on 25.10.2023.
//

import Foundation
import Network
import Quiz

enum AppStorage {
    @UserDefault("selected_category", defaultValue: QuizCategory.animals)
    static var selectedCategory: QuizCategory

    @UserDefault("selected_level", defaultValue: DifficultyLevel.easy)
    static var selectedLevel: DifficultyLevel
}
