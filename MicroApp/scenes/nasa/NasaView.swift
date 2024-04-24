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
        VStack(spacing: Constants.Spaces.mediumSpace) {
            ScrollView {
                Text("Astronomy Pic of the Day").font(.title)

                sectionApod

                Text("Asteroids").font(.title)

                sectionAsteroid
            }
            .presentationDragIndicator(.hidden)
        }
        .padding(.horizontal, Constants.Spaces.mediumSpace)
        .onAppear(perform: {
            Task {
                await viewModel.fetchAsteroids()
                await viewModel.fetchApod()
            }
        })
    }

    @ViewBuilder
    private var sectionAsteroid: some View {
        if let nearEarthObjects = viewModel.asteroidResponse?.nearEarthObjects {
            VStack(alignment: .leading) {
                ForEach(nearEarthObjects.sorted(by: { $0.key < $1.key }), id: \.key) { date, nearEarthObjectArray in
                    DisclosureGroup {
                        Divider()
                        ForEach(nearEarthObjectArray, id: \.id) { nearEarthObject in
                            HStack {
                                Text(nearEarthObject.name)
                                Spacer()
                                if nearEarthObject.isPotentiallyHazardousAsteroid {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                }
                            }

                            Divider()
                        }
                    } label: {
                        HStack {
                            Text("\(date)").font(.headline)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var sectionApod: some View {
        if let pic = viewModel.apodResponse {
            VStack(alignment: .leading) {
                RemoteImageView(url: pic.url, contentMode: .fill)

                Text(pic.date)
                    .font(.caption2)
                Text(pic.explanation)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    NasaView()
}
