//
//  HealthKit.swift
//  swiftuimileagetracker
//
//  Created by Matt Crowder on 12/16/19.
//  Copyright © 2019 Matt Crowder. All rights reserved.
//

import Foundation
import HealthKit
private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
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
