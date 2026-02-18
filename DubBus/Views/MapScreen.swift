//
//  MapScreen.swift
//  DubBus
//
//

import SwiftUI
import MapKit

struct MapScreen: View {

    @StateObject private var viewModel = BusViewModel()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.2889, longitude: -6.3778),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: viewModel.buses
        ) { bus in
            MapAnnotation(coordinate: bus.coordinate) {
                Image(systemName: "bus.fill")
            }
        }
        .onAppear {
            viewModel.startLiveUpdates()
        }
    }
}
