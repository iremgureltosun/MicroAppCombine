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

protocol QuizManager{
    var response: QuizResponse? { get }
    var totalQuestion: Int { get }
    func getAllQuestions() throws -> AnyPublisher<QuizResponse, Error>
}

final class QuizManagerImpl: QuizManager {
    @Injected var quizService: QuizService
    @Published var response: QuizResponse?
    let totalQuestion: Int = 10
    
    func getAllQuestions() throws -> AnyPublisher<QuizResponse, Error> {
        guard let urlRequest = try QuizResponse.getRequestUrl(amount: totalQuestion, category: AppStorage.selectedCategory, difficulty: AppStorage.selectedLevel, type: QuestionType.multiple) else {
            return Fail(error: QuizError.urlError).eraseToAnyPublisher()
        }
        return try quizService.performRequest(urlRequest: urlRequest)    
    }
}
