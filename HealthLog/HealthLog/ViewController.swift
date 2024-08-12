//
//  ViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 7/25/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    // MARK: - declare
    
    private var viewModel = ScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }
    
}

