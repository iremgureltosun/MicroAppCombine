//
//  UserDefault.swift
//  QuizApp
//
//  Created by Tosun, Irem on 25.10.2023.
//

import Foundation
import Quiz

struct ChallengeModel: Codable, Identifiable {
    var challengeEntry: ChallengeEntry
    var answer: String?
    var id: String { return UUID().uuidString }
}
