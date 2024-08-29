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
//    let realm = try! Realm()
    let realm = RealmManager.shared.realm
    
    private var muscleImageView = MuscleImageView()
    
    private var selectedDateSchedule: Schedule?
    
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let today = Calendar.current.startOfDay(for: Date())
    private var selectedDate: Date?
    private var selectedDateExerciseVolume: Int = 0
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    // to execute customizeCalendarTextColor one time from decorationFor
    private var isTextColorCustimzed = false
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 26
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.wantsDateDecorations = true
        calendar.backgroundColor = .colorSecondary
        // color of arrows and background of selected date
        calendar.tintColor = .colorAccent
        
        calendar.delegate = self
        
        // selected date handler
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        
        return calendar
    }()
    
    lazy var exerciseVolumeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "오늘의 볼륨량: 0"
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
        
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "루틴으로 저장"
        configuration.baseBackgroundColor = .colorAccent
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        button.configuration = configuration
        button.addTarget(self, action: #selector(didTapSaveRoutine), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadSelectedDateSchedule(today)
        customizeCalendarTextColor()
    }
    
    private func setupUI() {
        navigationItem.title = "운동 일정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchedule))
        
        self.navigationController?.setupBarAppearance()
        self.tabBarController?.setupBarAppearance()
        
        view.backgroundColor = .colorPrimary
        
        muscleImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(calendarView)
        contentView.addArrangedSubview(exerciseVolumeLabel)
        contentView.addArrangedSubview(muscleImageView)
        contentView.addArrangedSubview(separatorLine1)
        contentView.addArrangedSubview(labelContainer)
        contentView.addArrangedSubview(separatorLine2)
        contentView.addArrangedSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            calendarView.heightAnchor.constraint(equalToConstant: 500),
            
            exerciseVolumeLabel.heightAnchor.constraint(equalToConstant:20),
            exerciseVolumeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseVolumeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            separatorLine1.heightAnchor.constraint(equalToConstant: 2),
            
            muscleImageView.heightAnchor.constraint(equalToConstant: 300),
            muscleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            muscleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            labelContainer.heightAnchor.constraint(equalToConstant: 50),
            
            separatorLine2.heightAnchor.constraint(equalToConstant: 2),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        tableViewHeightConstraint =
        tableView.heightAnchor.constraint(equalToConstant: 100)
        tableViewHeightConstraint?.isActive = true
    }
    // MARK: - Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
        customizeCalendarTextColor()
    }
    
    private func updateTableViewHeight() {
            tableView.layoutIfNeeded()
            let height = self.tableView.contentSize.height
            tableViewHeightConstraint?.constant = height
            view.layoutIfNeeded()
    }
    
    fileprivate func createTodaysDummySchedule() -> Schedule? {
        guard let realm = realm else { return nil }

        let exercises = realm.objects(Exercise.self)
        let scheduleExerciseSet1 = ScheduleExerciseSet(order: 1, weight: 10, reps: 10, isCompleted: true)
        let scheduleExerciseSet2 = ScheduleExerciseSet(order: 2, weight: 11, reps: 10, isCompleted: true)
        let scheduleExerciseSet3 = ScheduleExerciseSet(order: 3, weight: 12, reps: 10, isCompleted: false)
        let scheduleExerciseSet4 = ScheduleExerciseSet(order: 1, weight: 10, reps: 12, isCompleted: true)
        let scheduleExerciseSet5 = ScheduleExerciseSet(order: 2, weight: 12, reps: 12, isCompleted: false)
        let scheduleExerciseSet6 = ScheduleExerciseSet(order: 3, weight: 14, reps: 12, isCompleted: false)
        
        let scheduleExercise1 = ScheduleExercise(exercise: exercises[0], order: 1, isCompleted: false, sets: [scheduleExerciseSet1,scheduleExerciseSet2,scheduleExerciseSet3])
        let scheduleExercise2 = ScheduleExercise(exercise: exercises[2], order: 2, isCompleted: false, sets: [scheduleExerciseSet4,scheduleExerciseSet5,scheduleExerciseSet6])
        
        let newSchedule = Schedule(date: today, exercises: [scheduleExercise1,scheduleExercise2])
        
        // add today schedule to realm
        try! realm.write {
            realm.add(newSchedule)
        }
        
        return realm.objects(Schedule.self).filter("date == %@", today).first
    }
    
    func loadSelectedDateSchedule(_ date: Date) {
        guard let realm = realm else { return }
        
        selectedDateSchedule = realm.objects(Schedule.self).filter("date == %@", date).first
        
        if date == today && selectedDateSchedule == nil {
            selectedDateSchedule = createTodaysDummySchedule()
        }

        selectedDateExerciseVolume = 0
        if let selectedSchedule = selectedDateSchedule {
            // calculate exercise volume
            for scheduleExercise in selectedSchedule.exercises {
                for set in scheduleExercise.sets {
                    selectedDateExerciseVolume += set.weight * set.reps
                }
            }
            exerciseVolumeLabel.text = "오늘의 볼륨량: \(selectedDateExerciseVolume)"
            updateTableView()
        }
        
        highlightBodyPartsAtSelectedDate(date)
    }
    
    @objc func addSchedule() {
        let addScheduleViewController = AddScheduleViewController()
        
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
    
    @objc func didTapSaveRoutine() {
        if selectedDateSchedule != nil {
            let saveRoutineVC = SaveRoutineViewController(schedule: selectedDateSchedule!)
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
        return selectedDateSchedule?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCheckCell.identifier, for: indexPath) as! ExerciseCheckCell
        
        if let scheduleExercise = selectedDateSchedule?.exercises[indexPath.row] {
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
    }
    
    func didUpdateScheduleExercise() {
        loadSelectedDateSchedule(selectedDate ?? today)
        let calendar = Calendar.current
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate ?? today)
        calendarView.reloadDecorations(forDateComponents: [selectedComponents], animated: true)
        
        updateTableView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - UITableViewDelegate
    
}

extension ScheduleViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // check if it's last day
        if let date = dateComponents.date, isLastDayOfMonth(date: date) {
            customizeCalendarTextColor()
        }
        
        guard let date = dateComponents.date else { return nil }
        
        // selected date color
        if let schedule = getScheduleForDate(date), !schedule.exercises.isEmpty {
            let numberOfExercises = "\(schedule.exercises.count)"
            let bgColor: UIColor = isScheduleCompleted(schedule) ? .colorAccent : .color525252
            
            return .customView {
                let label = self.calendarDecoLabel(text: numberOfExercises, bgColor: bgColor)
                
                return label
            }
        }
        
        return nil
    }
    
    private func isLastDayOfMonth(date: Date) -> Bool {
        // Set Korean timezone
        var koreanCalendar = Calendar(identifier: .gregorian)
        koreanCalendar.locale = Locale(identifier: "ko_KR")
        koreanCalendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        // Convert date to Korean timezone
        let koreanDate = convertToKoreanTimeZone(date: date, calendar: koreanCalendar)
        
        // Get the next day
        let calendar = calendarView.calendar
        let nextDay = koreanCalendar.date(byAdding: .day, value: 1, to: koreanDate)!
        
        let currentMonth = koreanCalendar.component(.month, from: koreanDate)
        let nextDayMonth = koreanCalendar.component(.month, from: nextDay)
        // Check if the current day is the last day of the month
        let isLastDay = (currentMonth != nextDayMonth)
        
//        print("Date: \(koreanDate), Next Day: \(nextDay), Current Month: \(currentMonth), Next day Month: \(nextDayMonth), Is last day: \(isLastDay)")
        return isLastDay
    }

    private func convertToKoreanTimeZone(date: Date, calendar: Calendar) -> Date {
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let seconds = timeZone.secondsFromGMT(for: date)
        return Date(timeInterval: TimeInterval(seconds), since: date)
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
    
    private func getScheduleForDate(_ date: Date) -> Schedule? {
        guard let realm = realm else { return nil }
        return realm.objects(Schedule.self).filter("date == %@", date).first
    }
    
    private func isScheduleCompleted(_ schedule: Schedule) -> Bool {
        return schedule.exercises.contains { $0.isCompleted == true }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents, 
              let date = dateComponents.date else { return }
        selectedDate = date
        loadSelectedDateSchedule(date)
        updateTableView()
        customizeCalendarTextColor()
    }
    
    // MARK: - Customize Calendar Text Color
    private func customizeCalendarTextColor() {
        self.changeHeaderTextColor(self.calendarView)
        self.changeSubviewTextColor(self.calendarView, today: self.today, selectedDate: self.selectedDate)
    }
    
    private func changeHeaderTextColor(_ view: UIView) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = .white
            } else {
                changeHeaderTextColor(subview)
            }
        }
    }
    
    private func changeSubviewTextColor(_ view: UIView, today: Date, selectedDate: Date?) {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: today)

        for subview in view.subviews {
            if let label = subview as? UILabel,
               let labelDate = dateFromLabelText(label.text, calendar: calendar),
               let labelDateActual = calendar.date(from: labelDate) {
                
                // set base color
                label.textColor = .white
                label.highlightedTextColor = .white
                
                // today
                if calendar.isDateInToday(labelDateActual) {
                    if today == selectedDate {
                        label.textColor = .white
                    } else {
                        label.textColor = .colorAccent
                    }
                }
                // selected date
                else if let selectedDate = selectedDate,
                        calendar.isDate(labelDateActual, inSameDayAs: selectedDate) {
                    label.textColor = .white
                }
                // this month
                else if labelDate.month == currentDateComponents.month && labelDate.year == currentDateComponents.year {
                    label.textColor = .white
                }
                // different month
                else {
                    label.textColor = .color767676
                }
            } else {
                changeSubviewTextColor(subview, today: today, selectedDate: selectedDate)
            }
        }
    }

    // get date from text of UILabel
    private func dateFromLabelText(_ text: String?, calendar: Calendar) -> DateComponents? {
        guard let text = text,
              let day = Int(text) else { return nil }
        
        // get current month and year from calendar
        let displayedMonthDate = calendarView.visibleDateComponents
        guard let month = displayedMonthDate.month,
              let year = displayedMonthDate.year else { return nil }
        
        return DateComponents(year: year, month: month, day: day)
    }
}


