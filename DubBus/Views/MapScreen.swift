//
//  MapScreen.swift
//  DubBus
//
//

import SwiftUI
import MapKit
import SwiftData

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
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 53.2875, longitude: -6.3664), distance: 2000))
    
    let tallaghtCross = CLLocation(latitude: 53.2875, longitude: -6.3664)
    
    @Query var allStops: [BusStop]
    var nearbyStops: [BusStop]{
        return viewModel.updateVisibleStops(near: tallaghtCross, allLoadedStops: allStops)
    }
    @State var sheetPresented: Bool = true
    @State var nearbyButtonVisibility: Bool = true
    
    
    //main map
    var body: some View {
        
        Map (position: $position) {
            // 1. Display Bus Stops using Markers (Standard Look)
            
            ForEach(nearbyStops) { stop in
                Annotation(String(stop.stopCode), coordinate: stop.coordinate) {
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
            VStack {
                searchBar
                Spacer()
                
                // Button only visible if sheet is NOT showing
                if !sheetPresented {
                    Button("Nearby Stops") {
                        sheetPresented = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .transition(.opacity)
                }
                
            }
        }
        .onSubmit {
            
        }
        .onAppear {
            viewModel.startLiveUpdates()
        }
        .mapControls {
            MapUserLocationButton()
        }
        
        //bottom sheet
        .sheet(isPresented: $sheetPresented) {
            VStack {
                Text("Nearby Stops")
                    .padding()
                    .font(.headline)

                List(nearbyStops) { stop in
                    HStack {
                        Image(systemName: "bus.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text(stop.name)
                                .font(.body)
                            Text("Code: " + (String(stop.stopCode)))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .animation(.default, value: sheetPresented)
        }
        
        //tapping map
        .onTapGesture {
            
        }
    }
    
    var searchBar: some View {
        TextField("Search for stop...", text: $searchInput)
            .padding(12)
            .background(.white)
            .padding()
            .shadow(radius: 15)
            .onChange(of: searchInput) { oldQuery, newQuery in
                viewModel.searchStops(named: newQuery, from: allStops)
            }
    }
}
