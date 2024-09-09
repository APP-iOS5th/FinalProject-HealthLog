//
//  RoutineAddNameViewModel.swift
//  HealthLog
//
//  Created by 어재선 on 8/31/24.
//

import Foundation
import RealmSwift
import Combine

class RoutineAddViewModel {
    
    private var realm: Realm?
    private var realmManger = RealmManager.shared
    private var routineNotificationToken: NotificationToken?
    
    
    @Published var rutineNameinput: String = ""
    @Published var rutineNameConfirmation: String = " "
    @Published var isAddRoutineValid: Bool = false
    @Published var isValid:Bool = false
    
    @Published var routine: Routine = Routine()
    @Published var routines: [Routine] = []
    @Published var routineExecrises: [RoutineExercise] = []
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
    }
    
    lazy var isRoutineNameEmptyPulisher: AnyPublisher<Bool, Never> = {
        $rutineNameinput
            .map(\.isEmpty)
//            .print("Empty")
            .eraseToAnyPublisher()
    }()
    lazy var isRoutineNameMatchingPulisher: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest($rutineNameinput, $routines)
            .map { rutineNameinput, rutines in
                !rutines.contains { $0.name == rutineNameinput}
            }
//            .print("Matching")
            .eraseToAnyPublisher()
    }()
    
    lazy var isMatchNameInput: AnyPublisher<Bool,Never> = Publishers
        .CombineLatest($rutineNameinput, $routines)
        .map( {(rutineNameinput: String, rutines: [Routine]) in
            if rutineNameinput.isEmpty {
                return false
            }
            if (rutines.contains{ $0.name == rutineNameinput}) {
                return false
            } else {
                return true
            }
            
        })
        .print()
        .eraseToAnyPublisher()
    
    // 세트 수 업데이트
    func updateExerciseSetCount(for index: Int, setCount: Int) {
        if self.routineExecrises[index].sets.count < setCount {
                self.routineExecrises[index].sets.append(RoutineExerciseSet(order: setCount, weight: -1, reps: -1))
        } else {
                self.routineExecrises[index].sets.removeLast()

        }
        validateExercise()
    }
    
    // 운동 순서 이동
    func moveExercise(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let exercise =  routineExecrises.remove(at: sourceIndex)
        routineExecrises.insert(exercise, at: destinationIndex)
        
        for (index, exercise) in routineExecrises.enumerated() {
            exercise.order = index
        }
        validateExercise()
    }
    
    // 운동 삭제
    func deleteExercise(at index: Int) {
        guard index < routineExecrises.count else { return }
        
        self.routineExecrises.remove(at: index)
        validateExercise()
    }
    
    // 완료 버튼 유호성 확인
    func validateExercise() {
        let isExercise = !routineExecrises.isEmpty
        let allFieldsFilled = routineExecrises.allSatisfy { exercise in
            exercise.sets.allSatisfy { set in
                set.weight >= 0 && set.reps > 0
            }
        }
        
        isAddRoutineValid = isExercise && allFieldsFilled
        
    }

    // 루틴 추가
    func addRoutine(routine: Routine) {
        realmManger.addRoutine(routine: routine)
    }
    
    private func observeRealmData() {
        guard let realm = realm else {return} // realm 에러처리 때문에 이부분 코드 삽입 했습니다 _허원열
        let results = realm.objects(Routine.self)
        
        routineNotificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let collection):
//                print("results.observe - initial")
                self?.routines = Array(collection)
            case .update(let collection, _, _, _):
                // print("results.observe - update")
                self?.routines = Array(collection)
            case .error(let error):
                print("results.observe - error: \(error)")
            }
        }
    }
    
}
