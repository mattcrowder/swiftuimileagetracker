//
//  DistanceModel.swift
//  swiftuimileagetracker
//
//  Created by Matt Crowder on 12/16/19.
//  Copyright © 2019 Matt Crowder. All rights reserved.
//

import Foundation
class DistanceModel: ObservableObject {
    @Published var title: String = ""
    @Published var year: String = ""
    var month: String = ""
    var week: String = ""
    init(title: String, year: String, month: String, week: String) {
        self.title = title
        self.year = year
        self.month = month
        self.week = week
    }
    init(){}
}
