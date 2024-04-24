//
//  QuizManager.swift
//  MicroApp
//
//  Created by Tosun, Irem on 16.01.2024.
//

import Combine
import Foundation
import Quiz
import Resolver

@MainActor
final class QuizManager: ObservableObject {
    static let shared = QuizManager() 
    @Injected var quizService: QuizService
    @Published var response: QuizResponse?
    let totalQuestion: Int
    var selectedCategory: QuizCategory
    var selectedLevel: DifficultyLevel

    private init() {
        totalQuestion = 10
        selectedCategory = .animals
        selectedLevel = .easy
    }
    
    func getAllQuestions() throws -> AnyPublisher<QuizResponse, Error> {
        guard let urlRequest = try QuizResponse.getRequestUrl(amount: totalQuestion, category: selectedCategory, difficulty: selectedLevel, type: QuestionType.multiple) else {
            return Fail(error: QuizError.urlError).eraseToAnyPublisher()
        }
        return try quizService.performRequest(urlRequest: urlRequest)
    }
}
