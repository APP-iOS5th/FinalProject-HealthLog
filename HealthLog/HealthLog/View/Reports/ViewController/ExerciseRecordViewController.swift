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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! SectionTitleTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                cell.configureTotalCell()
                return cell
            } else {
                let data = reportsVM.bodyPartDataList[indexPath.row - 1]
                let maxTotalSets = reportsVM.maxTotalSets
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalNumber", for: indexPath) as! TotalNumberPerBodyPartTableViewCell
                cell.backgroundColor = UIColor(named: "ColorSecondary")
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                
                cell.configureCell(with: data, at: indexPath, maxTotalSets: maxTotalSets)
                
                return cell
            }
            
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
                cell.configureMostChangedCell()
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
        
        if reportsVM.bodyPartDataList.isEmpty {
            return 100
        }
        
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 42
            } else {
                return 329
            }
        case 1:
            if indexPath.row == 0 {
                return 42
            } else {
                let dataIndex = indexPath.row - 1
                // 데이터가 없을 경우의 기본 높이
                guard dataIndex < reportsVM.bodyPartDataList.count else {
                    return 40
                }
                let data = reportsVM.bodyPartDataList[dataIndex]
                let defaultCellHeight: CGFloat = 40
                let exerciseViewHeight: CGFloat = 25
                
                if data.isStackViewVisible {
                    let exercisesCount = data.exercises.count
                    return defaultCellHeight + (exerciseViewHeight * CGFloat(exercisesCount))
                } else {
                    return defaultCellHeight
                }
                
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
        guard indexPath.row != 0 else {return}
        
        reportsVM.bodyPartDataList[indexPath.row - 1].isStackViewVisible.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

