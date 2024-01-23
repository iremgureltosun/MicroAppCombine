//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 1.06.2023.
//

import Combine
import Foundation
import Quiz
import Resolver

@MainActor
final class QuestionViewModel: ObservableObject {
    @Published public var observedQuestion: Int = 0
    @Published public var selections: [String] = []
    @Published public var navigateToResults = false
    @Published var presentedChallenge: ChallengeEntry?
    var questions: [ChallengeEntry] = []
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    init() {}

    func goToNextQuestion() {
        observedQuestion += 1
    }

    func getQuestion(at index: Int) -> ChallengeEntry? {
        guard index < questions.count else { return nil }
        return questions[index]
    }
}
