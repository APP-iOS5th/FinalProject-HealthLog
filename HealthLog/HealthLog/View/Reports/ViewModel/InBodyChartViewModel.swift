//
//  InBodyChartViewModel.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/29/24.
//

import SwiftUI
import Combine

class InBodyChartViewModel: ObservableObject {
    @Published var inBodyData: [InBody] = []
    
    private var realm = RealmManager.shared
    
    func loadData(for startDate: Date, to endDate: Date) {
        
        print("---------------------------------")
        print("\(startDate) ~ \(endDate)")
        
        let data = realm.getInBodyDataForChart(from: startDate, to: endDate)
        print("Fetched data: \(data.count)") // 데이터를 확인합니다.
        
        self.inBodyData = data
        
        print("Assigned data: \(inBodyData.count)") // 할당 후 데이터를 확인합니다.
        print("-----------------------------------")
    }
    
    func getWeight(for date: Date) -> Int {
        return Int(inBodyData.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        })?.weight ?? 0)
    }
    
    func yAxisDomain() -> ClosedRange<Double> {
        let weights = inBodyData.map { Double($0.weight) }
        let minWeight = weights.min() ?? 30.0
        let maxWeight = weights.max() ?? 100.0
        
        // 위 아래 여백을 위한 조절
        let minDomain = minWeight - 10.0
        let maxDomain = maxWeight + 10.0
        
        // 최소 몸무게 = 0
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
    
}
