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
    @StateObject private var viewModel: QuestionViewModel

    init() {
        _viewModel = StateObject(wrappedValue: QuestionViewModel())
    }

    var body: some View {
        NavigationView {
            VStack(spacing: Constants.Spaces.smallSpace) {
                if let presentedChallenge = viewModel.presentedChallenge{
                    Text(presentedChallenge.correctedQuestion)
                        .font(.title2)

                    selectionsView(result: presentedChallenge)
                        .padding(.top, Constants.Spaces.mediumSpace)

                    Spacer()

                    RoundedButton(title: "Skip") {
                        try? viewModel.scoreManager.onAnswered(result: presentedChallenge, answer: nil)
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
            .onAppear {
                Task{
                    try viewModel.quizManager.getAllQuestions()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("Fetched question")
                        case let .failure(error):
                            print("Received error on fetch \(error)")
                        }
                    } receiveValue: { response in
                        self.viewModel.presentedChallenge = response.results?.first
                        print("PresentedChallenge: \(self.viewModel.presentedChallenge)")
                    }
                    .store(in: &viewModel.cancellables)
                }
            }
            .task {
                viewModel.scoreManager.overviewSubject
                    .collect(viewModel.quizManager.totalQuestion)
                    .sink { item in
                        print("collected item: \(item)")
                    }
                    .store(in: &viewModel.cancellables)
            }
            .onChange(of: viewModel.observedQuestion) {
                _ = viewModel.quizManager.response.publisher.dropFirst(viewModel.observedQuestion)
            }
        }
        .navigationBarTitle(AppStorage.selectedCategory.title)
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
                    try? viewModel.scoreManager.onAnswered(result: result, answer: answer)
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
