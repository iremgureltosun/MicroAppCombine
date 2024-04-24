//
//  NasaViewModel.swift
//  MicroApp
//
//  Created by Tosun, Irem on 14.11.2023.
//

import Combine
import Foundation
import Nasa
import Resolver
import SwiftUI

@MainActor
final class NasaViewModel: ObservableObject {
    @Injected private var apodService: ApodService
    @Injected private var asteroidService: AsteriodService
    @Published var isLoading: Bool = true
    @Published var viewState: ViewStates = .success
    @Published var apodResponse: ApodResponse? = nil
    @Published var asteroidResponse: AsteroidsResponse? = nil

    private var cancellables: Set<AnyCancellable> = []

    init() {
    }

    func fetchApod() async {
        do {
            let endDate = Date().addDate(7)
            try apodService.search(startDate: Date(), endDate: endDate)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    self.viewState = .error
                }, receiveValue: { response in
                    self.apodResponse = response
                })
                .store(in: &cancellables)
        } catch {
            viewState = .error
        }
    }

    func fetchAsteroids() async {
        do {
            let endDate = Date().addDate(7)
            try asteroidService.search(startDate: Date(), endDate: endDate)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    self.viewState = .error
                }, receiveValue: { response in
                    self.asteroidResponse = response
                })
                .store(in: &cancellables)

        } catch {
            viewState = .error
        }
    }
}

extension Date {
    func addDate(_ date: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 7, to: self)!
    }

   
}
