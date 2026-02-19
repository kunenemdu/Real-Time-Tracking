//
//  MapScreen.swift
//  DubBus
//
//

import SwiftUI
import MapKit

struct MapScreen: View {

    @StateObject private var viewModel = BusViewModel()
    @State var searchInput = ""

    //map starting region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.2889, longitude: -6.3778),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    // Center the camera on Tallaght immediately
    @State private var position: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 53.2875, longitude: -6.3664), distance: 1000))
    
    let tallaghtCross = CLLocation(latitude: 53.2875, longitude: -6.3664)
    
    @State private var allStops: [BusStop] = []
    @State private var nearbyStops: [BusStop] = []
        
    //main map
    var body: some View {
        
        Map (position: $position) {
            // 1. Display Bus Stops using Markers (Standard Look)
            
            ForEach(nearbyStops) { stop in
                Annotation(stop.id, coordinate: stop.coordinate) {
                    VStack {
                        Image(systemName: "bus")
                            .padding(8)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                        Text("Route 4")
                            .font(.caption2)
                            .bold()
                    }
                }
            }

                        // 2. Display Buses using Annotations (Custom SwiftUI View)
            ForEach(viewModel.buses) { bus in
                Annotation(bus.id, coordinate: bus.coordinate) {
                    VStack {
                        Image(systemName: "bus")
                            .padding(8)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                        Text("Route 4")
                            .font(.caption2)
                            .bold()
                    }
                }
            }
        }
        //search field
        .overlay(alignment: .top) {
            TextField("Search for stop...", text: $searchInput)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 15)
        }
        .onSubmit {
            
        }
        .onAppear {
            viewModel.startLiveUpdates()
            
            //load big JSON file
            self.allStops = viewModel.loadBusStops()
            
            //filter the stops
            self.nearbyStops = viewModel.updateVisibleStops(near: tallaghtCross, allLoadedStops: allStops)
        }
        .mapControls {
            MapUserLocationButton()
        }
    }

}
