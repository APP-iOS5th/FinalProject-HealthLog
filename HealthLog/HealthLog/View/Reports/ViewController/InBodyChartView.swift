//
//  InBodyChartView.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/28/24.
//

import Foundation
import SwiftUI
import Charts

struct InBodyChartView: View {
    private let realm = RealmManager.shared
    
    @State private var inBodyData: [InBody] = []
    
    var body: some View {
        Chart(inBodyData) {
            LineMark(x: .value("Day", $0.date, unit: .day) ,
                     y: .value("Weight", $0.weight))
            .symbol(.circle)
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.day())
            }
        }
        .chartYScale(domain: yAxisDomain())
        .frame(height: 300)
        .padding()
        .onAppear {
            loadData()
        }
        
    }
    
    private func loadData() {
        inBodyData = realm.getInBodyDataForChart()
    }
    
    private func yAxisDomain() -> ClosedRange<Double> {
        let weights = inBodyData.map { Double($0.weight) }
        let minWeight = weights.min() ?? 30.0
        let maxWeight = weights.max() ?? 100.0
        
        // 위 아래 여백을 위한 조절
        let minDomain = minWeight - 15.0
        let maxDomain = maxWeight + 15.0
        
        // 최소 몸무게 = 0
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
}

#Preview {
    InBodyChartView()
}
