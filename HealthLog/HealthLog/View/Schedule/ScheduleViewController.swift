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
        //stackView.spacing = 20
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
        calendar.locale = Locale(identifier: "ko_KR")
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
        label.text = "오늘의 볼륨량"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    lazy var volumeLabel: UILabel = {
    //        let label = UILabel()
    //        label.textColor = .white
    //        label.text = "\(viewModel.selectedDateExerciseVolume) kg"
    //        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.setTitle("루틴으로 저장", for: .normal)
        button.backgroundColor = .colorAccent
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.addTarget(self, action: #selector(didTapSaveRoutine), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1),
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
        table.backgroundColor = .color1E1E1E
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
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
            .sink { [weak self] _ in
                self?.exerciseVolumeLabel.text = "오늘의 볼륨량"
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupDragAndDrop()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
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
        didUpdateScheduleExercise()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableView()
    }
    
    private func setupDragAndDrop() {
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
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
        scrollView.addSubview(calendarView)
        scrollView.addSubview(addExerciseButton)
        scrollView.addSubview(labelContainer)
        scrollView.addSubview(separatorLine2)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(tableView)
        scrollView.addSubview(exerciseVolumeLabel)
        scrollView.addSubview(separatorLine1)
        scrollView.addSubview(muscleImageView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            calendarView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            calendarView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 500),
            
            addExerciseButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            addExerciseButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            addExerciseButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            addExerciseButton.heightAnchor.constraint(equalToConstant: 44),
            
            labelContainer.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            labelContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            labelContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            labelContainer.heightAnchor.constraint(equalToConstant: 30),
            
            separatorLine2.topAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: 15),
            separatorLine2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            separatorLine2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            separatorLine2.heightAnchor.constraint(equalToConstant: 1),
            
            contentView.topAnchor.constraint(equalTo: separatorLine2.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: exerciseVolumeLabel.topAnchor, constant: -30),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            exerciseVolumeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            exerciseVolumeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            exerciseVolumeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            separatorLine1.topAnchor.constraint(equalTo: exerciseVolumeLabel.bottomAnchor, constant: 15),
            separatorLine1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            separatorLine1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            separatorLine1.heightAnchor.constraint(equalToConstant: 1),
            
            muscleImageView.topAnchor.constraint(equalTo: separatorLine1.bottomAnchor, constant: 20),
            muscleImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            muscleImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            muscleImageView.heightAnchor.constraint(equalToConstant: 300),
            muscleImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40)
        ])
        
        tableViewHeightConstraint =
        tableView.heightAnchor.constraint(equalToConstant: 200)
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
    private func updateTableViewHeight() {
        let height = self.tableView.contentSize.height
        tableViewHeightConstraint?.constant = height
    }
    
    @objc func addSchedule() {
        let date = selectedDate ?? today
        let addScheduleViewController = AddScheduleViewController(date)
        
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
    
    @objc func didTapSaveRoutine() {
        guard let schedule = viewModel.selectedDateSchedule else { return }
        let saveRoutineVC = SaveRoutineViewController(schedule: schedule)
        saveRoutineVC.modalPresentationStyle = .pageSheet
        
        if let sheet = saveRoutineVC.sheetPresentationController {
            let smallDetent = UISheetPresentationController.Detent.custom { context in
                return 200
            }
            sheet.detents = [smallDetent]
            sheet.preferredCornerRadius = 32
        }
        
        present(saveRoutineVC, animated: true, completion: nil)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.view.layoutIfNeeded()
            self?.updateTableViewHeight()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedDateSchedule?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCheckCell.identifier, for: indexPath) as! ExerciseCheckCell
        cell.selectionStyle = .none
        if let scheduleExercise = viewModel.selectedDateSchedule?.exercises[indexPath.row] {
            cell.configure(with: scheduleExercise)
            cell.delegate = self
        }
        return cell
    }
    
    func didTapEditExercise(_ exercise: ScheduleExercise) {
        let editExerciseVC = EditScheduleExerciseViewController(scheduleExercise: exercise, selectedDate: selectedDate ?? today)
        editExerciseVC.delegate = self
        editExerciseVC.modalPresentationStyle = .formSheet
        editExerciseVC.isModalInPresentation = true
        
        if let sheet = editExerciseVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 32
        }
        
        present(editExerciseVC, animated: true, completion: nil)
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
        return 1000
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

extension ScheduleViewController: UITableViewDropDelegate, UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = viewModel.selectedDateSchedule?.exercises[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath,
           let _ = item.dragItem.localObject as? ScheduleExercise {
            
            viewModel.moveExercise(from: sourceIndexPath.row, to: destinationIndexPath.row)
            
            tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}
