//
//  ResultsView.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Combine
import SwiftUI

struct ResultsView: View {
    @StateObject private var viewModel: ResultsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ResultsViewModel())
    }

    var body: some View {
        Color.gray.overlay {
            VStack {
                ForEach(viewModel.answers.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key)")
                        Image(systemName: value == false ? "multiply.circle" : "checkmark.circle")
                    }
                }
            }
            .onAppear {}
        }.ignoresSafeArea()
            .navigationBarHidden(true)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
