//
//  ScoreCollectorView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import SwiftUI

struct ScoreCollectorView: View {
    @StateObject private var viewModel = ScoreCollectorViewModel()
    var body: some View {
            Capsule()
                .frame(width: 45, height: 25)
                .foregroundColor(Color.black)
                .overlay {
                    Text("\(viewModel.totalSuccess):\(viewModel.totalAnswer)")
                        .foregroundColor(Color.white)
                }
        .onAppear {
            viewModel.listenScore()
        }
    }
}

struct ScoreCollectorView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCollectorView()
    }
}
