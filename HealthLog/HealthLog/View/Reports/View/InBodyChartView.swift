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
    @ObservedObject var viewModel: InBodyChartViewModel
    
    @Environment(\.calendar) var calendar
    @State private var chartSelection: Date?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("몸무게")
                .font(.custom("Pretendard-Bold", size: 22))
                .foregroundStyle(Color.white)
                
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.color2F2F2F)
                    .frame(height: 250)
                
                if #available(iOS 17.0, *) {
                    Chart(viewModel.inBodyData) {
                        LineMark(x: .value("Day", $0.date, unit: .day) ,
                                 y: .value("Weight", $0.weight))
                        .symbol(.circle)
                        .interpolationMethod(.linear)
                        .foregroundStyle(.colorAccent)
                        
                        if let chartSelection {
                            RuleMark(x: .value("Day", chartSelection, unit: .day))
                                .foregroundStyle(.gray.opacity(0.5))
                                .annotation(position: .top) {
                                    ZStack {
                                        Text("\(viewModel.getWeight(for: chartSelection)) KG")
                                            .padding(8)
                                            .background(RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.accentColor.opacity(0.2))
                                            )
                                    }
                                }
                        }
                        
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
                    .chartYScale(domain: viewModel.yAxisDomain())
                    .frame(height: 200)
                    .padding()
                    .chartXSelection(value: $chartSelection)
                } else {
                    // MARK: iOS 17이하 (chartSelection 없음)
                    Chart(viewModel.inBodyData) {
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
                    .chartYScale(domain: viewModel.yAxisDomain())
                    .frame(height: 200)
                    .padding()
                    
                }
            }
        }
    }
}

