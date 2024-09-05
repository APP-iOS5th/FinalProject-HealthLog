//
//  ReportsViewModel.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/3/24.
//

import Foundation
import RealmSwift
import Combine

class ReportsViewModel {
    private let realm = RealmManager.shared.realm
    
    @Published var bodyPartDataList: [ReportBodyPartData] = []
    @Published var top5Exercises: [ExerciseSets] = []
    @Published var top3WeightChangeExercises: [ExerciseSets] = []
    
    var currentYear: Int
    var currentMonth: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let currentDate = Date()
        let calendar = Calendar.current
        self.currentYear = calendar.component(.year, from: currentDate)
        self.currentMonth = calendar.component(.month, from: currentDate)
        
        // 초기 데이터 계산
        self.fetchAndCalculateCurrentMonthData()
        
    }
    
    // ReportsVC에서 월 변경할 때 VM의 월 값도 변경하기
    func updateYearAndMonth(year: Int, month: Int) {
        self.currentYear = year
        self.currentMonth = month
        fetchAndCalculateCurrentMonthData()
    }
    
    func fetchAndCalculateCurrentMonthData() {
        let schedules = fetchMonthSchedules(year: currentYear, month: currentMonth)
        (bodyPartDataList, top5Exercises, top3WeightChangeExercises) = calculateSetsByBodyPartAndExercise(schedules: schedules)
    }
    
    func fetchMonthSchedules(year: Int, month: Int) -> [Schedule] {
        
        guard let realm = realm else { return []}
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        let endDate = calendar.date(from: DateComponents(year: year, month: month, day: range.count))!
        
        let result = Array(realm.objects(Schedule.self).filter { $0.date >= startDate && $0.date <= endDate } )
        print("\(year)년 \(month)월 데이터 fetch 성공")
        
        (bodyPartDataList, top5Exercises, top3WeightChangeExercises) = calculateSetsByBodyPartAndExercise(schedules: result)
        
        return result
    }
    
    func calculateSetsByBodyPartAndExercise(schedules: [Schedule]) -> ([ReportBodyPartData], top5Exercises: [ExerciseSets], top3WeightChangeExercises: [ExerciseSets]) {
        var bodyPartDataList: [ReportBodyPartData] = []
        var exerciseSetsCounter: [String: ExerciseSets] = [:]
        var exerciseDaysTracker: [String: Set<Date>] = [:]
        
        for schedule in schedules {
            let date = schedule.date
            
            for scheduleExercise in schedule.exercises {
                let completedSets = scheduleExercise.sets.filter { $0.isCompleted } // 완료된 Set 만 계산
                let setsCount = completedSets.count
                guard setsCount > 0 else { continue }
                
                let minWeight = completedSets.map { $0.weight }.min() ?? 0
                let maxWeight = completedSets.map { $0.weight }.max() ?? 0
                let exerciseName = scheduleExercise.exercise!.name
                
                if exerciseDaysTracker[exerciseName] == nil {
                    exerciseDaysTracker[exerciseName] = Set<Date>()
                }
                exerciseDaysTracker[exerciseName]?.insert(date)
                
                for bodyPart in scheduleExercise.exercise!.bodyParts { // 에러처리 요망
                    let bodyPartName = bodyPart.rawValue
                    
                    if let index = bodyPartDataList.firstIndex(where: {$0.bodyPart == bodyPartName}) {
                        bodyPartDataList[index].totalSets += setsCount
                        
                        if let exerciseIndex = bodyPartDataList[index].exercises.firstIndex(where: {$0.name == exerciseName}) {
                            bodyPartDataList[index].exercises[exerciseIndex].setsCount += setsCount
                            bodyPartDataList[index].exercises[exerciseIndex].minWeight = min(bodyPartDataList[index].exercises[exerciseIndex].minWeight, minWeight)
                            bodyPartDataList[index].exercises[exerciseIndex].maxWeight = max(bodyPartDataList[index].exercises[exerciseIndex].maxWeight, maxWeight)
                            
                        } else {
                            let newExercise = ExerciseSets(name: exerciseName, setsCount: setsCount, daysCount: 1, minWeight: minWeight, maxWeight: maxWeight)
                            bodyPartDataList[index].exercises.append(newExercise)
                        }
                    } else {
                        let newData = ReportBodyPartData(bodyPart: bodyPartName,
                                                         totalSets: setsCount,
                                                         exercises: [ExerciseSets(name: exerciseName, setsCount: setsCount, daysCount: 1, minWeight: minWeight, maxWeight: maxWeight)])
                        bodyPartDataList.append(newData)
                    }
                }
                
                if exerciseSetsCounter[exerciseName] != nil {
                    exerciseSetsCounter[exerciseName]!.setsCount += setsCount
                    exerciseSetsCounter[exerciseName]!.minWeight = min(exerciseSetsCounter[exerciseName]!.minWeight, minWeight)
                    exerciseSetsCounter[exerciseName]!.maxWeight = max(exerciseSetsCounter[exerciseName]!.maxWeight, maxWeight)
                } else {
                    exerciseSetsCounter[exerciseName] = ExerciseSets(name: exerciseName, setsCount: setsCount, daysCount: 1, minWeight: minWeight, maxWeight: maxWeight)
                }
            }
        }
        
        for (exerciseName, daySet) in exerciseDaysTracker {
            if var exerciseData = exerciseSetsCounter[exerciseName] {
                exerciseData.daysCount = daySet.count
                exerciseSetsCounter[exerciseName] = exerciseData
            }
            
            for i in 0..<bodyPartDataList.count {
                if let exerciseIndex = bodyPartDataList[i].exercises.firstIndex(where: { $0.name == exerciseName}) {
                    bodyPartDataList[i].exercises[exerciseIndex].daysCount = daySet.count
                }
            }
        }
        
        
        // 데이터 정렬
        bodyPartDataList.sort { $0.totalSets > $1.totalSets}
        for i in 0..<bodyPartDataList.count {
            bodyPartDataList[i].exercises.sort { $0.setsCount > $1.setsCount}
        }
        
        let top5Exercises = exerciseSetsCounter.values.sorted { $0.setsCount > $1.setsCount}.prefix(5)
        let top3WeightChangeExercises = exerciseSetsCounter.values.sorted { ($0.maxWeight - $0.minWeight) > ($1.maxWeight - $1.minWeight) }.prefix(3)
        
        
        return (bodyPartDataList, Array(top5Exercises), Array(top3WeightChangeExercises))
    }
    
}
