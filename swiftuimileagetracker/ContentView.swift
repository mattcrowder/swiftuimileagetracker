//
//  ContentView.swift
//  swiftuimileagetracker
//
//  Created by Matt Crowder on 12/16/19.
//  Copyright © 2019 Matt Crowder. All rights reserved.
//

import SwiftUI
import SwiftDate
struct Distance: View {
    private var title: String = ""
    private var year: String = ""
    private var month: String = ""
    private var week: String = ""
    
    init(title: String, year: String, month: String, week: String) {
        self.title = title
        self.year = year
        self.month = month
        self.week = week
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(self.title) Distance").font(.headline)
            Spacer()
            HStack {
                Text("Year: \(self.year)").font(.subheadline)
                Text("Month: \(self.month)").font(.subheadline)
                Text("Week: \(self.week)").font(.subheadline)
            }
            
        }
    }
}


struct ContentView: View {
    
    @State private var running: [String: String] = ["title": "Running", "year": "965", "month": "50", "week": "5"]
    @State private var walking: [String: String] = ["title": "Walking", "year": "543", "month": "17", "week": "3"]
    @State private var cycling: [String: String] = ["title": "Cycling", "year": "171", "month": "0", "week": "0"]
   
    
    var body: some View {
        NavigationView {
            List {
                Distance(title: running["title"]!, year: running["year"]!, month: running["month"]!, week: running["week"]!)
                Distance(title: walking["title"]!, year: walking["year"]!, month: walking["month"]!, week: walking["week"]!)
                Distance(title: cycling["title"]!, year: cycling["year"]!, month: cycling["month"]!, week: cycling["week"]!)
            }.navigationBarTitle("Distance Buddy")
        }.onAppear(perform: healthkitAuthorize)
    }
    
    private func healthkitAuthorize() {
        authorizeHealthKit(completion: { (success, error) in
            if success {
                getRunningDistance(completion: { distance in
                    self.running["year"] = distance.year
                    self.running["month"] = distance.month
                    self.running["week"] = distance.week
                } )
                getWalkingDistance(completion: { distance in
                    self.walking["year"] = distance.year
                    self.walking["month"] = distance.month
                    self.walking["week"] = distance.week
                } )
                getCyclingDistance(completion: { distance in
                    self.cycling["year"] = distance.year
                    self.cycling["month"] = distance.month
                    self.cycling["week"] = distance.week
                } )
            } else if error != nil {
                
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
