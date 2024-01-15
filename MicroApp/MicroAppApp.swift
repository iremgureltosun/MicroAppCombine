//
//  MicroAppApp.swift
//  MicroApp
//
//  Created by Tosun, Irem on 13.11.2023.
//

import SwiftUI

@main
struct MicroAppApp: App {
    @StateObject private var appManager = ApplicationManager.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appManager.routes) {
                ZStack {
                    TabView {
                        LaunchQuizView()
                            .environmentObject(appManager)
                            .tabItem {
                                Label("Quiz", systemImage: "pencil")
                            }
                            .navigationTitle("Test Sheets")

                        NasaView()
                            .tabItem {
                                Label("Space", systemImage: "airplane")
                            }
                    }
                    
                   
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .question:
                        QuestionView()
                            .environmentObject(appManager)
                    case .result:
                        ResultsView()
                            .environmentObject(appManager)
                    }
                }
            }
        }
    }
}
