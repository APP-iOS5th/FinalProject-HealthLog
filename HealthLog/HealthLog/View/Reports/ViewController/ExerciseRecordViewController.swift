//
//  ExerciseRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class ExerciseRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let realm = RealmManager.shared.realm
    
    private var bodyPartDataList: [ReportBodyPartData] = []
    
    private var exerciseRecordTableView = UITableView(frame: .zero, style: .insetGrouped)
//    private lazy var exerciseRecordTableView: UITableView(frame: .zero, style: .insetGrouped) = {
//        let tableView = UITableView(frame: .zero, style: .insetGrouped)
//        tableView.backgroundColor = .clear
//        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorColor = UIColor(named: "Color525252")
//
//        // 테이믈 가장 맨위 여백 지우기 (insetGroup)
//        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
//        
//        return tableView
//    }()
    
    func setupTableView() {
        exerciseRecordTableView.backgroundColor = .clear
        exerciseRecordTableView.showsVerticalScrollIndicator = false
        exerciseRecordTableView.separatorColor = UIColor(named: "Color525252")

        // 테이믈 가장 맨위 여백 지우기 (insetGroup)
        exerciseRecordTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupTableView()
        
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
        
        let augustSchedules = fetchAugustSchedules()
        bodyPartDataList = calculateSetsByBodyPartAndExercise(schedules: augustSchedules)
        
        print(bodyPartDataList)
        exerciseRecordTableView.reloadData()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return bodyPartDataList.count
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
            let data = bodyPartDataList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalNumber", for: indexPath) as! TotalNumberPerBodyPartTableViewCell
            cell.backgroundColor = UIColor(named: "ColorSecondary")
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            cell.configureCell(with: data, at: indexPath) { [weak self] indexPath in
                self?.toggleStackViewVisibility(for: indexPath)
            }
            
            
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
        case 1:
            return 100
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bodyPartDataList[indexPath.row].isStackViewVisible.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    // MARK: 부위별 세트수 계산 (1달간)
    
    // 8월로 되어있는 걸 달 이동 기능과 연결 해야함.
    func fetchAugustSchedules() -> [Schedule] {
        guard let realm = realm else { return []}
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 31))!
        
        let result = Array(realm.objects(Schedule.self).filter { $0.date >= startDate && $0.date <= endDate } )
        print(" August Data fetch success")
        
        return result
    }
    
    
    func calculateSetsByBodyPartAndExercise(schedules: [Schedule]) -> [ReportBodyPartData] {
        var bodyPartDataList: [ReportBodyPartData] = []
        
        for schedule in schedules {
            for scheduleExercise in schedule.exercises {
                let setsCount = scheduleExercise.sets.filter { $0.isCompleted }.count // 완료된 set 만 계산
                
                for bodyPart in scheduleExercise.exercise!.bodyParts { // 에러처리 요망
                    let bodyPartName = bodyPart.rawValue
                    
                    if let index = bodyPartDataList.firstIndex(where: {$0.bodyPart == bodyPartName}) {
                        bodyPartDataList[index].totalSets += setsCount
                        let exerciseName = scheduleExercise.exercise!.name
                        if let exerciseIndex = bodyPartDataList[index].exercises.firstIndex(where: {$0.name == exerciseName}) {
                            bodyPartDataList[index].exercises[exerciseIndex].setsCount += setsCount
                        } else {
                            bodyPartDataList[index].exercises.append(ExerciseSets(name: exerciseName, setsCount: setsCount))
                        }
                    } else {
                        let newData = ReportBodyPartData(bodyPart: bodyPartName, totalSets: setsCount, exercises: [ExerciseSets(name: scheduleExercise.exercise!.name, setsCount: setsCount)])
                        bodyPartDataList.append(newData)
                    }
                }
            }
        }
        
        bodyPartDataList.sort { $0.totalSets > $1.totalSets}
        for i in 0..<bodyPartDataList.count {
            bodyPartDataList[i].exercises.sort { $0.setsCount > $1.setsCount}
        }
        
        
        return bodyPartDataList
    }
    
    func toggleStackViewVisibility(for indexPath: IndexPath) {
        var data = bodyPartDataList[indexPath.row]
        data.isStackViewVisible.toggle()
        bodyPartDataList[indexPath.row] = data
        
        exerciseRecordTableView.beginUpdates()
        exerciseRecordTableView.reloadRows(at: [indexPath], with: .automatic)
        exerciseRecordTableView.endUpdates()
    }
    
}
