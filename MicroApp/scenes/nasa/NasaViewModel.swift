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
public final class NasaViewModel: ObservableObject {
    //@Injected private var apodService: ApodServiceProtocol
    @Injected private var asteroidService: AsteriodServiceProtocol
    //@Injected private var marsPhotoService: MarsPhotoServiceProtocol

    @Published var isLoading: Bool = true
    @Published var viewState: ViewStates = .success
    @Published var apodResponse: ApodResponse? = nil
    @Published var asteroidResponse: AsteroidsResponse? = nil
    @Published var photoResponse: MarsPhotoResponse? = nil

    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.isLoading = true
        self.viewState = .success
        self.apodResponse = nil
        self.asteroidResponse = nil
        self.photoResponse = nil
        self.cancellables = []
    }
    
//    func fetchApod() async throws {
//        do {
//            // Fetching astronomy picture of today
//            apodResponse = try await apodService.performRequest()
//            apodTitle = "Astronomy Picture of the Day"
//        } catch {
//            viewState = .error
//        }
//    }

    func fetchAsteroids() async throws {
        do {
            // Fetching near earth Asteroid information
            let today = Date()
            let calendar = Calendar.current
            if let endDate = calendar.date(byAdding: .day, value: 7, to: today) {
                try asteroidService.search(startDate: today.toString(), endDate: endDate.toString(), method: .get)
                    .sink(receiveCompletion: { error in
                        print(error)
                    }, receiveValue: { response in
                        self.asteroidResponse = response
                    })
                    .store(in: &cancellables)
            }
        } catch {
            viewState = .error
        }
    }

//    func getRandomMarsPhotos() async throws {
//        let today = Date()
//        let calendar = Calendar.current
//        if let startDate = calendar.date(byAdding: .day, value: -3000, to: today) {
//            if let date = generateRandomDate(startDate: startDate, endDate: today) {
//                photoResponse = try await marsPhotoService.performRequest(startDate: date.toString())
//            }
//        }
//    }
//
//    private func generateRandomDate(startDate: Date, endDate: Date) -> Date? {
//        let calendar = Calendar.current
//        let start = calendar.startOfDay(for: startDate)
//        let end = calendar.startOfDay(for: endDate)
//
//        let timeInterval = end.timeIntervalSince(start)
//        guard timeInterval > 0 else {
//            return nil
//        }
//
//        let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(timeInterval)))
//        let randomDate = start.addingTimeInterval(randomTimeInterval)
//
//        return randomDate
//    }
}

extension Date {
    func toString(dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
