//
//  ScoreCollectorViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//
import Combine
import Foundation

@MainActor
final class ScoreCollectorViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var totalSuccess: Int = 0
    @Published var totalAnswer: Int = 1
    
    
    func listenScore(){
        ScoreManager.shared.overviewSubject
            .receive(on: DispatchQueue.main)
            //.retry(2)
            .sink { challengeModel in
                if let answer = challengeModel.answer {
                    self.totalSuccess += challengeModel.challengeEntry.isTrue(answer) ? 1 : 0
                }
                self.totalAnswer += 1
            }.store(in: &cancellables)
    }
}
