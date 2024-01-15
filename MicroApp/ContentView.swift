//
//  ContentView.swift
//  MicroApp
//
//  Created by Tosun, Irem on 13.11.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LaunchQuizView()
                .tabItem {
                    Label("Quiz", systemImage: "lightbulb")
                }

            NasaView()
                .tabItem {
                    Label("Mars", systemImage: "moon")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}
