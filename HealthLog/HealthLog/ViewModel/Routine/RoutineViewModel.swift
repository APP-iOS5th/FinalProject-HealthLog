//
//  RoutineViewmodel.swift
//  HealthLog
//
//  Created by 어재선 on 8/20/24.
//

import Foundation
import Combine
import RealmSwift

class RoutineViewModel {
    
    private var realm: Realm?
    private var realmManger = RealmManager.shared
    
    
    private var routineNotificationToken: NotificationToken?
    
    // RoutineAddName
    @Published var rutineNameinput: String = ""
    @Published var rutineNameConfirmation: String = " "
    @Published var isValid: Bool = false
    @Published var isAddRoutineValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // Routine 배열
    @Published var routines: [Routine] = []
    
    @Published var routine: Routine = Routine()
    // 검색된 값 추가
    @Published var filteredRoutines: [Routine] = []
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        
        $routines.assign(to: &$filteredRoutines)
        
    }
    
    lazy var isRoutineNameLegthValidPublisher: AnyPublisher<Bool, Never> = {
        $rutineNameinput.map { $0.count >= 3 }
//            .print("Legth")
            .eraseToAnyPublisher()
    }()
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
    
    func getselectedRoutine(index: Int) -> Routine {
        return routines[index]
    }
    
    func addRoutine(routine: Routine) {
        realmManger.addRoutine(routine: routine)
    }
    
    
    func fillteRoutines(by searchText: String) {
        if searchText.isEmpty {
            filteredRoutines = routines
        } else {
            filteredRoutines = routines.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func updateExerciseSetCount(for section: Int, setCount: Int) {
        if self.routine.exercises[section].sets.count < setCount {
                self.routine.exercises[section].sets.append(RoutineExerciseSet(order: setCount, weight: 0, reps: 0))
        } else {
                self.routine.exercises[section].sets.removeLast()

        }
        validateExercise()
    }
    
    func deleteExercise(for setcion: Int) {
        self.routine.exercises.remove(at: setcion)
        validateExercise()
    }
    
    func validateExercise() {
        let isExercise = !routine.exercises.isEmpty
        let allFieldsFilled = routine.exercises.allSatisfy { exercise in
            exercise.sets.allSatisfy { set in
                set.weight > 0 && set.reps > 0
            }
        }
        
        isAddRoutineValid = isExercise && allFieldsFilled
        
    }
    
    private func observeRealmData() {
        guard let realm = realm else {return} // realm 에러처리 때문에 이부분 코드 삽입 했습니다 _허원열
        let results = realm.objects(Routine.self)
        
        routineNotificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let collection):
                print("results.observe - initial")
                self?.routines = Array(collection)
            case .update(let collection, _, _, _):
                print("results.observe - update")
                self?.routines = Array(collection)
            case .error(let error):
                print("results.observe - error: \(error)")
            }
        }
    }
}
