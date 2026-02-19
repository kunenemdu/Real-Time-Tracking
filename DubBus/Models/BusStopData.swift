//
//  BusStopData.swift
//  DubBus
//
//

import Foundation
import MapKit
import CoreLocation
import SwiftData

@Model
class BusStop: Identifiable {
    @Attribute(.unique) var stopCode: Int
    var name: String
    var latitude: Double
    var longitude: Double

    var id: Int { stopCode }

    enum CodingKeys: String, CodingKey {
        case stopCode = "stop_code"
        case name = "stop_name"
        case latitude = "stop_lat"
        case longitude = "stop_lon"
    }
    
    // Standard init required for SwiftData @Model
    init(stopCode: Int, name: String, latitude: Double, longitude: Double) {
        self.stopCode = stopCode
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    @Transient
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