extension ScheduleViewController {
    private func highlightBodyPartsAtSelectedDate(_ date: Date) {
        guard let realm = realm else {return}
        
        guard let selectedDateSchedule = realm.objects(Schedule.self).filter("date == %@", date).first else { return }
        
        var completedSetsCount = 0
        var bodyPartsWithCompletedSets: [String: Int] = [:]
        
        for scheduleExercise in selectedDateSchedule.exercises {
            var completedSetsForExercise = 0
            
            for set in scheduleExercise.sets {
                if set.isCompleted {
                    completedSetsCount += 1
                    completedSetsForExercise += 1
                }
            }
            
            if completedSetsForExercise > 0 {
                // apply highlight saturation to body parts according to the number of sets
                if let bodyParts = scheduleExercise.exercise?.bodyParts {
                    for bodyPart in bodyParts {
                        if let currentCount = bodyPartsWithCompletedSets[bodyPart.rawValue] {
                            bodyPartsWithCompletedSets[bodyPart.rawValue] = currentCount + completedSetsForExercise
                        } else {
                            bodyPartsWithCompletedSets[bodyPart.rawValue] = completedSetsForExercise
                        }
                    }
                }
            } else {
                // reset body part highlights
                if let bodyParts = scheduleExercise.exercise?.bodyParts {
                    for bodyPart in bodyParts {
                        bodyPartsWithCompletedSets[bodyPart.rawValue] = 0
                    }
                }
            }
        }
        
        muscleImageView.highlightBodyParts(bodyPartsWithCompletedSets: bodyPartsWithCompletedSets)
    }
}
