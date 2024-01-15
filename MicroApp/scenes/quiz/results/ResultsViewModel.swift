//
//  ResultsViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Foundation

final class ResultsViewModel: ObservableObject {
    @Published public var answers: [String: Bool]
    @Published public var totalQuestion: Int

    init() {
        answers = [:]
        totalQuestion = 0
    }
}
