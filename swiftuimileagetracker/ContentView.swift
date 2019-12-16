//
//  ContentView.swift
//  swiftuimileagetracker
//
//  Created by Matt Crowder on 12/16/19.
//  Copyright © 2019 Matt Crowder. All rights reserved.
//

import SwiftUI
class DistanceModel {
    var title: String = ""
    var year: String = ""
    var month: String = ""
    var week: String = ""
    init(title: String, year: String, month: String, week: String) {
        self.title = title
        self.year = year
        self.month = month
        self.week = week
    }
}
struct Distance: View {
    private var model: DistanceModel = DistanceModel(title: "", year: "", month: "", week: "")
    
    init(_ model: DistanceModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(self.model.title) Distance").font(.headline)
            Spacer()
            HStack {
                Text("Year: \(self.model.year)").font(.subheadline)
                Text("Month: \(self.model.month)").font(.subheadline)
                Text("Week: \(self.model.week)").font(.subheadline)
            }
            
        }
        
    }
}


struct ContentView: View {
    private let distances = [
        DistanceModel(title: "Running", year: "965", month: "50", week: "5"),
        DistanceModel(title: "Walking", year: "543", month: "17", week: "3"),
        DistanceModel(title: "Cycling", year: "171", month: "0", week: "0")
    ]

    var body: some View {
        
        List(0 ..< distances.count) { index in
            Distance(self.distances[index])
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
