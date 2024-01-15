//
//  NasaView.swift
//  MicroApp
//
//  Created by Tosun, Irem on 14.11.2023.
//

import SwiftUI

struct NasaView: View {
    @StateObject private var viewModel: NasaViewModel

    init() {
        _viewModel = StateObject(wrappedValue: NasaViewModel())
    }

    var body: some View {
        ZStack {
            VStack {
                sectionAsteroid
            }
        }.ignoresSafeArea()
    }
    
    @ViewBuilder
    private var sectionAsteroid: some View {
        VStack(alignment: .leading) {
            if let nearEarthObjects = viewModel.asteroidResponse?.nearEarthObjects {
                ForEach(nearEarthObjects.sorted(by: { $0.key < $1.key }), id: \.key) { date, nearEarthObjectArray in
                    // 'date' is the key (String) of the dictionary
                    // 'nearEarthObjectArray' is the array of NearEarthObject values

                    Text("Date: \(date)").font(.headline)

                    ForEach(nearEarthObjectArray, id: \.id) { nearEarthObject in
                        // Access individual NearEarthObject within the array
                        Text("ID: \(nearEarthObject.id), Name: \(nearEarthObject.name), Potentially Hazardous: \(nearEarthObject.isPotentiallyHazardousAsteroid.description)")
                        // Add more properties as needed
                    }

                    Divider() // Separate entries for better readability
                }
            }
        }
    }
}

extension String {
    func toDate(dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
}

#Preview {
    NasaView()
}
