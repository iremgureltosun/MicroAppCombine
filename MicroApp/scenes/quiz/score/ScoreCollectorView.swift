//
//  ScoreCollectorView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Combine
import SwiftUI

struct ScoreCollectorView: View {
    @StateObject private var viewModel = ScoreCollectorViewModel()
    @State var cancellable: AnyCancellable?
    @State private var totalSuccess: Int = 0
    @State private var totalAnswer: Int = 1
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.red)
            Text("\(totalSuccess):\(totalAnswer)")
                .foregroundColor(.white)
                .scaleEffect(1)
        }
        .onAppear {
            self.cancellable = ScoreManager.shared.overviewSubject
                .receive(on: DispatchQueue.main)
                //.retry(2)
                .sink { challengeModel in
                    if let answer = challengeModel.answer {
                        totalSuccess += challengeModel.challengeEntry.isTrue(answer) ? 1 : 0
                    }
                    totalAnswer += 1
                }
        }
    }
}

struct ScoreCollectorView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCollectorView()
    }
}
