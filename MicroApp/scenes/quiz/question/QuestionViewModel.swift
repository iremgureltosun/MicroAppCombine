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
    @Published var presentedChallenge: ChallengeEntry?
    @Published var index = 0
    var questions: [ChallengeEntry] = []
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    init() {}

    func collectAnswers() {
        ScoreManager.shared.overviewSubject
            .collect(QuizManager.shared.totalQuestion)
            .receive(on: DispatchQueue.main)
            .sink { quiz in
                print("Completed test!")
                let category = QuizManager.shared.selectedCategory
                let level = QuizManager.shared.selectedLevel
                AppStorage.quizStories.append(QuizStory(challengeDate: Date(), category: category, level: level, challengeList: quiz))
                ApplicationManager.shared.routes.append(.result)
            }
            .store(in: &cancellables)
    }

    func skipQuestion(for presentedChallenge: ChallengeEntry) {
        try? ScoreManager.shared.onAnswered(result: ChallengeModel(challengeEntry: presentedChallenge, answer: nil))
    }

    func getQuestion() {
        ScoreManager.shared.overviewSubject
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Fetched question")
                case let .failure(error):
                    print("Received error on fetch \(error)")
                }
            } receiveValue: { _ in
                    self.index += 1
                    self.presentedChallenge = self.getQuestion(at: self.index)
            }
            .store(in: &cancellables)
    }

    private func getQuestion(at index: Int) -> ChallengeEntry? {
        guard index < questions.count else { return nil }
        return questions[index]
    }
}
