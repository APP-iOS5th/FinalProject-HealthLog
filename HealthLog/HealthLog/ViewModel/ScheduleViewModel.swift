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
    private var realm: Realm?
    private var scheduleNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var schedules: [Schedule] = []
    @Published var selectedDateSchedule: Schedule?
    @Published var selectedDateExerciseVolume: Int = 0
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
    }
    
    deinit {
        scheduleNotificationToken?.invalidate()
    }
    
    private func observeRealmData() {
        guard let realm = realm else {return} // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
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
    
    func loadSelectedDateSchedule(_ date: Date) {
        guard let realm = realm else { return }
        
        selectedDateSchedule = realm.objects(Schedule.self).filter("date == %@", date).first
        
        selectedDateExerciseVolume = 0
        if let selectedSchedule = selectedDateSchedule {
            for scheduleExercise in selectedSchedule.exercises {
                for set in scheduleExercise.sets {
                    selectedDateExerciseVolume += set.weight * set.reps
                }
            }
        }
    }
    
    func getBodyPartsWithCompletedSets(for date: Date) -> [String: Int] {
        guard let selectedDateSchedule = realm?.objects(Schedule.self).filter("date == %@", date).first else { return [:] }
        
        var bodyPartsWithCompletedSets: [String: Int] = [:]
        
        for scheduleExercise in selectedDateSchedule.exercises {
            var completedSetsForExercise = 0
            
            for set in scheduleExercise.sets {
                if set.isCompleted {
                    completedSetsForExercise += 1
                }
            }
            
            if completedSetsForExercise > 0 {
                if let bodyParts = scheduleExercise.exercise?.bodyParts {
                    for bodyPart in bodyParts {
                        if let currentCount = bodyPartsWithCompletedSets[bodyPart.rawValue] {
                            bodyPartsWithCompletedSets[bodyPart.rawValue] = currentCount + completedSetsForExercise
                        } else {
                            bodyPartsWithCompletedSets[bodyPart.rawValue] = completedSetsForExercise
                        }
                    }
                }
            }
        }
        
        return bodyPartsWithCompletedSets
    }
    
    func getScheduleForDate(_ date: Date) -> Schedule? {
        guard let realm = realm else { return nil }
        return realm.objects(Schedule.self).filter("date == %@", date.toKoreanTime()).first
    }
    
    func toggleSetCompletion(for exercise: ScheduleExercise, setOrder: Int, isCompleted: Bool) {
        guard let realm = realm else { return }
        
        do {
            if let scheduleExercise = realm.object(ofType: ScheduleExercise.self, forPrimaryKey: exercise.id),
               let setIndex = scheduleExercise.sets.firstIndex(where: { $0.order == setOrder }) {
                try realm.write {
                    scheduleExercise.sets[setIndex].isCompleted = isCompleted
                    
                    let allSetsCompleted = scheduleExercise.sets.allSatisfy { $0.isCompleted }
                    scheduleExercise.isCompleted = allSetsCompleted
                }
                
                // Update selectedDateExerciseVolume
                updateSelectedDateExerciseVolume()
            }
        } catch {
            print("Error updating ScheduleExerciseSet: \(error)")
        }
    }
    
    func toggleExerciseCompletion(for exercise: ScheduleExercise, isCompleted: Bool) {
        guard let realm = realm else { return }
        
        do {
            if let scheduleExercise = realm.object(ofType: ScheduleExercise.self, forPrimaryKey: exercise.id) {
                try realm.write {
                    scheduleExercise.isCompleted = isCompleted
                    scheduleExercise.sets.forEach { $0.isCompleted = isCompleted }
                }
                
                // Update selectedDateExerciseVolume
                updateSelectedDateExerciseVolume()
            }
        } catch {
            print("Error updating ScheduleExercise: \(error)")
        }
    }
        
    private func updateSelectedDateExerciseVolume() {
        selectedDateExerciseVolume = 0
        if let selectedSchedule = selectedDateSchedule {
            for scheduleExercise in selectedSchedule.exercises {
                for set in scheduleExercise.sets where set.isCompleted {
                    selectedDateExerciseVolume += set.weight * set.reps
                }
            }
        }
    }
    
}
