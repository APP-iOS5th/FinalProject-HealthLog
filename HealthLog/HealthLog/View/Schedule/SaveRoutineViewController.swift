//
//  SaveRoutineViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/20/24.
//

import UIKit
import RealmSwift

class SaveRoutineViewController: UIViewController {
    private let schedule: Schedule
    private var existName: Bool = false
    
    let realm = RealmManager.shared.realm
    
    init(schedule: Schedule) {
        self.schedule = schedule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.text = "루틴 이름"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var routineName: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Pretendard-Regular", size: 20)
        textField.textColor = .white
        textField.backgroundColor = .colorSecondary
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    lazy var notification: UILabel = {
        let label = UILabel()
        label.text = "이미 존재하는 이름입니다."
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(schedule)
        
        // set default routine name
        let placeholderText = changeDateToString(schedule.date)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        routineName.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
                
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelSave))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveRoutine))
        
        container.addArrangedSubview(pageTitle)
        container.addArrangedSubview(routineName)
        
        view.addSubview(container)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            pageTitle.heightAnchor.constraint(equalToConstant: 20),
            
            routineName.heightAnchor.constraint(equalToConstant: 44),
            routineName.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            routineName.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            container.topAnchor.constraint(equalTo: safeArea.topAnchor),
            container.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    // MARK: - Methods
    @objc private func cancelSave() {
        dismiss(animated: true)
    }
    
    @objc private func saveRoutine() {
        let routineText = routineName.text?.isEmpty ?? true ? routineName.placeholder : routineName.text
        
        existName = checkExistRoutineName(routineText!)
        
        if existName {
            container.addArrangedSubview(notification)
            let notificationHeightConstraint =
            notification.heightAnchor.constraint(equalToConstant: 14)
            notificationHeightConstraint.isActive = true
        } else {
            saveRoutineToDatabase(routineText!)
        }
    }
    
    private func changeDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    private func checkExistRoutineName(_ name: String) -> Bool {
        let routine = realm.objects(Routine.self).filter("name == %@", name).first
        return routine != nil
    }
    
    private func saveRoutineToDatabase(_ name: String) {
        print(schedule)
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
            let routineExercise = RoutineExercise(exercise: exercises.first(where: { $0.name == scheduleExercise.exercise?.name })!, sets: routineExerciseSets)
            routineExercises.append(routineExercise)
        }
        
        let routine = Routine(name: name, exercises: routineExercises, exerciseVolume: exerciseVolume)
        
        try! realm.write {
            realm.add(routine)
        }
        
        let savedRoutine = realm.objects(Routine.self).filter("name == %@", name).first
        
        existName = false
        
        let alertController = UIAlertController(title: "루틴 저장 완료", message: "루틴 (\(name))이 성공적으로 저장되었습니다.", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true)
        }
    }
}
