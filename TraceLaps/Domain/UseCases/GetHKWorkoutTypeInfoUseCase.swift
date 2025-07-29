//
//  GetHKWorkoutTypeInfoUseCase.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import HealthKit

protocol GetHKWorkoutTypeInfoUseCase {
    func call(for workoutType: HKWorkoutActivityType) -> (name: String, symbol: String)
}

struct GetHKWorkoutTypeInfo: GetHKWorkoutTypeInfoUseCase {
    func call(for workoutType: HKWorkoutActivityType) -> (name: String, symbol: String) {
        switch workoutType {
        case .americanFootball:
            return ("American Football", "sportscourt")
        case .archery:
            return ("Archery", "archery")
        case .australianFootball:
            return ("Australian Football", "sportscourt")
        case .badminton:
            return ("Badminton", "sportscourt")
        case .baseball:
            return ("Baseball", "sportscourt")
        case .basketball:
            return ("Basketball", "sportscourt")
        case .bowling:
            return ("Bowling", "sportscourt")
        case .boxing:
            return ("Boxing", "figure.boxing")
        case .climbing:
            return ("Climbing", "figure.climbing")
        case .cricket:
            return ("Cricket", "sportscourt")
        case .crossTraining:
            return ("Cross Training", "figure.cross.training")
        case .curling:
            return ("Curling", "sportscourt")
        case .cycling:
            return ("Cycling", "figure.bike")
        case .dance:
            return ("Dance", "figure.dance")
        case .danceInspiredTraining:
            return ("Dance Inspired Training", "figure.dance")
        case .elliptical:
            return ("Elliptical", "figure.elliptical")
        case .equestrianSports:
            return ("Equestrian Sports", "sportscourt")
        case .fencing:
            return ("Fencing", "figure.fencing")
        case .fishing:
            return ("Fishing", "figure.fishing")
        case .functionalStrengthTraining:
            return ("Functional Strength Training", "figure.strengthtraining.functional")
        case .golf:
            return ("Golf", "figure.golf")
        case .gymnastics:
            return ("Gymnastics", "figure.gymnastics")
        case .handball:
            return ("Handball", "figure.handball")
        case .hiking:
            return ("Hiking", "figure.hiking")
        case .hockey:
            return ("Hockey", "sportscourt")
        case .hunting:
            return ("Hunting", "figure.hunting")
        case .lacrosse:
            return ("Lacrosse", "sportscourt")
        case .martialArts:
            return ("Martial Arts", "figure.martial.arts")
        case .mindAndBody:
            return ("Mind and Body", "figure.mind.and.body")
        case .mixedMetabolicCardioTraining:
            return ("Mixed Cardio", "figure.mixed.cardio")
        case .paddleSports:
            return ("Paddle Sports", "figure.paddle.and.ball")
        case .play:
            return ("Play", "figure.play")
        case .preparationAndRecovery:
            return ("Preparation and Recovery", "figure.cooldown")
        case .racquetball:
            return ("Racquetball", "sportscourt")
        case .rowing:
            return ("Rowing", "figure.rower")
        case .rugby:
            return ("Rugby", "sportscourt")
        case .running:
            return ("Running", "figure.run")
        case .sailing:
            return ("Sailing", "figure.sailing")
        case .skatingSports:
            return ("Skating Sports", "figure.skating")
        case .snowSports:
            return ("Snow Sports", "figure.snowboarding")
        case .soccer:
            return ("Soccer", "sportscourt")
        case .softball:
            return ("Softball", "sportscourt")
        case .squash:
            return ("Squash", "sportscourt")
        case .stairClimbing:
            return ("Stair Climbing", "figure.stairs")
        case .surfingSports:
            return ("Surfing Sports", "figure.surfing")
        case .swimming:
            return ("Swimming", "figure.pool.swim")
        case .tableTennis:
            return ("Table Tennis", "sportscourt")
        case .tennis:
            return ("Tennis", "sportscourt")
        case .trackAndField:
            return ("Track and Field", "sportscourt")
        case .traditionalStrengthTraining:
            return ("Traditional Strength Training", "figure.strengthtraining.traditional")
        case .volleyball:
            return ("Volleyball", "sportscourt")
        case .walking:
            return ("Walking", "figure.walk")
        case .waterFitness:
            return ("Water Fitness", "figure.water.fitness")
        case .waterPolo:
            return ("Water Polo", "sportscourt")
        case .waterSports:
            return ("Water Sports", "figure.water.fitness")
        case .wrestling:
            return ("Wrestling", "figure.wrestling")
        case .yoga:
            return ("Yoga", "figure.yoga")
        default:
            return ("Workout", "figure.walk")
        }
    }
}
