//
//  ViewModel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Combine
import RealmSwift
import Foundation

// ViewModel 정의
class ScheduleViewModel: ObservableObject {
    private var realm: Realm
    private var scheduleNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var schedules: [Schedule] = []
    
    init() {
        realm = try! Realm()
        print("open \(realm.configuration.fileURL!)")
        initializeRealmData()
        observeRealmData()
    }
    
    deinit {
        scheduleNotificationToken?.invalidate()
    }
    
    private func observeRealmData() {
        let results = realm.objects(Schedule.self)
        
        scheduleNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
                    print("results.observe - initial")
                    self?.schedules = Array(collection)
                case .update(let collection, _, _, _):
                    print("results.observe - update")
                    self?.schedules = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    
}

extension ScheduleViewModel {
    // 데이터베이스에 기본 데이터가 있는지 확인하고 없으면 생성하는 함수
    private func initializeRealmData() {
        // 데이터베이스에 BodyPart 데이터가 있는지 확인
        let existingBodyParts = realm.objects(BodyPart.self)
        
        // 만약 BodyPart 데이터가 없다면 기본 데이터를 추가
        if existingBodyParts.isEmpty {
            try! realm.write {
                // BodyPart 데이터 추가
                let abs = BodyPart(name: .abs)
                let chest = BodyPart(name: .chest)
                realm.add(abs)
                realm.add(chest)
                
                // Exercise 데이터 추가
                let exercise1 = Exercise(
                    name: "Bicep Curl",
                    bodyParts: [abs],
                    descriptionText: "이두근을 강화하는 운동",
                    image: nil,
                    totalReps: 10,
                    recentWeight: 15,
                    maxWeight: 20,
                    isCustom: false
                )
                let exercise2 = Exercise(
                    name: "Chatting",
                    bodyParts: [chest],
                    descriptionText: "대화를 통해 사회성을 기르는 운동!",
                    image: nil,
                    totalReps: 0,
                    recentWeight: 0,
                    maxWeight: 0,
                    isCustom: true
                )
                realm.add(exercise1)
                realm.add(exercise2)
                
                // Routine 데이터 추가
                let routineExercise1 = RoutineExercise(exercise: exercise1, sets: [
                    RoutineExerciseSet(order: 1, weight: 10, reps: 8),
                    RoutineExerciseSet(order: 2, weight: 12, reps: 6)
                ])
                let routine = Routine(
                    name: "Morning Routine",
                    exercises: [routineExercise1],
                    exerciseVolume: 50
                )
                realm.add(routine)
                
                // Schedule 데이터 추가
                let scheduleExercise1 = ScheduleExercise(
                    exercise: exercise1,
                    order: 1,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 10, reps: 8, isCompleted: false),
                        ScheduleExerciseSet(order: 2, weight: 12, reps: 6, isCompleted: false)
                    ]
                )
                let highlightedBodyPart1 = HighlightedBodyPart(bodyPart: chest, step: 1)
                let schedule = Schedule(
                    date: Date(),
                    exercises: [scheduleExercise1],
                    highlightedBodyParts: [highlightedBodyPart1]
                )
                realm.add(schedule)
                
                print("기본 데이터가 성공적으로 삽입되었습니다.")
            }
        } else {
            print("기본 데이터가 이미 존재합니다.")
        }
    }
    
}
