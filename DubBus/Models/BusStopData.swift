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

    // Custom initializer to handle the "Index 112" mismatch
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        // Try to decode stopID as a String; if it fails, decode as Int and convert to String
//        if let stringID = try? container.decode(String.self, forKey: .stopID) {
//            self.stopID = stringID
//        } else if let intID = try? container.decode(Int.self, forKey: .stopID) {
//            self.stopID = String(intID)
//        } else {
//            throw DecodingError.typeMismatch(String.self, .init(codingPath: [CodingKeys.stopID], debugDescription: "stop_id is neither String nor Int"))
//        }
//
//        // Standard decoding for others
//        self.stopID = try container.decode(String.self, forKey: .stopID)
//        self.stopCode = try container.decode(Int.self, forKey: .stopCode)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.latitude = try container.decode(Double.self, forKey: .latitude)
//        self.longitude = try container.decode(Double.self, forKey: .longitude)
//    }
    
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
