//
//  ViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import RealmSwift
import Combine

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - declare
    let realm = try! Realm()
    var todaySchedule: Schedule?
    
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var schedules: Results<Schedule>?
    
    private let today = Calendar.current.startOfDay(for: Date())
    private var selectedDate: Date?
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        calendar.backgroundColor = UIColor(named: "ColorSecondary")
        // color of arrows and background of selected date
        calendar.tintColor = UIColor(named: "ColorAccent")
        
        calendar.delegate = self
        
        // selected date handler
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        
        return calendar
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(ExerciseCheckCell.self, forCellReuseIdentifier: ExerciseCheckCell.identifier)
        table.backgroundColor = UIColor(named: "ColorSecondary")
        table.isScrollEnabled = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTodaySchedule()
        customizeCalendarTextColor()
    }
    
    fileprivate func setupUI() {
        let titleColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        
        navigationItem.title = "운동 일정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchedule))
        view.backgroundColor = UIColor(named: "ColorPrimary")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(calendarView)
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
            calendarView.heightAnchor.constraint(equalToConstant: 600),
            
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
    }
    
    private func updateTableViewHeight() {
            tableView.layoutIfNeeded()
            let height = self.tableView.contentSize.height
            tableViewHeightConstraint?.constant = height
            view.layoutIfNeeded()
    }
    
    private func loadTodaySchedule() {
        todaySchedule = realm.objects(Schedule.self).filter("date == %@", today).first
        
        if todaySchedule == nil {
            let exercises = realm.objects(Exercise.self)
            let scheduleExerciseSet1 = ScheduleExerciseSet(order: 1, weight: 10, reps: 10, isCompleted: true)
            let scheduleExerciseSet2 = ScheduleExerciseSet(order: 2, weight: 11, reps: 10, isCompleted: true)
            let scheduleExerciseSet3 = ScheduleExerciseSet(order: 3, weight: 12, reps: 10, isCompleted: false)
            let scheduleExerciseSet4 = ScheduleExerciseSet(order: 1, weight: 10, reps: 12, isCompleted: true)
            let scheduleExerciseSet5 = ScheduleExerciseSet(order: 2, weight: 12, reps: 12, isCompleted: false)
            let scheduleExerciseSet6 = ScheduleExerciseSet(order: 3, weight: 14, reps: 12, isCompleted: false)
            
            let scheduleExercise1 = ScheduleExercise(exercise: exercises[0], order: 1, isCompleted: false, sets: [scheduleExerciseSet1,scheduleExerciseSet2,scheduleExerciseSet3])
            let scheduleExercise2 = ScheduleExercise(exercise: exercises[2], order: 2, isCompleted: false, sets: [scheduleExerciseSet4,scheduleExerciseSet5,scheduleExerciseSet6])
            
            let highlightedBodyParts1 = HighlightedBodyPart(bodyPart: BodyPart(name: BodyPartType.chest), step: 6)
            let highlightedBodyParts2 = HighlightedBodyPart(bodyPart: BodyPart(name: BodyPartType.triceps), step: 3)
            let highlightedBodyParts3 = HighlightedBodyPart(bodyPart: BodyPart(name: BodyPartType.shoulders), step: 3)
            
            todaySchedule = Schedule(date: Date(), exercises: [scheduleExercise1,scheduleExercise2], highlightedBodyParts: [highlightedBodyParts1, highlightedBodyParts2, highlightedBodyParts3])
        }
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    @objc func addSchedule() {
        let addScheduleViewController = AddScheduleViewController()
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
    
    private func customizeCalendarTextColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.changeHeaderTextColor(self.calendarView)
            self.changeSubviewTextColor(self.calendarView, today: self.today, selectedDate: self.selectedDate)
        }
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
        for subview in view.subviews {
            if let label = subview as? UILabel,
               let labelDate = label.text.flatMap({ dateFromLabelText($0) }) {
                if Calendar.current.isDate(labelDate, inSameDayAs: today) {
                    if let selectedDate = selectedDate,
                       Calendar.current.isDate(labelDate, inSameDayAs: selectedDate) {
                        label.textColor = .white
                    } else {
                         label.textColor = UIColor(named: "ColorAccent")
                    }
                } else {
                    label.textColor = .white
                }
            } else {
                changeSubviewTextColor(subview, today: today, selectedDate: selectedDate)
            }
        }
    }
    
    // get date from text of UILabel
    private func dateFromLabelText(_ text: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        if let day = Int(text), day <= 31 {
            var components = DateComponents()
            components.year = Calendar.current.component(.year, from: Date())
            components.month = Calendar.current.component(.month, from: Date())
            components.day = day
            return Calendar.current.date(from: components)
        }
        
        return nil
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaySchedule?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCheckCell.identifier, for: indexPath) as! ExerciseCheckCell
        
        if let scheduleExercise = todaySchedule?.exercises[indexPath.row] {
            cell.configure(with: scheduleExercise)
        }
        return cell
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
    // color of decoration
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = dateComponents.date else { return nil }
        
        // today text color
        if Calendar.current.isDate(date, inSameDayAs: today) {
            return .default(color: UIColor(named: "ColorAccent"), size: .large)
        }
        
        // selecteed date color
        if let selectedDate = selectedDate, Calendar.current.isDate(date, inSameDayAs: selectedDate) {
            return .default(color: .blue, size: .large)
        }
        
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents, let date = dateComponents.date else { return }
        selectedDate = date
        todaySchedule = realm.objects(Schedule.self).filter("date == %@", date).first
        tableView.reloadData()
        customizeCalendarTextColor()
    }
    
}
