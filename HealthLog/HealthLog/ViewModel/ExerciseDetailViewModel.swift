//
//  ExerciseDetailViewModel.swift
//  HealthLog
//
//  Created by user on 8/22/24.
//

import Foundation
import RealmSwift
import Combine
import UIKit

class ExerciseDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var exerciseNotificationToken: NotificationToken?
    private let realm = RealmManager.shared.realm
    private var cancellables = Set<AnyCancellable>()
    var viewModel: ExerciseViewModel
    
    @Published var exercise: Exercise
    @Published var currentImageIndex: Int = 0
    
    var timer: Timer?
    
    // MARK: - Init
    
    init(exercise: Exercise, viewModel: ExerciseViewModel) {
        self.exercise = exercise
        self.viewModel = viewModel
        
        observeRealmData(specificId: exercise.id)
    }
    
    deinit {
        print("deinit - timer?.invalidate")
        timer?.invalidate()
    }
    
    func startImageRotation() {
        guard exercise.images.count == 2,
              exercise.images[0].image?.isEmpty == false,
              exercise.images[1].image?.isEmpty == false
        else { return }
        // 타이머를 설정하여 2초마다 이미지 인덱스를 변경
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.5, repeats: true) { [weak self] _ in
                let index = (self?.currentImageIndex ?? 0) + 1
                self?.currentImageIndex = index % 2
        }
    }
    
    // MARK: 1
    // Realm 데이터 -> Combine Published 변수
    private func observeRealmData(specificId: ObjectId) {
        guard let realm = realm else {return}
        
        guard let results = realm.object(
            ofType: Exercise.self, forPrimaryKey: specificId) 
        else {
            print("realm - not found target exercise")
            return
        }
        
        exerciseNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .change(let data, _):
//                    print("exercise detail results.observe - update")
                    self?.exercise = data as! Exercise
                case .deleted:
                    print("exercise detail results.observe - deleted")
                case .error(let error):
                    print("exercise detail results.observe - error: \(error)")
            }
        }
    }
    
    
}
