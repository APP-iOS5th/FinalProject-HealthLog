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
    
    @State private var weightChartSelection: Date?
    @State private var musleChartSelection: Date?
    @State private var fatChartSelection: Date?
    
    var body: some View {
        VStack{
            // MARK: 몸무게 차트
            Button("응애") {
                print(viewModel.inBodyData)
            }
            VStack(alignment: .leading) {
                Text("몸무게")
                    .font(.custom("Pretendard-Bold", size: 18))
                    .foregroundStyle(Color.white)
                    .padding(.leading, 12)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.color2F2F2F)
                        .frame(height: 270)
                    
                    if #available(iOS 17.0, *) {
                        Chart(viewModel.inBodyData) {
                            LineMark(x: .value("Day", $0.date, unit: .day) ,
                                     y: .value("Weight", $0.weight))
                            .symbol(.circle)
                            .interpolationMethod(.linear)
                            .foregroundStyle(.colorAccent)
                            
                            if let weightChartSelection {
                                RuleMark(x: .value("Day", weightChartSelection, unit: .day))
                                    .foregroundStyle(.white)
                                    .lineStyle(StrokeStyle(lineWidth: 1))
                                    .annotation(position: .top) {
                                        ZStack {
                                            VStack(spacing: 0){
                                                Text("\(viewModel.formatDate(weightChartSelection))")
//                                                Text("\(viewModel. weightChartSelection)")
                                                    .font(.custom("Pretendard-Regular", size: 12))
                                                    .foregroundStyle(Color.white)
                                                Text("\(viewModel.getWeight(for: weightChartSelection)) KG")
                                                    .font(.custom("Pretendard-Bold", size: 16))
                                                    .foregroundStyle(Color.white)
                                                
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(RoundedRectangle(cornerRadius: 4)
                                                .fill(Color("ColorAccent").opacity(0.2)))
                                        }
                                    }
                            }
                            
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                                if let date = value.as(Date.self) {
                                    AxisValueLabel {
                                        Text("\(date, format: .dateTime.day())일")
                                            .font(.custom("Pretendard-Bold", size: 12))
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
                                            .font(.custom("Pretendard-Bold", size: 12))
                                    }
                                }
                                .foregroundStyle(Color.white)
                                AxisGridLine().foregroundStyle(Color.white)
                            }
                        }
                        .background(.clear)
                        .chartXScale(domain: viewModel.xAxisDomain())
                        .chartYScale(domain: viewModel.weightYAxisDomain())
                        .frame(height: 200)
                        .padding()
                        .padding(.top, 30)
                        .chartXSelection(value: $weightChartSelection)
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
                        .chartXScale(domain: viewModel.xAxisDomain())
                        .chartYScale(domain: viewModel.weightYAxisDomain())
                        .frame(height: 200)
                        .padding()
                        .padding(.top, 30)
                    }
                }
            }
        }
        .padding(.bottom, 18)
        
        // MARK: 근골격량 차트
        VStack(alignment: .leading) {
            Text("근골격량")
                .font(.custom("Pretendard-Bold", size: 18))
                .foregroundStyle(Color.white)
                .padding(.leading, 12)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.color2F2F2F)
                    .frame(height: 270)
                
                if #available(iOS 17.0, *) {
                    Chart(viewModel.inBodyData) {
                        LineMark(x: .value("Day", $0.date, unit: .day) ,
                                 y: .value("Muscle", $0.muscleMass))
                        .symbol(.circle)
                        .interpolationMethod(.linear)
                        .foregroundStyle(.colorAccent)
                        
                        if let musleChartSelection {
                            RuleMark(x: .value("Day", musleChartSelection, unit: .day))
                                .foregroundStyle(.white)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                                .annotation(position: .top) {
                                    ZStack {
                                        VStack(spacing: 0){
                                            Text("\(viewModel.formatDate(musleChartSelection))")
                                                .font(.custom("Pretendard-Regular", size: 12))
                                                .foregroundStyle(Color.white)
                                            Text("\(String(format: "%.1f", viewModel.getMuscleMass(for: musleChartSelection))) KG")
                                                .font(.custom("Pretendard-Bold", size: 16))
                                                .foregroundStyle(Color.white)
                                            
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(RoundedRectangle(cornerRadius: 4)
                                            .fill(Color("ColorAccent").opacity(0.2)))
                                    }
                                }
                        }
                        
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 5)) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text("\(date, format: .dateTime.day())일")
                                        .font(.custom("Pretendard-Bold", size: 12))
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
                                        .font(.custom("Pretendard-Bold", size: 12))
                                }
                            }
                            .foregroundStyle(Color.white)
                            AxisGridLine().foregroundStyle(Color.white)
                        }
                    }
                    .background(.clear)
                    .chartXScale(domain: viewModel.xAxisDomain())
                    .chartYScale(domain: viewModel.muscleYAxisDomain())
                    .frame(height: 200)
                    .padding()
                    .padding(.top, 30)
                    .chartXSelection(value: $musleChartSelection)
                } else {
                    // MARK: iOS 17이하 (chartSelection 없음)
                    Chart(viewModel.inBodyData) {
                        LineMark(x: .value("Day", $0.date, unit: .day) ,
                                 y: .value("Muscle", $0.muscleMass))
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
                    .chartXScale(domain: viewModel.xAxisDomain())
                    .chartYScale(domain: viewModel.muscleYAxisDomain())
                    .frame(height: 200)
                    .padding()
                    .padding(.top, 30)
                }
            }
        }
        .padding(.bottom, 18)
        
        // MARK: 체지방률 차트
        VStack(alignment: .leading) {
            Text("체지방률")
                .font(.custom("Pretendard-Bold", size: 18))
                .foregroundStyle(Color.white)
                .padding(.leading, 12)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.color2F2F2F)
                    .frame(height: 270)
                
                if #available(iOS 17.0, *) {
                    Chart(viewModel.inBodyData) {
                        LineMark(x: .value("Day", $0.date, unit: .day) ,
                                 y: .value("BodyFat", $0.bodyFat))
                        .symbol(.circle)
                        .interpolationMethod(.linear)
                        .foregroundStyle(.colorAccent)
                        
                        if let fatChartSelection {
                            RuleMark(x: .value("Day", fatChartSelection, unit: .day))
                                .foregroundStyle(.white)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                                .annotation(position: .top) {
                                    ZStack {
                                        VStack(spacing: 0){
                                            Text("\(viewModel.formatDate(fatChartSelection))")
                                                .font(.custom("Pretendard-Regular", size: 12))
                                                .foregroundStyle(Color.white)
                                            Text("\(String(format: "%.1f", viewModel.getBodyFat(for: fatChartSelection))) %")
                                                .font(.custom("Pretendard-Bold", size: 16))
                                                .foregroundStyle(Color.white)
                                            
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(RoundedRectangle(cornerRadius: 4)
                                            .fill(Color("ColorAccent").opacity(0.2)))
                                    }
                                }
                        }
                        
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 5)) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text("\(date, format: .dateTime.day())일")
                                        .font(.custom("Pretendard-Bold", size: 12))
                                }
                                .foregroundStyle(Color.white)
                            }
                            
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: .stride(by: 5)) { value in
                            AxisValueLabel {
                                if let double = value.as(Double.self) {
                                    Text("\(Int(double))%")
                                        .font(.custom("Pretendard-Bold", size: 12))
                                }
                            }
                            .foregroundStyle(Color.white)
                            AxisGridLine().foregroundStyle(Color.white)
                        }
                    }
                    .background(.clear)
                    .chartXScale(domain: viewModel.xAxisDomain())
                    .chartYScale(domain: viewModel.fatYAxisDomain())
                    .frame(height: 200)
                    .padding()
                    .padding(.top, 30)
                    .chartXSelection(value: $fatChartSelection)
                } else {
                    // MARK: iOS 17이하 (chartSelection 없음)
                    Chart(viewModel.inBodyData) {
                        LineMark(x: .value("Day", $0.date, unit: .day) ,
                                 y: .value("Muscle", $0.bodyFat))
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
                        AxisMarks(values: .stride(by: 5)) { value in
                            AxisValueLabel {
                                if let double = value.as(Double.self) {
                                    Text("\(Int(double))%")
                                }
                            }
                            .foregroundStyle(Color.white)
                            AxisGridLine().foregroundStyle(Color.white)
                        }
                    }
                    .background(.clear)
                    .chartXScale(domain: viewModel.xAxisDomain())
                    .chartYScale(domain: viewModel.fatYAxisDomain())
                    .frame(height: 200)
                    .padding()
                    .padding(.top, 30)
                }
            }
        }
        .padding(.bottom, 18)
    }
}

