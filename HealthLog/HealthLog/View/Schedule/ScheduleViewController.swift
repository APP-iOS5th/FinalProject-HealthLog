//
//  ViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 7/25/24.
//

import UIKit
import Combine

class ScheduleViewController: UIViewController {

    // MARK: - declare
    
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "운동 일정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSchedule))
        view.backgroundColor = .systemBackground
    }
    
    @objc func addSchedule() {
        let addScheduleViewController = AddScheduleViewController()
        navigationController?.pushViewController(addScheduleViewController, animated: true)
    }
}

