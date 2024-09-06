//
//  ExerciseCalculateViewModel.swift
//  HealthLog
//
//  Created by user on 9/2/24.
//

import RealmSwift
import Combine
import Foundation

class ExerciseCalculateViewModel {
    
    // MARK: - Properties
    
    private var realm: Realm?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
    }
    
    deinit {
        
    }
    
    // 스케줄의 운동 데이터 변경 -> 운동 수치 계산 (총운동횟수, 최근무게, 최대무게)
    private func observeRealmData() {
        guard let realm = realm else { return }
        let resultsScheduleExercise = realm.objects(ScheduleExercise.self)
        
        resultsScheduleExercise.changesetPublisher(keyPaths: ["isCompleted"])
            .sink { changes in
                switch changes {
                    case .initial: break
                    case .update(let collection, _, _,
                                 modifications: let modifications):

                        print("업데이트 발생!")
                        
                        guard let realm = RealmManager.shared.realm
                        else { return }
                        
                        realm.writeAsync {
                            self.calculateTotalReps(
                                modifications: modifications, collection: collection)
                            self.calculateRecentWeight(
                                modifications: modifications, collection: collection)
                            self.calculateMaxWeight(
                                modifications: modifications, collection: collection)
                        }
                        
                    case .error(let error):
                        print("에러 발생: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    func calculateTotalReps(modifications: [Int], collection: Results<ScheduleExercise>) {
        for modifyIndex in modifications {
            let modifyData = collection[modifyIndex]
            
            let totalReps = collection
                .filter { $0.exercise?.name == modifyData.exercise?.name }
                .filter { $0.isCompleted }.count
            modifyData.exercise?.totalReps = totalReps
        }

    }
    
    func calculateRecentWeight(modifications: [Int], collection: Results<ScheduleExercise>) {
        for modifyIndex in modifications {
            let modifyData = collection[modifyIndex]
            
            let recentWeight = modifyData.sets
                .filter { $0.isCompleted }
                .max(by: { $0.weight < $1.weight })?.weight
            
            if let recentWeight {
                modifyData.exercise?.recentWeight = recentWeight
            }
        }
    }
    
    func calculateMaxWeight(modifications: [Int], collection: Results<ScheduleExercise>) {
        for modifyIndex in modifications {
            let modifyData = collection[modifyIndex]
            
            let maxWeight = collection
                .filter {  $0.exercise?.name == modifyData.exercise?.name }
                .flatMap { $0.sets }
                .filter { $0.isCompleted }
                .max(by: { $0.weight < $1.weight })?.weight
        
            if let maxWeight {
                modifyData.exercise?.maxWeight = maxWeight
            }
            
        }
    }
    
}
