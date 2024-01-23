//
//  ApplicationManager.swift
//  QuizApp
//
//  Created by Tosun, Irem on 25.10.2023.
//
import Foundation
import Network

enum LoadingState: Hashable, Identifiable {
    case idle
    case loading(String)

    var id: Self {
        return self
    }
}

enum Route: Hashable {
    case question
    case result
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}

class ApplicationManager: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var routes: [Route]
    @Published var errorWrapper: ErrorWrapper?
    static let shared = ApplicationManager() // The singleton instance

    private init() {
        // Private initializer prevents external instantiation
        routes = []
        errorWrapper = nil
    }
}
