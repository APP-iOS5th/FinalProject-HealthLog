//
//  ExerciseRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class ExerciseRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let realm = RealmManager.shared.realm
    
    private let reportsVM: ReportsViewModel
    
    init(reportsVM: ReportsViewModel) {
        self.reportsVM = reportsVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var exerciseRecordTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor(named: "Color525252")


        // 테이믈 가장 맨위 여백 지우기 (insetGroup)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        
        return tableView
    }()
    
   
    
    
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
        exerciseRecordTableView.register(NoDataTableViewCell.self, forCellReuseIdentifier: NoDataTableViewCell.identifier)
        
        self.view.addSubview(exerciseRecordTableView)
        
        exerciseRecordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseRecordTableView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        exerciseRecordTableView.separatorInset = .zero
        // ipad와 같은 넓은 화면에서 테이블 뷰 셀이 전체 화면 너비를 사용하게 됨.
        exerciseRecordTableView.cellLayoutMarginsFollowReadableWidth = false
        
        
        
        NSLayoutConstraint.activate([
            exerciseRecordTableView.topAnchor.constraint(equalTo: view.topAnchor),
            exerciseRecordTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            exerciseRecordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseRecordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        exerciseRecordTableView.reloadData()

    }
    
    func fetchDataAndUpdateUI() {
        exerciseRecordTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reportsVM.bodyPartDataList.isEmpty ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if reportsVM.bodyPartDataList.isEmpty {
            return 1
        }
        
        switch section {
        case 0:
            return 2
        case 1:
            return reportsVM.bodyPartDataList.count
        case 2:
            return 2
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if reportsVM.bodyPartDataList.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.identifier, for: indexPath) as! NoDataTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! SectionTitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureMuscleCell()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "muscle", for: indexPath) as! MuscleImageTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.configureCell(data: reportsVM.bodyPartDataList)
                return cell
            }
        case 1:
            let data = reportsVM.bodyPartDataList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalNumber", for: indexPath) as! TotalNumberPerBodyPartTableViewCell
            cell.backgroundColor = UIColor(named: "ColorSecondary")
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            cell.configureCell(with: data, at: indexPath)
            
            return cell
            
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! SectionTitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureMostPerformCell()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mostPerform", for: indexPath) as! MostPerformedTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureCell(with: reportsVM.top5Exercises)
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! SectionTitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.configureMonstChangedCell()
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mostChanged", for: indexPath) as! MostChangedTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureCell(with: reportsVM.top3WeightChangeExercises)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 42
            } else {
                return 329
            }
        case 1:
            let data = reportsVM.bodyPartDataList[indexPath.row]
            let defaultCellHeight: CGFloat = 40
            let exerciseViewHeight: CGFloat = 25
            
            if data.isStackViewVisible {
                let exercisesCount = data.exercises.count
                return defaultCellHeight + (exerciseViewHeight * CGFloat(exercisesCount))
            } else {
                return defaultCellHeight
            }
        case 2:
            if indexPath.row == 0 {
                return 42
            } else {
                return 150
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
        guard indexPath.section == 1 else {return}
        
        reportsVM.bodyPartDataList[indexPath.row].isStackViewVisible.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    
    // MARK: 부위별 세트수 계산 (1달간)
//    func fetchMonthSchedules(year: Int, month: Int) -> [Schedule] {
//        guard let realm = realm else { return []}
//        let calendar = Calendar.current
//        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
//        let range = calendar.range(of: .day, in: .month, for: startDate)!
//        let endDate = calendar.date(from: DateComponents(year: year, month: month, day: range.count))!
//        
//        let result = Array(realm.objects(Schedule.self).filter { $0.date >= startDate && $0.date <= endDate } )
//        print("\(year)년 \(month)월 데이터 fetch 성공")
//        
//        (bodyPartDataList, top5Exercises, top3WeightChangeExercises) = calculateSetsByBodyPartAndExercise(schedules: result)
//        
//        exerciseRecordTableView.reloadData()
//        
//        return result
//    }
    
    
    
//    func calculateSetsByBodyPartAndExercise(schedules: [Schedule]) -> ([ReportBodyPartData], top5Exercises: [ExerciseSets], top3WeightChangeExercises: [ExerciseSets]) {
//        var bodyPartDataList: [ReportBodyPartData] = []
//        var exerciseSetsCounter: [String: ExerciseSets] = [:]
//        var exerciseDaysTracker: [String: Set<Date>] = [:]
//        
//        for schedule in schedules {
//            let date = schedule.date
//            
//            for scheduleExercise in schedule.exercises {
//                let completedSets = scheduleExercise.sets.filter { $0.isCompleted } // 완료된 Set 만 계산
//                let setsCount = completedSets.count
//                let minWeight = completedSets.map { $0.weight }.min() ?? 0
//                let maxWeight = completedSets.map { $0.weight }.max() ?? 0
//                let exerciseName = scheduleExercise.exercise!.name
//                
//                if exerciseDaysTracker[exerciseName] == nil {
//                    exerciseDaysTracker[exerciseName] = Set<Date>()
//                }
//                exerciseDaysTracker[exerciseName]?.insert(date)
//                
//                for bodyPart in scheduleExercise.exercise!.bodyParts { // 에러처리 요망
//                    let bodyPartName = bodyPart.rawValue
//                    
//                    if let index = bodyPartDataList.firstIndex(where: {$0.bodyPart == bodyPartName}) {
//                        bodyPartDataList[index].totalSets += setsCount
//                        
//                        if let exerciseIndex = bodyPartDataList[index].exercises.firstIndex(where: {$0.name == exerciseName}) {
//                            bodyPartDataList[index].exercises[exerciseIndex].setsCount += setsCount
//                            bodyPartDataList[index].exercises[exerciseIndex].minWeight = min(bodyPartDataList[index].exercises[exerciseIndex].minWeight, minWeight)
//                            bodyPartDataList[index].exercises[exerciseIndex].maxWeight = max(bodyPartDataList[index].exercises[exerciseIndex].maxWeight, maxWeight)
//                            
//                        } else {
//                            let newExercise = ExerciseSets(name: exerciseName, setsCount: setsCount, daysCount: 1, minWeight: minWeight, maxWeight: maxWeight)
//                            bodyPartDataList[index].exercises.append(newExercise)
//                        }
//                    } else {
//                        let newData = ReportBodyPartData(bodyPart: bodyPartName,
//                                                         totalSets: setsCount,
//                                                         exercises: [ExerciseSets(name: exerciseName, setsCount: setsCount, daysCount: 1, minWeight: minWeight, maxWeight: maxWeight)])
//                        bodyPartDataList.append(newData)
//                    }
//                }
//                
//                if exerciseSetsCounter[exerciseName] != nil {
//                    exerciseSetsCounter[exerciseName]!.setsCount += setsCount
//                    exerciseSetsCounter[exerciseName]!.minWeight = min(exerciseSetsCounter[exerciseName]!.minWeight, minWeight)
//                    exerciseSetsCounter[exerciseName]!.maxWeight = max(exerciseSetsCounter[exerciseName]!.maxWeight, maxWeight)
//                } else {
//                    exerciseSetsCounter[exerciseName] = ExerciseSets(name: exerciseName, setsCount: setsCount, daysCount: 1, minWeight: minWeight, maxWeight: maxWeight)
//                }
//            }
//        }
//        
//        for (exerciseName, daySet) in exerciseDaysTracker {
//            if var exerciseData = exerciseSetsCounter[exerciseName] {
//                exerciseData.daysCount = daySet.count
//                exerciseSetsCounter[exerciseName] = exerciseData
//            }
//            
//            for i in 0..<bodyPartDataList.count {
//                if let exerciseIndex = bodyPartDataList[i].exercises.firstIndex(where: { $0.name == exerciseName}) {
//                    bodyPartDataList[i].exercises[exerciseIndex].daysCount = daySet.count
//                }
//            }
//        }
//        
//        
//        // 데이터 정렬
//        bodyPartDataList.sort { $0.totalSets > $1.totalSets}
//        for i in 0..<bodyPartDataList.count {
//            bodyPartDataList[i].exercises.sort { $0.setsCount > $1.setsCount}
//        }
//        
//        let top5Exercises = exerciseSetsCounter.values.sorted { $0.setsCount > $1.setsCount}.prefix(5)
//        let top3WeightChangeExercises = exerciseSetsCounter.values.sorted { ($0.maxWeight - $0.minWeight) > ($1.maxWeight - $1.minWeight) }.prefix(3)
//        
//        
//        return (bodyPartDataList, Array(top5Exercises), Array(top3WeightChangeExercises))
//    }
    
}

