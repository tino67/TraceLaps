//
//  MapView.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 29/07/2025.
//

import SwiftUI
import MapKit
import Entities

struct MapView: View {
    let locations: [LocationPoint]

    var body: some View {
        Map {
            let coords: [CLLocationCoordinate2D] = locations
                .sorted(by: { $0.timestamp < $1.timestamp })
                .map { $0.coordinate }
            if let start = coords.first {
                Marker("Start", coordinate: start)
            }
            if let finish = coords.last {
                Marker("Finish", coordinate: finish)
            }

            if !coords.isEmpty {
                MapPolyline(coordinates: coords)
                    .stroke(.blue, lineWidth: 3)
            }
        }
    }
}
