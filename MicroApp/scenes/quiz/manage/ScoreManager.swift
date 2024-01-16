//
//  ScoreSubjectUseCase.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Combine
import Foundation
import Quiz

protocol ScoreManager {
    var overviewSubject: PassthroughSubject<(ChallengeEntry, String), Never> { get }
    
    func onAnswered(result: ChallengeEntry, answer: String?) throws
}

final class ScoreManagerImpl: ScoreManager {
    var overviewSubject = PassthroughSubject<(ChallengeEntry, String), Never>()

    func onAnswered(result: ChallengeEntry, answer: String?) throws {
        guard let answer = answer else { throw QuizError.skippedQuestion }
        overviewSubject.send((result, answer))
    }
}
