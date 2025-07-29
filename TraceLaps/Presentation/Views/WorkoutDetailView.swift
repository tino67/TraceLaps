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

        uiView.delegate = context.coordinator

        let coordinates = locations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

        uiView.addOverlay(polyline)

        guard let startLocation = locations.first, let endLocation = locations.last else {
            return
        }

        let startPin = MKPointAnnotation()
        startPin.title = "Start"
        startPin.coordinate = CLLocationCoordinate2D(latitude: startLocation.latitude, longitude: startLocation.longitude)
        uiView.addAnnotation(startPin)

        let endPin = MKPointAnnotation()
        endPin.title = "Finish"
        endPin.coordinate = CLLocationCoordinate2D(latitude: endLocation.latitude, longitude: endLocation.longitude)
        uiView.addAnnotation(endPin)

        uiView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
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

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "Pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            if let pinAnnotationView = annotationView as? MKPinAnnotationView {
                if annotation.title == "Start" {
                    pinAnnotationView.pinTintColor = .green
                } else if annotation.title == "Finish" {
                    pinAnnotationView.pinTintColor = .red
                }
            }

            return annotationView
        }
    }
}
