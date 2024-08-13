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
        
        view.addSubview(calendarView)
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 26),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    // MARK: - Methods
    private func loadTodaySchedule() {
        todaySchedule = realm.objects(Schedule.self).filter("date == %@", today).first
        
        if todaySchedule == nil {
            // no today schedule
        }
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCheckCell.identifier, for: indexPath) as! ExerciseCheckCell
        
        if let schedule = todaySchedule?.exercises[indexPath.row] {
            cell.configure(with: schedule)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
