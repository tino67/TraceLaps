//
//  WorkoutDetailView.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import SwiftUI
import MapKit

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        VStack {
            MapView(locations: workout.locations)
                .frame(height: 300)

            VStack(alignment: .leading, spacing: 10) {
                Text("Workout Details")
                    .font(.title)

                HStack {
                    Text("Date:")
                        .font(.headline)
                    Text(workout.date, style: .date)
                        .font(.subheadline)
                }

                HStack {
                    Text("Duration:")
                        .font(.headline)
                    Text(String(format: "%.2f", workout.duration / 60))
                        .font(.subheadline)
                }

                HStack {
                    Text("Distance:")
                        .font(.headline)
                    Text(String(format: "%.2f km", workout.distance / 1000))
                        .font(.subheadline)
                }

                HStack {
                    Text("Calories:")
                        .font(.headline)
                    Text(String(format: "%.2f kcal", workout.calories))
                        .font(.subheadline)
                }

                HStack {
                    Text("Average Pace:")
                        .font(.headline)
                    Text(String(format: "%.2f min/km", (workout.duration / 60) / (workout.distance / 1000)))
                        .font(.subheadline)
                }
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Workout Detail")
    }
}

struct MapView: UIViewRepresentable {
    let locations: [WorkoutLocation]

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard !locations.isEmpty else { return }

        let coordinates = locations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

        uiView.addOverlay(polyline)
        uiView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        uiView.delegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
