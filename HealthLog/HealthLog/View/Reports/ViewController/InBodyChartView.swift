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
    
    @Environment(\.calendar) var calendar
    @State private var chartSelection: Date?
    @State private var inBodyData: [InBody] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("몸무게")
                .font(.custom("Pretendard-Bold", size: 22))
                .foregroundStyle(Color.white)
                
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.color2F2F2F)
                    .frame(height: 250)
                
                Chart(inBodyData) {
                    LineMark(x: .value("Day", $0.date, unit: .day) ,
                             y: .value("Weight", $0.weight))
                    .symbol(.circle)
                    .interpolationMethod(.linear)
                    .foregroundStyle(.colorAccent)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 5)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                Text("\(date, format: .dateTime.day())일")
                            }
                            .foregroundStyle(Color.white)
                        }
                        
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .stride(by: 10)) { value in
                        AxisValueLabel {
                            if let double = value.as(Double.self) {
                                Text("\(Int(double))KG")
                            }
                        }
                        .foregroundStyle(Color.white)
                        AxisGridLine().foregroundStyle(Color.white)
                    }
                }
                .background(.clear)
                .chartYScale(domain: yAxisDomain())
                .frame(height: 200)
                .padding()
                .onAppear {
                    loadData()
                }
            }
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
        let minDomain = minWeight - 10.0
        let maxDomain = maxWeight + 10.0
        
        // 최소 몸무게 = 0
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
}

#Preview {
    InBodyChartView()
}
