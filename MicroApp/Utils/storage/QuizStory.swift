//
//  QuizStory.swift
//  MicroApp
//
//  Created by Tosun, Irem on 23.01.2024.
//

import Foundation
import Quiz

struct QuizStory: Codable, Identifiable {
    var challengeDate: Date
    var category: QuizCategory
    var level: DifficultyLevel
    var challengeList: [ChallengeModel]
    var id: Int { return Int(challengeDate.timeIntervalSince1970) }
}
