//
//  ViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import RealmSwift
import Combine
import FSCalendar

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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.backgroundColor = .colorSecondary
        calendar.layer.cornerRadius = 10
        calendar.layer.masksToBounds = true
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.scope = .month
        calendar.placeholderType = .none
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerTitleAlignment = .center
        calendar.headerHeight = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.weekdayFont = UIFont.font(.pretendardRegular, ofSize: 12)
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.titleTodayColor = .colorAccent
        calendar.appearance.titleFont = UIFont.font(.pretendardRegular, ofSize: 16)
        calendar.appearance.subtitleFont = UIFont.font(.pretendardMedium, ofSize: 11)
        calendar.appearance.todaySelectionColor = .colorAccent
        calendar.appearance.todayColor = .none
        calendar.appearance.selectionColor = .colorAccent
        calendar.appearance.eventOffset = CGPoint(x: 0, y: 5)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let headerDateFormatter: DateFormatter = {
        let header = DateFormatter()
        header.dateFormat = "YYYY년 MM월"
        header.locale = Locale(identifier: "ko_kr")
        header.timeZone = TimeZone(identifier: "KST")
        return header
    }()
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .label
        headerLabel.text = self.headerDateFormatter.string(from: Date())
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeaderLabel))
        headerLabel.addGestureRecognizer(tapGesture)
        
        return headerLabel
    }()
    
    @objc private func didTapHeaderLabel() {
        let currentYear = Calendar.current.component(.year, from: selectedDate ?? Date())
        let currentMonth = Calendar.current.component(.month, from: selectedDate ?? Date())
        let yearMonthPickerVC = CalendarPickerViewController(defaultYear: currentYear, defaultMonth: currentMonth)
        
        yearMonthPickerVC.yearMonthSelectionHandler = { [weak self] year, month in
            guard let self = self else { return }
            
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            if let newDate = Calendar.current.date(from: components) {
                self.selectedDate = newDate
                self.calendarView.select(newDate)
                self.viewModel.loadSelectedDateSchedule(newDate.toKoreanTime())
                self.updateTableView()
                self.highlightBodyPartsAtSelectedDate(newDate)
                self.updateUIBaseOnSchedule()
                self.headerLabel.text = self.headerDateFormatter.string(from: newDate)
                self.calendarView.setCurrentPage(newDate, animated: true)
            }
        }
        
        yearMonthPickerVC.modalPresentationStyle = .pageSheet
        if let sheet = yearMonthPickerVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 25
        }
        self.present(yearMonthPickerVC, animated: true, completion: nil)
    }
    
    private lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .colorAccent
        leftButton.addTarget(self, action: #selector(tapBeforeMonth), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        return leftButton
    }()
    
    private lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        rightButton.tintColor = .colorAccent
        rightButton.addTarget(self, action: #selector(tapNextMonth), for: .touchUpInside)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        return rightButton
    }()
    
    @objc func tapNextMonth() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage)!
        calendarView.setCurrentPage(nextMonth, animated: true)
    }
    
    @objc func tapBeforeMonth() {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)!
        calendarView.setCurrentPage(previousMonth, animated: true)
    }
    
    private lazy var toggleButton: UIButton = {
        let toggleButton = UIButton()
        toggleButton.titleLabel?.font = .systemFont(ofSize: 16.0)
        toggleButton.setTitleColor(.label, for: .normal)
        toggleButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        toggleButton.tintColor = .colorAccent
        toggleButton.layer.cornerRadius = 4.0
        toggleButton.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        return toggleButton
    }()
    
    @objc func tapToggleButton() {
        if calendarView.isHidden {
            calendarView.isHidden = false
            rightButton.isHidden = false
            leftButton.isHidden = false
            headerDateFormatter.dateFormat = "YYYY년 MM월"
            toggleButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            headerLabel.text = headerDateFormatter.string(from: calendarView.currentPage)
        } else {
            calendarView.isHidden = true
            rightButton.isHidden = true
            leftButton.isHidden = true
            headerDateFormatter.dateFormat = "YYYY년 MM월 dd일"
            toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            headerLabel.text = headerDateFormatter.string(from: selectedDate ?? Date())
        }
        updateCalendarHeight()
    }
    
    private func updateCalendarHeight() {
        if let constraint = calendarView.constraints.first(where: { $0.firstAttribute == .height }) {
            constraint.constant = calendarView.isHidden ? 0 : 350
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
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
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.select(Date())
        headerLabel.text = headerDateFormatter.string(from: Date())
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
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(leftButton)
        scrollView.addSubview(rightButton)
        scrollView.addSubview(toggleButton)
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
            
            headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            
            toggleButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            toggleButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor, constant: -20),
            rightButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            
            leftButton.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -20),
            leftButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            
            calendarView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            calendarView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 350),
            
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
        calendarView.reloadData()
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

extension ScheduleViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if let schedule = viewModel.getScheduleForDate(date) {
            if !schedule.exercises.isEmpty {
                if isScheduleCompleted(schedule) {
                    return [.colorAccent]
                } else {
                    return [.color767676]
                }
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if let schedule = viewModel.getScheduleForDate(date) {
            if !schedule.exercises.isEmpty {
                if isScheduleCompleted(schedule) {
                    return [.colorAccent]
                } else {
                    return [.color767676]
                }
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let schedule = viewModel.getScheduleForDate(date), !schedule.exercises.isEmpty {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if let constraint = calendarView.constraints.first(where: { $0.firstAttribute == .height }) {
            constraint.constant = bounds.height
        } else {
            calendarView.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        viewModel.loadSelectedDateSchedule(date.toKoreanTime())
        updateTableView()
        highlightBodyPartsAtSelectedDate(date)
        updateUIBaseOnSchedule()
        if calendarView.isHidden {
            headerLabel.text = headerDateFormatter.string(from: date)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        let components = Calendar.current.dateComponents([.year, .month], from: currentPage)
        guard let firstDayOfMonth = Calendar.current.date(from: components) else { return }
        calendar.select(firstDayOfMonth)
        selectedDate = firstDayOfMonth
        viewModel.loadSelectedDateSchedule(firstDayOfMonth.toKoreanTime())
        updateTableView()
        highlightBodyPartsAtSelectedDate(firstDayOfMonth)
        updateUIBaseOnSchedule()
        headerLabel.text = headerDateFormatter.string(from: currentPage)
    }
    
    private func isScheduleCompleted(_ schedule: Schedule) -> Bool {
        return schedule.exercises.allSatisfy { $0.isCompleted }
    }
    
    func highlightBodyPartsAtSelectedDate(_ date: Date) {
        let bodyPartsWithCompletedSets = viewModel.getBodyPartsWithCompletedSets(for: date.toKoreanTime())
        muscleImageView.highlightBodyParts(bodyPartsWithCompletedSets: bodyPartsWithCompletedSets)
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
