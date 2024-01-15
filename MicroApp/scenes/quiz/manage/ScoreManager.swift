//
//  ScoreSubjectUseCase.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Combine
import Foundation

protocol ScoreManager {
    var quizSubject: PassthroughSubject<(Int, Int), Never> { get }
    var answersSubject: PassthroughSubject<(String, Bool), Never> { get }
    func updateScore(pair: (Int, Int))
    func onAnsweredResult(answer: String, result: Bool)
}

final class ScoreManagerImpl: ScoreManager {
    var quizSubject = PassthroughSubject<(Int, Int), Never>()
    var answersSubject = PassthroughSubject<(String, Bool), Never>()

    func updateScore(pair: (Int, Int)) {
        quizSubject.send(pair)
    }

    func onAnsweredResult(answer: String, result: Bool) {
        answersSubject.send((answer, result))
    }
}
