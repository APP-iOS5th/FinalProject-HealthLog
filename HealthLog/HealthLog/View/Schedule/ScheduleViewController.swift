//
//  ViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import RealmSwift
import Combine

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExerciseCheckCellDelegate, EditScheduleExerciseViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - declare
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let today = Calendar.current.startOfDay(for: Date())
    private var selectedDate: Date?
    private var selectedDateExerciseVolume: Int = 0
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private var muscleImageView = MuscleImageView()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        //stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.wantsDateDecorations = true
        calendar.backgroundColor = .colorSecondary
        calendar.layer.cornerRadius = 10
        // color of arrows and background of selected date
        calendar.tintColor = .colorAccent
        calendar.delegate = self
        
        // selected date handler
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        
        return calendar
    }()
    
    lazy var addExerciseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("운동 추가하기", for: .normal)
        button.backgroundColor = .colorAccent
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addSchedule), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var exerciseVolumeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "오늘의 볼륨량: \(viewModel.selectedDateExerciseVolume) kg"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var separatorLine1: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.textColor = .white
        label.text = "오늘 할 운동"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.setTitle("루틴으로 저장", for: .normal)
        button.backgroundColor = .colorAccent
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.addTarget(self, action: #selector(didTapSaveRoutine), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 28),
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            view.heightAnchor.constraint(equalToConstant: 60),
        ])

        return view
    }()
    
    lazy var separatorLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(ExerciseCheckCell.self, forCellReuseIdentifier: ExerciseCheckCell.identifier)
        table.isScrollEnabled = false
        return table
    }()
    
    private func bindViewModel() {
        viewModel.$selectedDateSchedule
            .receive(on: DispatchQueue.main)
            .sink { [weak self] schedule in
                self?.updateTableView()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedDateExerciseVolume
            .receive(on: DispatchQueue.main)
            .sink { [weak self] volume in
                self?.exerciseVolumeLabel.text = "오늘의 볼륨량: \(volume) kg"
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        // 앱 첫 실행 시 오늘 날짜 선택된 상태
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
            
        if let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.setSelected(todayComponents, animated: false)
        }
        
        // MARK: 영우 - loadSelectedDateSchedule의 today를 한국시간으로
        viewModel.loadSelectedDateSchedule(today.toKoreanTime())
        
        highlightBodyPartsAtSelectedDate(selectedDate ?? today)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        didUpdateScheduleExercise()
    }
    
    private func setupUI() {
        navigationItem.title = "운동 일정"
        
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .small)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        button.setImage(plusImage, for: .normal)
        button.backgroundColor = .colorAccent
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(addSchedule), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
                
        navigationItem.rightBarButtonItem = barButtonItem
        
        self.navigationController?.setupBarAppearance()
        self.tabBarController?.setupBarAppearance()
        
        view.backgroundColor = .color1E1E1E
        
        muscleImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(calendarView)
        contentView.addArrangedSubview(addExerciseButton)
        contentView.addArrangedSubview(exerciseVolumeLabel)
        contentView.addArrangedSubview(separatorLine1)
        contentView.addArrangedSubview(muscleImageView)
        contentView.addArrangedSubview(labelContainer)
        contentView.addArrangedSubview(separatorLine2)
        contentView.addArrangedSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            calendarView.heightAnchor.constraint(equalToConstant: 500),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addExerciseButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            addExerciseButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            addExerciseButton.heightAnchor.constraint(equalToConstant: 44),
            
            exerciseVolumeLabel.heightAnchor.constraint(equalToConstant: 20),
            exerciseVolumeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseVolumeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            separatorLine1.heightAnchor.constraint(equalToConstant: 1),
            
            muscleImageView.heightAnchor.constraint(equalToConstant: 300),
            muscleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            muscleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            labelContainer.heightAnchor.constraint(equalToConstant: 30),
            labelContainer.widthAnchor.constraint(equalToConstant: 207),
            labelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            separatorLine2.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        tableViewHeightConstraint =
        tableView.heightAnchor.constraint(equalToConstant: 100)
        tableViewHeightConstraint?.isActive = true
        
        // check if no schedule
        updateUIBaseOnSchedule()
    }
    
    private func updateUIBaseOnSchedule() {
        if viewModel.noSchedule {
            exerciseVolumeLabel.isHidden = true
            muscleImageView.isHidden = true
            separatorLine1.isHidden = true
            labelContainer.isHidden = true
            separatorLine2.isHidden = true
            tableView.isHidden = true
            addExerciseButton.isHidden = false
        } else {
            exerciseVolumeLabel.isHidden = false
            muscleImageView.isHidden = false
            separatorLine1.isHidden = false
            labelContainer.isHidden = false
            separatorLine2.isHidden = false
            tableView.isHidden = false
            addExerciseButton.isHidden = true
        }
    }
    // MARK: - Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
            tableView.layoutIfNeeded()
            let height = self.tableView.contentSize.height
            tableViewHeightConstraint?.constant = height
            view.layoutIfNeeded()
    }
    
    @objc func addSchedule() {
        let date = selectedDate ?? today
        let addScheduleViewController = AddScheduleViewController(date)
        
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
    
    @objc func didTapSaveRoutine() {
        if viewModel.selectedDateSchedule != nil {
            let saveRoutineVC = SaveRoutineViewController(schedule: viewModel.selectedDateSchedule!)
            let navigationController = UINavigationController(rootViewController: saveRoutineVC)
            
            // transparent black background
            let partialScreenVC = UIViewController()
            partialScreenVC.modalPresentationStyle = .overFullScreen
            partialScreenVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            partialScreenVC.addChild(navigationController)
            partialScreenVC.view.addSubview(navigationController.view)
            
            navigationController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                navigationController.view.leadingAnchor.constraint(equalTo: partialScreenVC.view.leadingAnchor),
                navigationController.view.trailingAnchor.constraint(equalTo: partialScreenVC.view.trailingAnchor),
                navigationController.view.bottomAnchor.constraint(equalTo: partialScreenVC.view.bottomAnchor),
                navigationController.view.heightAnchor.constraint(equalToConstant: 200),
            ])
            
            navigationController.didMove(toParent: partialScreenVC)
            
            present(partialScreenVC, animated: true, completion: nil)
        }
    }
    
    private func updateTableView() {
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedDateSchedule?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCheckCell.identifier, for: indexPath) as! ExerciseCheckCell
        
        if let scheduleExercise = viewModel.selectedDateSchedule?.exercises[indexPath.row] {
            cell.configure(with: scheduleExercise)
            cell.delegate = self
        }
        
        cell.addSeparator()
        
        return cell
    }
    
    func didTapEditExercise(_ exercise: ScheduleExercise) {
        let editExerciseVC = EditScheduleExerciseViewController(scheduleExercise: exercise, selectedDate: selectedDate ?? today)
        editExerciseVC.delegate = self
        let navigationController = UINavigationController(rootViewController: editExerciseVC)
        
        // transparent black background
        let partialScreenVC = UIViewController()
        partialScreenVC.modalPresentationStyle = .overFullScreen
        partialScreenVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        partialScreenVC.addChild(navigationController)
        partialScreenVC.view.addSubview(navigationController.view)
        
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationController.view.leadingAnchor.constraint(equalTo: partialScreenVC.view.leadingAnchor),
            navigationController.view.trailingAnchor.constraint(equalTo: partialScreenVC.view.trailingAnchor),
            navigationController.view.bottomAnchor.constraint(equalTo: partialScreenVC.view.bottomAnchor),
            navigationController.view.heightAnchor.constraint(equalToConstant: 500),
        ])
        
        navigationController.didMove(toParent: partialScreenVC)
        
        present(partialScreenVC, animated: true, completion: nil)
    }
    
    func didToggleExerciseCompletion(_ exercise: ScheduleExercise) {
        didUpdateScheduleExercise()
        
        let bodyPartsWithCompletedSets = viewModel.getBodyPartsWithCompletedSets(for: (selectedDate ?? today).toKoreanTime())
        muscleImageView.highlightBodyParts(bodyPartsWithCompletedSets: bodyPartsWithCompletedSets)
    }
    
    func didUpdateScheduleExercise() {

        // MARK: 영우 - loadSelectedDateSchedule의 selectedDate, today를 한국시간으로
        viewModel.loadSelectedDateSchedule((selectedDate ?? today).toKoreanTime())
        let calendar = Calendar.current
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate ?? today)
        calendarView.reloadDecorations(forDateComponents: [selectedComponents], animated: true)
        
        updateTableView()
        highlightBodyPartsAtSelectedDate(selectedDate ?? today)
        updateUIBaseOnSchedule()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ScheduleViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = dateComponents.date else { return nil }
        
        // selected date color
        if let schedule = viewModel.getScheduleForDate(date), !schedule.exercises.isEmpty {
            let numberOfExercises = "\(schedule.exercises.count)"
            let bgColor: UIColor = isScheduleCompleted(schedule) ? .colorAccent : .color525252
            
            return .customView {
                let label = self.calendarDecoLabel(text: numberOfExercises, bgColor: bgColor)
                
                return label
            }
        }
        
        return nil
    }
    
    private func calendarDecoLabel(text: String, bgColor: UIColor) -> UIView {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        label.textColor = .white
        
        let size: CGFloat = 17.0
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        containerView.layer.cornerRadius = size / 2
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = bgColor
        
        containerView.addSubview(label)
        label.center = containerView.center
        
        return containerView
    }
    
    func highlightBodyPartsAtSelectedDate(_ date: Date) {
        let bodyPartsWithCompletedSets = viewModel.getBodyPartsWithCompletedSets(for: date.toKoreanTime())
        muscleImageView.highlightBodyParts(bodyPartsWithCompletedSets: bodyPartsWithCompletedSets)
    }
    
    private func isScheduleCompleted(_ schedule: Schedule) -> Bool {
        return schedule.exercises.contains { $0.isCompleted == true }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = dateComponents.date else { return }
        selectedDate = date
        viewModel.loadSelectedDateSchedule(date.toKoreanTime())
        updateTableView()
        highlightBodyPartsAtSelectedDate(date)
        updateUIBaseOnSchedule()
    }
}
