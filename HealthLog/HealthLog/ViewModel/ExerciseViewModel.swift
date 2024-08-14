//
//  ViewModel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Combine
import RealmSwift
import Foundation

class ExerciseViewModel: ObservableObject {
    private var realm: Realm
    private var exercisesNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published var selectedOption: BodyPartOption = .all
    
    @Published var exercises: [Exercise] = []
    @Published var filteredExercises: [Exercise] = []
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        exercisesSubject()
        searchExercisesSubject()
    }
    
    deinit {
        exercisesNotificationToken?.invalidate()
    }
    
    private func observeRealmData() {
        let results = realm.objects(Exercise.self)
        
        exercisesNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
                    print("results.observe - initial")
                    self?.exercises = Array(collection)
                case .update(let collection, _, _, _):
                    print("results.observe - update")
                    self?.exercises = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    private func exercisesSubject() {
        // realm의 observe가 exercises를 갱신시 assign
        $exercises.assign(to: &$filteredExercises)
    }
    
    private func searchExercisesSubject() {
        Publishers.CombineLatest(
            $searchText
                .throttle(for: .milliseconds(99), scheduler: RunLoop.main, latest: true),
            $selectedOption
        )
        .sink { [weak self] _ in self?.filterExercises() }
        .store(in: &cancellables)
    }
    
    func filterExercises(by searchText: String) {
        if searchText.isEmpty {
            filteredExercises = exercises
        } else {
            filteredExercises = exercises.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func filterExercises() {
        // 검색어와 부위를 기반으로 운동리스트를 필터링
        filteredExercises = exercises.filter { exercise in
            
            // 검색어
            let matchesAll = searchText.isEmpty
            let matchesSearchText  = exercise.name
                .localizedCaseInsensitiveContains(searchText)
            let isSearchText = matchesAll || matchesSearchText
            
            // 부위
            let isBodyPart: Bool
            switch selectedOption {
                case .all:
                    isBodyPart = true
                case .bodyPart(let bodyPart):
                    isBodyPart = exercise.bodyParts.contains(bodyPart)
            }
            
            // 이 운동이 검색어, 운동 부위에 해당하는가
            return isSearchText && isBodyPart
        }
        
//        print(" \(filteredExercises.map { $0.name }) / ")
    }
    
    func updateOption(to option: BodyPartOption) {
        selectedOption = option
    }
    
    func updateSearchText(to text: String) {
        searchText = text
    }
    
}
