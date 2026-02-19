//
//  Bus.swift
//  DubBus
//
//

import Foundation
import CoreLocation
import SwiftData

struct Bus: Identifiable {
    let id: String
    let routeNumber: String
    let coordinate: CLLocationCoordinate2D
}


