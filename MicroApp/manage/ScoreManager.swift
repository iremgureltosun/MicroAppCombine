//
//  ScoreSubjectUseCase.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Combine
import Foundation
import Quiz

@MainActor
final class ScoreManager: ObservableObject {
    static let shared = ScoreManager() // The singleton instance

    var overviewSubject = PassthroughSubject<ChallengeModel, Never>()

    private init() {
    }

    func onAnswered(result: ChallengeModel) throws {
        // guard let answer = answer else { throw QuizError.skippedQuestion }
        overviewSubject.send(result)
    }
}




