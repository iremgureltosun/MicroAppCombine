//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 1.06.2023.
//

import Combine
import Foundation
import Resolver
import Quiz

final class QuestionViewModel: ObservableObject {
    @Injected var scoreManager: ScoreManager
    @Injected var quizManager: QuizManager
    
    @Published public var observedQuestion: Int = 0
    @Published public var selections: [String] = []
    @Published public var navigateToResults = false
    @Published var presentedChallenge: ChallengeEntry?
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {}

    func goToNextQuestion() {
        observedQuestion += 1
    }
}
