//
//  LocationRequestView.swift
//  DubBus
//
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack {
            Color(.teal)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Privacy")
                    .font(.headline)
                padding()
                VStack {
                    Button("Location"){
                        LocationManager.shared.requestLocation()
                    }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    Button("Notifications"){}
                        .buttonStyle(.borderedProminent)
                }
                Spacer()
            }
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
