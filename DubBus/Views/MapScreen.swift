//
//  MapScreen.swift
//  DubBus
//
//

import SwiftUI
import SwiftData
import MapKit

struct MapScreen: View {

    @StateObject private var viewModel = BusViewModel()
    @StateObject private var mapScreenModel = MapScreenModel()
    @State var searchInput = ""
    
    //zoom in on user then load map
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
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
            UserAnnotation()
            // 1. Display Bus Stops using Markers (Standard Look)
            ForEach(nearbyStops) { stop in
                Annotation(String(stop.stopCode), coordinate: stop.coordinate) {
                    VStack {
                        Image(systemName: "bus")
                            .padding(8)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
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
                        
                    }
                }
            }
            
        }
        .overlay(alignment: .top) {
            VStack {
                //search field
                SearchOverlay (
                    searchText: $searchInput,
                    filteredStops: viewModel.foundStops,
                    onSelect: { stop in
                        print(stop.name)
                    })
                
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

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
