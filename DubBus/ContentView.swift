//
//  ContentView.swift
//  DubBus
//
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    
    var body: some View {
        Group {
            if locationManager.user == nil {
                LocationRequestView()
            }
            else {
                MapScreen()
            }
        }
    }
}
