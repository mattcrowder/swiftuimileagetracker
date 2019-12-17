//
//  HealthKit.swift
//  swiftuimileagetracker
//
//  Created by Matt Crowder on 12/16/19.
//  Copyright © 2019 Matt Crowder. All rights reserved.
//

import Foundation
import HealthKit
private let healthStore = HKHealthStore()
private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

class DateRange {
    var startDate: Date
    var endDate: Date
    
    var index: Int = -1
    var value: Double = 0
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
func getCustomWorkouts(type: HKWorkoutActivityType, ranges: [DateRange], completion: @escaping ([DateRange]) -> Void) {
    let predicate = HKQuery.predicateForWorkouts(with: type)

    let query = HKSampleQuery(
        sampleType: HKSampleType.workoutType(),
        predicate: predicate,
        limit: 0,
        sortDescriptors: nil, resultsHandler: { (_: HKSampleQuery, results: [HKSample]!, _) -> Void in
            var distances = ranges.enumerated().map { (arg) -> DateRange in
                
                let (index, range) = arg
                range.index = index
                return range
            }
            
            for r in results {
                guard let result: HKWorkout = r as? HKWorkout else {
                    return
                }
                let value = result.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
                distances = distances.map { range in
                    if result.startDate.isInRange(date: range.startDate, and: range.endDate) {
                        range.value += value
                    }
                    return range
                }
                
//                if result.startDate.isInRange(date: startDate, and: endDate ?? Date()) {
//                    distance += value
//                }
            }
            DispatchQueue.main.async {
                completion(distances)
            }
        }
    )

    healthStore.execute(query)
}
func getCustomWorkout(type: HKWorkoutActivityType, startDate: Date, endDate: Date?, completion: @escaping (Double) -> Void) {
    let predicate = HKQuery.predicateForWorkouts(with: type)

    let query = HKSampleQuery(
        sampleType: HKSampleType.workoutType(),
        predicate: predicate,
        limit: 0,
        sortDescriptors: nil, resultsHandler: { (_: HKSampleQuery, results: [HKSample]!, _) -> Void in
            var distance = 0.0
            for r in results {
                guard let result: HKWorkout = r as? HKWorkout else {
                    return
                }
                let value = result.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0.0
                if result.startDate.isInRange(date: startDate, and: endDate ?? Date()) {
                    distance += value
                }
            }
            DispatchQueue.main.async {
                completion(distance)
            }
        }
    )

    healthStore.execute(query)
}
func getDefaultDistance(type: HKWorkoutActivityType, title: String, completion: @escaping (DistanceModel) -> Swift.Void) {
        getCustomWorkouts(
            type: type,
            ranges: [
                DateRange(startDate: Date(year: Date().year, month: 1, day: 1, hour: 0, minute: 0), endDate: Date()),
                DateRange(startDate: Date(year: Date().year, month: Date().month, day: 1, hour: 0, minute: 0), endDate: Date()),
                DateRange(startDate: Date(year: Date().year, month: Date().month, day: Date().firstDayOfWeek, hour: 0, minute: 0), endDate: Date())
            ],
            completion: { dateRanges in
                completion(DistanceModel(title: title, year: String(dateRanges[0].value), month: String(dateRanges[1].value), week: String(dateRanges[2].value)))
            }
        )
}
func getRunningDistance(completion: @escaping (DistanceModel) -> Swift.Void) {
    getDefaultDistance(type: .running, title: "Running") { (distance) in
        completion(distance)
    }
}
func getWalkingDistance(completion: @escaping (DistanceModel) -> Swift.Void) {
    getDefaultDistance(type: .walking, title: "Walking") { (distance) in
        completion(distance)
    }
}
func getCyclingDistance(completion: @escaping (DistanceModel) -> Swift.Void) {
    getDefaultDistance(type: .cycling, title: "Cycling") { (distance) in
        completion(distance)
    }
}
func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
        completion(false, HealthkitSetupError.notAvailableOnDevice)
        return
    }

    let workouts = HKSampleType.workoutType()

    let healthKitTypesToRead: Set<HKObjectType> = [workouts]
    HKHealthStore().requestAuthorization(toShare: nil,
                                         read: healthKitTypesToRead) { success, error in
        completion(success, error)
    }
}
