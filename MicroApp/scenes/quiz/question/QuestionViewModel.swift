//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 1.06.2023.
//

import Combine
import Foundation
import Network
import Quiz
import Resolver
import SwiftUI


final class QuestionViewModel: ObservableObject {
    @Injected var serviceProvider: QuizServiceProtocol
    @Injected var scoreUseCase: ScoreManager
    @EnvironmentObject private var appManager: ApplicationManager
    @Published var response: QuizResponse?
    var searchCancellable: AnyCancellable?
    @Published public var selections: [String] = []
    @Published public var navigateToResults = false
    @Published public var answers: [String: Bool] = [:]
    @Published public var totalQuestion: Int = 10

    init() {}

    func getQuestion() throws {
        guard let urlRequest = try QuizResponse.getRequestUrl(amount: totalQuestion, category: AppStorage.selectedCategory, difficulty: AppStorage.selectedLevel, type: QuestionType.multiple) else {
            return
        }
        searchCancellable = try serviceProvider.performRequest(urlRequest: urlRequest)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Fetched question")
                case let .failure(error):
                    print("Received error on fetch \(error)")
                }
            } receiveValue: { response in
                self.response = response
            }
    }

    func goToNextQuestion() {
        guard let results = response?.results, results.isEmpty == false else { return }
        _ = response?.results?.removeFirst(1)
    }

    func calculateScore(result: Result?, answer: String?) {
        guard let result = result, let answer = answer else {
            scoreUseCase.updateScore(pair: (0, 1))
            return
        }
        if result.isTrue(answer: answer) {
            scoreUseCase.updateScore(pair: (1, 1))
            scoreUseCase.answersSubject.send((answer, true))
        } else {
            scoreUseCase.updateScore(pair: (0, 1))
            scoreUseCase.answersSubject.send((answer, false))
        }
    }
}
