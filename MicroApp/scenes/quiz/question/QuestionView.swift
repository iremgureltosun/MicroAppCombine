//
//  QuizView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 1.06.2023.
//

import Combine
import Network
import Quiz
import SwiftUI
import UIKit

struct QuestionView: View {
    @EnvironmentObject private var appManager: ApplicationManager
    @EnvironmentObject private var quizManager: QuizManager
    @StateObject private var viewModel: QuestionViewModel

    init() {
        _viewModel = StateObject(wrappedValue: QuestionViewModel())
    }

    var body: some View {
        NavigationView {
            VStack(spacing: Constants.Spaces.smallSpace) {
                if let presentedChallenge = viewModel.presentedChallenge {
                    Text(presentedChallenge.correctedQuestion)
                        .font(.title2)

                    selectionsView(result: presentedChallenge)
                        .padding(.top, Constants.Spaces.mediumSpace)

                    Spacer()

                    RoundedButton(title: "Skip") {
                        try? ScoreManager.shared.onAnswered(result: ChallengeModel(challengeEntry: presentedChallenge, answer: nil))
                        viewModel.goToNextQuestion()
                    }
                } else {
                    ActivityIndicator(isAnimating: true)
                }
            }
            .onChange(of: viewModel.navigateToResults) { _, newValue in
                if newValue {
                    appManager.routes.append(.result)
                }
            }
            .padding(.top, Constants.Spaces.largeSpace)
            .padding(.horizontal, Constants.Spaces.mediumSpace)
            .onAppear{
                Task{
                    try QuizManager.shared.getAllQuestions().sink { _ in
                        print("error")
                    } receiveValue: { response in
                        viewModel.questions = response.results ?? []
                        viewModel.presentedChallenge = viewModel.questions.first
                    }
                    .store(in: &viewModel.cancellables)
                }
            }
            .task {
                Task{
                    viewModel.$observedQuestion
                                .receive(on: DispatchQueue.main)
                                .sink { completion in
                                    switch completion {
                                    case .finished:
                                        print("Fetched question")
                                    case let .failure(error):
                                        print("Received error on fetch \(error)")
                                    }
                                } receiveValue: { index in
                                    self.viewModel.presentedChallenge = viewModel.getQuestion(at: index)
                                }
                                .store(in: &viewModel.cancellables)
                }
            }
            .task {
                ScoreManager.shared.overviewSubject
                    .collect(QuizManager.shared.totalQuestion)
                    .receive(on: DispatchQueue.main)
                    .sink { quiz in
                        print("Completed test!")
                        let category = QuizManager.shared.selectedCategory
                        let level = QuizManager.shared.selectedLevel
                        AppStorage.quizStories.append(QuizStory(challengeDate: Date(), category: category, level: level, challengeList: quiz))
                        appManager.routes.append(.result)
                    }
                    .store(in: &viewModel.cancellables)
            }
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                ScoreCollectorView()
            }
        })
    }

    @ViewBuilder
    func getSelection(result: ChallengeEntry, answer: String) -> some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(Color.blue.opacity(0.5))
            .shadow(
                color: .black.opacity(0.4),
                radius: Constants.shadowRadius,
                x: 0,
                y: 4
            )
            .frame(height: Constants.Heights.small)
            .overlay {
                Text(answer)
                    .font(.title3)
                    .minimumScaleFactor(0.06)
                    .padding(.horizontal, Constants.Spaces.xlargeSpace)
            }
            .onTapGesture {
                withAnimation {
                    try? ScoreManager.shared.onAnswered(result: ChallengeModel(challengeEntry: result, answer: answer))
                    viewModel.goToNextQuestion()
                }
            }
    }

    @ViewBuilder
    private func selectionsView(result: ChallengeEntry) -> some View {
        ForEach(result.selections, id: \.self) { answer in
            getSelection(result: result, answer: answer)
        }
    }
}

#Preview {
    QuestionView()
}
