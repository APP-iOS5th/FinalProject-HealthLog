//
//  ViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import Combine

class ScheduleViewController: UIViewController {
    // MARK: - declare
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var calendarView: UICalendarView = {
        var calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.wantsDateDecorations = true
        calendar.backgroundColor = UIColor(named: "supportColor")
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "운동 일정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchedule))
        view.backgroundColor = .systemBackground
        
        applyConstraints()
    }
    
    fileprivate func applyConstraints() {
        view.addSubview(calendarView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let calendarViewConstraints = [
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
//            calendarView.heightAnchor.constraint(equalToConstant: 200),
        ]
        
        NSLayoutConstraint.activate(calendarViewConstraints)
    }
    // MARK: - Methods
    @objc func addSchedule() {
        let addScheduleViewController = AddScheduleViewController()
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
}

