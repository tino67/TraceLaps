//
//  Formatters.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation

class Formatters {
    static let shared = Formatters()

    private let measurementFormatter: MeasurementFormatter
    private let dateComponentsFormatter: DateComponentsFormatter

    private init() {
        measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.unitStyle = .medium

        dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
        dateComponentsFormatter.unitsStyle = .positional
    }

    func format(distance: Double) -> String {
        let distanceInMeters = Measurement(value: distance, unit: UnitLength.meters)
        return measurementFormatter.string(from: distanceInMeters)
    }

    func format(duration: Double) -> String? {
        return dateComponentsFormatter.string(from: duration)
    }

    func format(pace: Double, distance: Double) -> String {
        let speed = Measurement(value: duration / distance, unit: UnitSpeed.secondsPerMeter)
        return measurementFormatter.string(from: speed)
    }
}
