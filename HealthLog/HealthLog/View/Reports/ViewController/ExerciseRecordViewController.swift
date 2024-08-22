//
//  ExerciseRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class ExerciseRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let realm = RealmManager.shared.realm
    private var bodyPartSetsCount: [(key: String, value: Int)] = []
    
    
    private lazy var exerciseRecordTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor(named: "Color525252")

        
        // 테이믈 가장 맨위 여백 지우기 (insetGroup)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        
        return tableView
    }()
    
    private var expandedIndexPaths: Set<IndexPath> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        exerciseRecordTableView.dataSource = self
        exerciseRecordTableView.delegate = self
        
        exerciseRecordTableView.register(MuscleImageTableViewCell.self, forCellReuseIdentifier: "muscle")
        exerciseRecordTableView.register(TotalNumberPerBodyPartTableViewCell.self, forCellReuseIdentifier: "totalNumber")
        exerciseRecordTableView.register(SectionTitleTableViewCell.self, forCellReuseIdentifier: "sectionTitle")
        exerciseRecordTableView.register(MostPerformedTableViewCell.self, forCellReuseIdentifier: "mostPerform")
        exerciseRecordTableView.register(MostChangedTableViewCell.self, forCellReuseIdentifier: "mostChanged")
        
        self.view.addSubview(exerciseRecordTableView)
        
        exerciseRecordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseRecordTableView.layoutMargins = .zero
        exerciseRecordTableView.separatorInset = .zero
        
        // ipad와 같은 넓은 화면에서 테이블 뷰 셀이 전체 화면 너비를 사용하게 됨.
        exerciseRecordTableView.cellLayoutMarginsFollowReadableWidth = false
        
        
        NSLayoutConstraint.activate([
            exerciseRecordTableView.topAnchor.constraint(equalTo: view.topAnchor),
            exerciseRecordTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            exerciseRecordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseRecordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let AugustSchedules = fetchAugustSchedules()
        bodyPartSetsCount = calculateSetsByBodyPart(schedules: AugustSchedules)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return bodyPartSetsCount.count
        case 2:
            return 2
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "muscle", for: indexPath) as! MuscleImageTableViewCell
            cell.backgroundColor = UIColor.clear
            
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalNumber", for: indexPath) as! TotalNumberPerBodyPartTableViewCell
            cell.backgroundColor = UIColor(named: "ColorSecondary")
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            let bodyPart = bodyPartSetsCount[indexPath.row].key
            let setsCount = bodyPartSetsCount[indexPath.row].value
            cell.configureCell(bodyPart: bodyPart, setsCount: setsCount)
            
            return cell
            
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! SectionTitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mostPerform", for: indexPath) as! MostPerformedTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! SectionTitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.configureCell()
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mostChanged", for: indexPath) as! MostChangedTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                return cell
            }
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalNumber", for: indexPath) as! TotalNumberPerBodyPartTableViewCell
            cell.backgroundColor = UIColor(named: "ColorSecondary")
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 372
        case 2:
            if indexPath.row == 0 {
                return 42
            } else {
                return 79
            }
        case 3:
            if indexPath.row == 0 {
                return 42
            } else {
                return 142
            }
            
        default:
            return 40
        }
    }
    
    
    // MARK: 부위별 세트수 계산 (1달간)
    
    // 8월로 되어있는 걸 달 이동 기능과 연결 해야함.
    func fetchAugustSchedules() -> [Schedule] {
        let realm = realm
//        guard let realm = realm else { return []}
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 31))!
        
        let result = Array(realm.objects(Schedule.self).filter { $0.date >= startDate && $0.date <= endDate } )
        print(" August Data fetch success")
        
        return result
    }
    
    func calculateSetsByBodyPart(schedules: [Schedule]) -> [(key: String, value: Int)] {
        var bodyPartSetsCount: [String:Int] = [:]
        
        for schedule in schedules {
            for scheduleExercise in schedule.exercises {
                guard let exercise = scheduleExercise.exercise else {continue}
                
                let completedSets = scheduleExercise.sets.filter {$0.isCompleted}
                
                for bodyPart in exercise.bodyParts {
                    let bodyPartName = bodyPart.rawValue
                    bodyPartSetsCount[bodyPartName, default: 0] += completedSets.count
                }
            }
        }
        
        let sortedCount = bodyPartSetsCount.sorted { $0.value > $1.value }
        
        return sortedCount
    }
    
}
