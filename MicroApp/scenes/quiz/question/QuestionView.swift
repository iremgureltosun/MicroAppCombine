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
    @State var cancellableAnswers: AnyCancellable?

    init() {
        _viewModel = StateObject(wrappedValue: QuestionViewModel())
    }

    var body: some View {
        NavigationView {
            VStack(spacing: Constants.Spaces.smallSpace) {
                if let result = viewModel.response?.results?.first {
                    Text(result.correctedQuestion)
                        .font(.title2)

                    selectionsView(result: result)
                        .padding(.top, Constants.Spaces.mediumSpace)

                    Spacer()

                } else {
                    ActivityIndicator(isAnimating: true)
                }
                RoundedButton(title: "Skip") {
                    next(nil, nil)
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
                do {
                    try viewModel.getQuestion()
                } catch {}
                cancellableAnswers = viewModel.scoreUseCase.answersSubject
                    .collect()
                    .sink { list in
                        for output in list {
                            viewModel.answers[output.0] = output.1
                        }
                    }
            }
        }.navigationBarTitle(AppStorage.selectedCategory.title)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    ScoreCollectorView()
                }
            })
    }

    @ViewBuilder
    func getSelection(result: Result, answer: String) -> some View {
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
                    next(result, answer)
                }
            }
    }

    private func next(_ result: Result?, _ answer: String?) {
        viewModel.calculateScore(result: result, answer: answer)
        viewModel.goToNextQuestion()
        guard let count = viewModel.response?.results?.count, count > 0 else {
            viewModel.navigateToResults = true
            viewModel.scoreUseCase.answersSubject.send(completion: .finished)

            return
        }
    }

    @ViewBuilder
    private func selectionsView(result: Result) -> some View {
        ForEach(result.selections, id: \.self) { answer in
            getSelection(result: result, answer: answer)
        }
    }
}

#Preview {
    QuestionView()
}
