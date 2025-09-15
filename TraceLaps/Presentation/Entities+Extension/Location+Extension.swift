//
//  Location+Extension.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 30/07/2025.
//

import Entities
import CoreLocation

extension LocationPoint {
    convenience init(from cl: CLLocation) {
        self.init(latitude: cl.coordinate.latitude,
                  longitude: cl.coordinate.longitude,
                  timestamp: cl.timestamp)
    }
}
