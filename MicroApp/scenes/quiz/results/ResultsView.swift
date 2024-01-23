//
//  ResultsView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Combine
import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel: ResultsViewModel = ResultsViewModel()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.sortedStories, id: \.id) { story in
                    VStack {
                        DisclosureGroup {
                            getHeader(for: story)
                                .padding()

                            Divider()
                            
                            ForEach(story.challengeList, id: \.id) { entry in
                                getChallengeView(for: entry)
                                
                                Divider()
                            }
                        } label: {
                            HStack(alignment: .top) {
                                Text(story.challengeDate.toString())
                                Text("Score: \(story.totalScore)")
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Constants.Spaces.mediumSpace)
        .navigationTitle("Quiz History")
        .navigationBarHidden(false)
    }

    @ViewBuilder private func getHeader(for story: QuizStory) -> some View {
        HStack {
            Text("Category: \(story.category.title)")
                .fontWeight(.bold)
            Spacer()
            Text("Category: \(story.level.rawValue)")
                .fontWeight(.bold)
        }
    }

    @ViewBuilder func getChallengeView(for entry: ChallengeModel) -> some View {
        VStack {
            Group {
                Text(entry.challengeEntry.question)
                    .fontWeight(.bold)

                if let answer = entry.answer {
                    Text("You answered: \(answer)")
                        .foregroundColor(answer == entry.challengeEntry.correctAnswer ? .green : .red)
                } else {
                    Text("You skipped")
                }
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(entry.challengeEntry.allAnswers, id: \.self) { answer in
                HStack {
                    Image(systemName: answer == entry.challengeEntry.correctAnswer ? "checkmark.circle" : "multiply.circle")
                    Text(answer)
                    Spacer()
                }
                .padding(.leading, Constants.Spaces.mediumSpace)
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
