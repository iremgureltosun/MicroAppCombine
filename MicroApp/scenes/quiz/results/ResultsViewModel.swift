//
//  ResultsViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Foundation
import Quiz

final class ResultsViewModel: ObservableObject {
    @Published var stories = AppStorage.quizStories
    var sortedStories: [QuizStory] {
        stories.sorted(by: { $0.challengeDate < $1.challengeDate })
    }
}

extension ChallengeEntry {
    var allAnswers: [String] {
        var list = incorrectAnswers
        list.append(correctAnswer)
        return list.shuffled()
    }
}

extension QuizStory {
    var totalScore: Double {
        let correctAnswerCount = challengeList.filter { $0.answer == $0.challengeEntry.correctAnswer }.count
        return Double(correctAnswerCount)
    }
}
private extension String {
    func toDate(dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
}
extension Date {
    func toString(dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
