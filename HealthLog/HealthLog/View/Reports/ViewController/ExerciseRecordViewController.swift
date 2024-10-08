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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .color1E1E1E
        exerciseRecordTableView.dataSource = self
        exerciseRecordTableView.delegate = self
                
        registerTableCell()
        setupUI()
        

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
            return 1
        case 1:
            return reportsVM.bodyPartDataList.count + 1
        case 2:
            return reportsVM.top5Exercises.count + 1
        case 3:
            return reportsVM.top3WeightChangeExercises.count + 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "muscle", for: indexPath) as! MuscleImageTableViewCell
            cell.backgroundColor = UIColor(named: "ColorSecondary")
//            cell.backgroundColor = .color1E1E1E
            cell.selectionStyle = .none
            cell.configureCell(data: reportsVM.bodyPartDataList)
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "section01", for: indexPath) as! TotalNumberSectionSubtitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                return cell
                
            } else {
                
                let data = reportsVM.bodyPartDataList[indexPath.row-1]
                let maxTotalSets = reportsVM.maxTotalSets
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalNumber", for: indexPath) as! TotalNumberPerBodyPartTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
//                            cell.backgroundColor = .color1E1E1E
                cell.selectionStyle = .none
                
                
                cell.configureCell(with: data, at: indexPath, maxTotalSets: maxTotalSets, index: indexPath.row)
                
                return cell
            }
            
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "section02", for: indexPath) as! MostPerformedSectionSubtitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "mostPerform", for: indexPath) as! MostPerformedTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                
                cell.configureCell(data: reportsVM.top5Exercises[indexPath.row-1], index: indexPath.row)
                return cell
            }
            
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "section03", for: indexPath) as! MostChangedSectionSubtitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mostChanged", for: indexPath) as! MostChangedTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                
                cell.configureCell(with: reportsVM.top3WeightChangeExercises[indexPath.row-1], index: indexPath.row)
                return cell
            }
                
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if reportsVM.bodyPartDataList.isEmpty {
            return 100
        }
        
        
        switch indexPath.section {
        case 0:
            return 303
            
        case 1:
            if indexPath.row == 0 {
                return 35
            } else {
                let dataIndex = indexPath.row
                let data = reportsVM.bodyPartDataList[dataIndex-1]
                let defaultCellHeight: CGFloat = 46
                let exerciseViewHeight: CGFloat = 27
                
                if data.isStackViewVisible {
                    let exercisesCount = data.exercises.count
                    return defaultCellHeight + (exerciseViewHeight * CGFloat(exercisesCount))
                } else {
                    return defaultCellHeight
                }
            }
            
        case 2:
            if indexPath.row == 0 {
                return 35
            } else {
                return 45
            }
            
        case 3:
            if indexPath.row == 0 {
                return 35
            } else {
                return 47
            }
            
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {return}
        guard indexPath.row != 0 else {return}
        
        reportsVM.bodyPartDataList[indexPath.row-1].isStackViewVisible.toggle()
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.font(.pretendardBold, ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        switch section {
        case 0:
            if reportsVM.bodyPartDataList.isEmpty {
                label.text = ""
            } else {
                label.text = "부위별 운동 강도"
            }
        case 1:
            label.text = "부위별 운동 내역"
        case 2:
            label.text = "한 달간 가장 많이 한 운동"
        case 3:
            label.text = "무게 변화가 가장 큰 운동"
        default:
            label.text = ""
        }
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // 헤더 높이 설정
    }
    
}


extension ExerciseRecordViewController {
    
    
    func registerTableCell() {
        
        exerciseRecordTableView.register(MuscleImageTableViewCell.self, forCellReuseIdentifier: "muscle")
        exerciseRecordTableView.register(TotalNumberPerBodyPartTableViewCell.self, forCellReuseIdentifier: "totalNumber")
        exerciseRecordTableView.register(SectionTitleTableViewCell.self, forCellReuseIdentifier: "sectionTitle")
        exerciseRecordTableView.register(MostPerformedTableViewCell.self, forCellReuseIdentifier: "mostPerform")
        exerciseRecordTableView.register(MostChangedTableViewCell.self, forCellReuseIdentifier: "mostChanged")
        exerciseRecordTableView.register(NoDataTableViewCell.self, forCellReuseIdentifier: NoDataTableViewCell.identifier)
        exerciseRecordTableView.register(TotalNumberSectionSubtitleTableViewCell.self, forCellReuseIdentifier: "section01")
        exerciseRecordTableView.register(MostPerformedSectionSubtitleTableViewCell.self, forCellReuseIdentifier: "section02")
        exerciseRecordTableView.register(MostChangedSectionSubtitleTableViewCell.self, forCellReuseIdentifier: "section03")
        
    }
    
    func setupUI() {
        
        self.view.addSubview(exerciseRecordTableView)
        
        exerciseRecordTableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        exerciseRecordTableView.separatorInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        exerciseRecordTableView.cellLayoutMarginsFollowReadableWidth = false
        
        NSLayoutConstraint.activate([
            exerciseRecordTableView.topAnchor.constraint(equalTo: view.topAnchor),
            exerciseRecordTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            exerciseRecordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseRecordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        exerciseRecordTableView.reloadData()
        
    }
}
