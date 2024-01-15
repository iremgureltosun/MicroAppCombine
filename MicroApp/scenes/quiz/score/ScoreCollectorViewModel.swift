//
//  ScoreCollectorViewModel.swift
//  QuizApp
//
//  Created by Tosun, Irem on 5.06.2023.
//

import Foundation
import Resolver

final class ScoreCollectorViewModel: ObservableObject {
    @Injected var scoreUseCase: ScoreManager
}
