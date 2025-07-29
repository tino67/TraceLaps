//
//  LocationPoint.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class LocationPoint {
    var latitude: Double
    var longitude: Double
    var timestamp: Date

    init(latitude: Double, longitude: Double, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }

    convenience init(from cl: CLLocation) {
        self.init(latitude: cl.coordinate.latitude,
                  longitude: cl.coordinate.longitude,
                  timestamp: cl.timestamp)
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var asCLLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
