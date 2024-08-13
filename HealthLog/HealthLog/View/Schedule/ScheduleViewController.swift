//
//  ViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import Combine

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - declare
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.wantsDateDecorations = true
        calendar.backgroundColor = UIColor(named: "ColorSecondary")
        calendar.tintColor = UIColor(named: "ColorAccent")
        
        customizeCalendarTextColor()
        
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
    @objc func addSchedule() {
        let addScheduleViewController = AddScheduleViewController()
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
    
    private func customizeCalendarTextColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.changeSubviewTextColor(self.calendarView, color: .white)
        }
    }
    
    private func changeSubviewTextColor(_ view: UIView, color: UIColor) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = color
            } else {
                changeSubviewTextColor(subview, color: color)
            }
        }
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCheckCell.identifier, for: indexPath) as! ExerciseCheckCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - UITableViewDelegate
    
}
