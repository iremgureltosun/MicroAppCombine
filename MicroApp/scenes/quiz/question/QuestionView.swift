//
//  QuizView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 1.06.2023.
//

import SwiftUI
import Quiz

struct QuestionView: View {
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
                        viewModel.skipQuestion(for: presentedChallenge)
                    }
                } else {
                    ActivityIndicator(isAnimating: true)
                }
            }
            .padding(.top, Constants.Spaces.largeSpace)
            .padding(.horizontal, Constants.Spaces.mediumSpace)
            .onAppear{
                Task{
                    try QuizManager.shared.getAllQuestions()
                        .receive(on: DispatchQueue.main)
                        .sink { _ in
                        print("error")
                    } receiveValue: { response in
                        viewModel.questions = response.results ?? []
                        viewModel.presentedChallenge = viewModel.questions.first
                    }
                    .store(in: &viewModel.cancellables)
                }
            }
            .task {
                viewModel.getQuestion()
            }
            .task {
                viewModel.collectAnswers()
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
