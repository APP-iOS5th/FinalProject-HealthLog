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
    @Published var isInputValid: Bool = false
    @Published var noSchedule: Bool = false
    private var setValues: [(order: Int, weight: String, reps: String)] = []
    
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
//                print("results.observe - update")
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
                // calculate schedule exercise volume
                let completedSets = scheduleExercise.sets.filter { $0.isCompleted }
                for set in completedSets {
                    selectedDateExerciseVolume += set.weight * set.reps
                }
                
                do {
                    try realm.write {
                        // update completion of schedule exercise
                        if completedSets.count < scheduleExercise.sets.count {
                            scheduleExercise.isCompleted = false
                        } else {
                            scheduleExercise.isCompleted = true
                        }
                    }
                } catch {
                    print("Error updating completion of ScheduleExercise: \(error)")
                }
            }
            noSchedule = false
        } else {
            noSchedule = true
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
    
    func updateSetValues(_ newValues: [(order: Int, weight: String, reps: String)]) {
        setValues = newValues
        validateInput()
    }
    
    func validateInput() {
        isInputValid = setValues.allSatisfy { set in
            !set.weight.isEmpty &&
            !set.reps.isEmpty &&
            set.reps != "0" &&
            (Int(set.weight) ?? 0) >= 0 &&
            (Int(set.reps) ?? 0) > 0
        }
    }
    
    func saveEditedExercise(scheduleExercise: ScheduleExercise, setValues: [(order: Int, weight: String, reps: String)]) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                // add or edit schedule exercise sets
                for (index, setValue) in setValues.enumerated() {
                    if index < scheduleExercise.sets.count {
                        scheduleExercise.sets[index].order = setValue.order
                        scheduleExercise.sets[index].weight = Int(setValue.weight) ?? 0
                        scheduleExercise.sets[index].reps = Int(setValue.reps) ?? 0
                    } else {
                        let set = ScheduleExerciseSet(
                            order: setValue.order,
                            weight: Int(setValue.weight) ?? 0,
                            reps: Int(setValue.reps) ?? 0,
                            isCompleted: false
                        )
                        scheduleExercise.sets.append(set)
                    }
                }
                // remove schedule exercise sets
                if setValues.count < scheduleExercise.sets.count {
                    let scheduleExerciseSetsCount = scheduleExercise.sets.count
                    for j in (setValues.count..<scheduleExerciseSetsCount).reversed() {
                        realm.delete(scheduleExercise.sets[j])
                    }
                }
            }
        } catch {
            print("Error updating ScheduleExercise: \(error)")
        }
    }
    
    func deleteExercise(scheduleExercise: ScheduleExercise, selectedDate: Date) {
        guard let realm = realm else { return }
        
        do {
            let schedule = realm.objects(Schedule.self).filter("date == %@", selectedDate.toKoreanTime()).first
            
            try realm.write {
                guard let exercises = schedule?.exercises else { return }
                if exercises.count > 1 {
                    realm.delete(scheduleExercise)
                    
                    for (index, exercise) in exercises.enumerated() {
                        exercise.order = index + 1
                    }
                } else {
                    if let schedule = schedule {
                        realm.delete(schedule)
                    }
                }
            }
            
        } catch {
            print("Error deleting and reordering ScheduleExercise: \(error)")
        }
    }
    
    func checkExistRoutineName(_ name: String) -> Bool {
        guard let realm = realm else { return false }
        let routine = realm.objects(Routine.self).filter("name == %@", name).first
        return routine != nil
    }
    
    func saveRoutineToDatabase(name: String, schedule: Schedule) -> Bool {
        guard let realm = realm else { return false }
        let exercises = realm.objects(Exercise.self)
        
        var routineExercises = [RoutineExercise]()
        var exerciseVolume: Int = 0
        
        for scheduleExercise in schedule.exercises {
            var routineExerciseSets = [RoutineExerciseSet]()
            for set in scheduleExercise.sets {
                let routineExerciseSet = RoutineExerciseSet(order: set.order, weight: set.weight, reps: set.reps)
                routineExerciseSets.append(routineExerciseSet)
                exerciseVolume += set.weight * set.reps
            }
            if let exercise = exercises.first(where: { $0.name == scheduleExercise.exercise?.name }) {
                let routineExercise = RoutineExercise(exercise: exercise, order: scheduleExercise.order, sets: routineExerciseSets)
                routineExercises.append(routineExercise)
            }
        }
        
        let routine = Routine(name: name, exercises: routineExercises, exerciseVolume: exerciseVolume)
        
        do {
            try realm.write {
                realm.add(routine)
            }
            return true
        } catch {
            print("Error saving routine: \(error)")
            return false
        }
    }
}
