//
//  LaunchView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 1.06.2023.
//
import Network
import Quiz
import SwiftUI

struct LaunchQuizView: View {
    @EnvironmentObject private var appManager: ApplicationManager
    @EnvironmentObject private var quizManager: QuizManager
    @State var level: DifficultyLevel = .easy
    @State var category: QuizCategory = .animals

    // Constants for labels and icons
    private static let levelLabelText = "Select a Difficulty Level"
    private static let categoryLabelText = "Choose a Quiz Category"
    private static let levelIconName = "star.circle.fill"
    private static let categoryIconName = "list.bullet.rectangle.fill"

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Label(
                    title: { Text(Self.levelLabelText) },
                    icon: { Image(systemName: Self.levelIconName) }
                )

                Picker(Self.levelLabelText, selection: $level) {
                    ForEach(DifficultyLevel.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }

                Label(
                    title: { Text(Self.categoryLabelText) },
                    icon: { Image(systemName: Self.categoryIconName) }
                )

                Picker(Self.categoryLabelText, selection: $category) {
                    ForEach(QuizCategory.allCases, id: \.self) {
                        Text($0.title)
                    }
                }

                Spacer()

                RoundedButton(title: "Next") {
                    quizManager.selectedCategory = category
                    quizManager.selectedLevel = level
                    appManager.routes.append(.question)
                }
                .padding(.bottom, Constants.Spaces.largeSpace)
            }
            .padding(.horizontal, Constants.Spaces.mediumSpace)
            .navigationTitle("Quiz App")
            .toolbar {
                // Menu on the Left
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Quiz Stories") {
                            appManager.routes.append(.result)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarTitle("")
    }
}

#Preview {
    LaunchQuizView()
}
