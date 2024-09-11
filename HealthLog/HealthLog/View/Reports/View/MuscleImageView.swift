//
//  MuscleImageView.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/26/24.
//

import Foundation
import UIKit

class MuscleImageView: UIView {
    private lazy var frontMuscleImage: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_layout"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleImage: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_layout"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleChest: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_chest_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleback: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_back_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleShoulders: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_shoulders_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleShoulders: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_shoulders_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleTriceps: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_triceps_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var frontMuscleBiceps: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_biceps_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleAbs: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_abs_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleQuadriceps: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_quadriceps_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleHamstrings: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_hamstrings_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleGlutes: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_glutes_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleAdductors: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_adductors_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleAdductors: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_adductors_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleAbductors: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_abductors_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var backMuscleAbductors: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_abductors_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleCalves: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_calves_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleTrap: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_trap_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backMuscleTrap: UIImageView = {
        let imageView = UIImageView()
        let imageName = "back_body_trap_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var frontMuscleForearms: UIImageView = {
        let imageView = UIImageView()
        let imageName = "front_body_forearms_01"
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        frontMuscleChest.isHidden = true
        backMuscleback.isHidden = true
        frontMuscleShoulders.isHidden = true
        backMuscleShoulders.isHidden = true
        backMuscleTriceps.isHidden = true
        frontMuscleBiceps.isHidden = true
        frontMuscleAbs.isHidden = true
        frontMuscleQuadriceps.isHidden = true
        backMuscleHamstrings.isHidden = true
        backMuscleGlutes.isHidden = true
        frontMuscleAdductors.isHidden = true
        backMuscleAdductors.isHidden = true
        frontMuscleAbductors.isHidden = true
        backMuscleAbductors.isHidden = true
        backMuscleCalves.isHidden = true
        frontMuscleTrap.isHidden = true
        backMuscleTrap.isHidden = true
        frontMuscleForearms.isHidden = true
        
        setupSubview()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        addSubview(frontMuscleChest)
        addSubview(backMuscleback)
        addSubview(frontMuscleShoulders)
        addSubview(backMuscleShoulders)
        addSubview(backMuscleTriceps)
        addSubview(frontMuscleBiceps)
        addSubview(frontMuscleAbs)
        addSubview(frontMuscleQuadriceps)
        addSubview(backMuscleHamstrings)
        addSubview(backMuscleGlutes)
        addSubview(frontMuscleAdductors)
        addSubview(backMuscleAdductors)
        addSubview(frontMuscleAbductors)
        addSubview(backMuscleAbductors)
        addSubview(backMuscleCalves)
        addSubview(frontMuscleTrap)
        addSubview(backMuscleTrap)
        addSubview(frontMuscleForearms)
        addSubview(frontMuscleImage)
        addSubview(backMuscleImage)
        
        
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            frontMuscleImage.topAnchor.constraint(equalTo: self.topAnchor),
            frontMuscleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.bounds.width * 0.1),
            frontMuscleImage.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -self.bounds.width * 0.1),
            frontMuscleImage.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleImage.topAnchor.constraint(equalTo: self.topAnchor),
            backMuscleImage.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: self.bounds.width * 0.1),
            backMuscleImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.bounds.width * 0.1),
            
            frontMuscleChest.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleChest.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleChest.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleback.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleback.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleback.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleShoulders.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleShoulders.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleShoulders.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleShoulders.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleShoulders.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleShoulders.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleTriceps.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleTriceps.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleTriceps.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleBiceps.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleBiceps.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleBiceps.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleAbs.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleAbs.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleAbs.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleQuadriceps.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleQuadriceps.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleQuadriceps.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleHamstrings.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleHamstrings.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleHamstrings.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleGlutes.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleGlutes.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleGlutes.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleAdductors.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleAdductors.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleAdductors.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleAdductors.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleAdductors.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleAdductors.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleAbductors.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleAbductors.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleAbductors.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleAbductors.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleAbductors.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleAbductors.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleCalves.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleCalves.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleCalves.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleTrap.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleTrap.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleTrap.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            backMuscleTrap.centerXAnchor.constraint(equalTo: backMuscleImage.centerXAnchor),
            backMuscleTrap.centerYAnchor.constraint(equalTo: backMuscleImage.centerYAnchor),
            backMuscleTrap.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor),
            
            frontMuscleForearms.centerXAnchor.constraint(equalTo: frontMuscleImage.centerXAnchor),
            frontMuscleForearms.centerYAnchor.constraint(equalTo: frontMuscleImage.centerYAnchor),
            frontMuscleForearms.widthAnchor.constraint(equalTo: backMuscleImage.widthAnchor), 
        ])
    }
    
    func configureMuscleCell(data: [ReportBodyPartData]) {
        // 초기화
        frontMuscleChest.isHidden = true
        backMuscleback.isHidden = true
        frontMuscleShoulders.isHidden = true
        backMuscleShoulders.isHidden = true
        backMuscleTriceps.isHidden = true
        frontMuscleBiceps.isHidden = true
        frontMuscleAbs.isHidden = true
        frontMuscleQuadriceps.isHidden = true
        backMuscleHamstrings.isHidden = true
        backMuscleGlutes.isHidden = true
        frontMuscleAdductors.isHidden = true
        backMuscleAdductors.isHidden = true
        frontMuscleAbductors.isHidden = true
        backMuscleAbductors.isHidden = true
        backMuscleCalves.isHidden = true
        frontMuscleTrap.isHidden = true
        backMuscleTrap.isHidden = true
        frontMuscleForearms.isHidden = true
        
        for bodyPartData in data {
            let bodyPart = BodyPart(rawValue: bodyPartData.bodyPart)
            
            var imageNamePrefixes: [String] = []
            var imageViews: [UIImageView] = []

            switch bodyPart {
            case .chest:
                imageViews = [frontMuscleChest]
                imageNamePrefixes = ["front_body_chest"]
            case .back:
                imageViews = [backMuscleback]
                imageNamePrefixes = ["back_body_back"]
            case .shoulders:
                imageViews = [frontMuscleShoulders, backMuscleShoulders]
                imageNamePrefixes = ["front_body_shoulders", "back_body_shoulders"]
            case .triceps:
                imageViews = [backMuscleTriceps]
                imageNamePrefixes = ["back_body_triceps"]
            case .biceps:
                imageViews = [frontMuscleBiceps]
                imageNamePrefixes = ["front_body_biceps"]
            case .abs:
                imageViews = [frontMuscleAbs]
                imageNamePrefixes = ["front_body_abs"]
            case .quadriceps:
                imageViews = [frontMuscleQuadriceps]
                imageNamePrefixes = ["front_body_quadriceps"]
            case .hamstrings:
                imageViews = [backMuscleHamstrings]
                imageNamePrefixes = ["back_body_hamstrings"]
            case .glutes:
                imageViews = [backMuscleGlutes]
                imageNamePrefixes = ["back_body_glutes"]
            case .adductors:
                imageViews = [frontMuscleAdductors, backMuscleAdductors]
                imageNamePrefixes = ["front_body_adductors", "back_body_adductors"] 
            case .abductors:
                imageViews = [frontMuscleAbductors, backMuscleAbductors]
                imageNamePrefixes = ["front_body_abductors", "back_body_abductors"]
            case .calves:
                imageViews = [backMuscleCalves]
                imageNamePrefixes = ["back_body_calves"]
            case .trap:
                imageViews = [frontMuscleTrap, backMuscleTrap]
                imageNamePrefixes = ["front_body_trap", "back_body_trap"]
            case .forearms:
                imageViews = [frontMuscleForearms]
                imageNamePrefixes = ["front_body_forearms"]
            case .other, .none:
                continue
            }

            // 색칠 단계 설정
            if bodyPartData.totalSets > 0 {
                var imageSuffix = "_01"
                
                switch bodyPartData.totalSets {
                case 1...5:
                    imageSuffix = "_01"
                case 6...15:
                    imageSuffix = "_02"
                case 16...25:
                    imageSuffix = "_03"
                case 26...35:
                    imageSuffix = "_04"
                case 36...:
                    imageSuffix = "_05"
                default:
                    break
                }
                
                for (index, imageView) in imageViews.enumerated() {
                    imageView.isHidden = false
                    imageView.image = UIImage(named: "\(imageNamePrefixes[index])\(imageSuffix)")
                }
            }
        }
    }
    
    // for scheduleView
    func highlightBodyParts(bodyPartsWithCompletedSets bodyParts: [String: Int]) {
        clearHighlights()
        
        for (bodyPartRawValue, sets) in bodyParts {
            let bodyPart = BodyPart(rawValue: bodyPartRawValue)
            
            var imageNamePrefixes: [String] = []
            var imageViews: [UIImageView] = []

            switch bodyPart {
            case .chest:
                imageViews = [frontMuscleChest]
                imageNamePrefixes = ["front_body_chest"]
            case .back:
                imageViews = [backMuscleback]
                imageNamePrefixes = ["back_body_back"]
            case .shoulders:
                imageViews = [frontMuscleShoulders, backMuscleShoulders]
                imageNamePrefixes = ["front_body_shoulders", "back_body_shoulders"]
            case .triceps:
                imageViews = [backMuscleTriceps]
                imageNamePrefixes = ["back_body_triceps"]
            case .biceps:
                imageViews = [frontMuscleBiceps]
                imageNamePrefixes = ["front_body_biceps"]
            case .abs:
                imageViews = [frontMuscleAbs]
                imageNamePrefixes = ["front_body_abs"]
            case .quadriceps:
                imageViews = [frontMuscleQuadriceps]
                imageNamePrefixes = ["front_body_quadriceps"]
            case .hamstrings:
                imageViews = [backMuscleHamstrings]
                imageNamePrefixes = ["back_body_hamstrings"]
            case .glutes:
                imageViews = [backMuscleGlutes]
                imageNamePrefixes = ["back_body_glutes"]
            case .adductors:
                imageViews = [frontMuscleAdductors, backMuscleAdductors]
                imageNamePrefixes = ["front_body_adductors", "back_body_adductors"]
            case .abductors:
                imageViews = [frontMuscleAbductors, backMuscleAbductors]
                imageNamePrefixes = ["front_body_abductors", "back_body_abductors"]
            case .calves:
                imageViews = [backMuscleCalves]
                imageNamePrefixes = ["back_body_calves"]
            case .trap:
                imageViews = [frontMuscleTrap, backMuscleTrap]
                imageNamePrefixes = ["front_body_trap", "back_body_trap"]
            case .forearms:
                imageViews = [frontMuscleForearms]
                imageNamePrefixes = ["front_body_forearms"]
            case .other, .none:
                continue
            }
            
            
            

            if sets > 0 {
                // apply number of sets to the body parts
                var imageSuffix = "_01"
                
                if sets > 0 && sets <= 3 {
                    imageSuffix = "_01"
                } else if sets > 3 && sets <= 7 {
                    imageSuffix = "_02"
                } else if sets > 7 && sets <= 12 {
                    imageSuffix = "_03"
                } else if sets > 12 && sets <= 17 {
                    imageSuffix = "_04"
                } else if sets > 17 {
                    imageSuffix = "_05"
                } else {
                    imageSuffix = "_01"
                }
                
                // highlight body parts
                for (index, imageView) in imageViews.enumerated() {
                    imageView.isHidden = false
                    imageView.image = UIImage(named: "\(imageNamePrefixes[index])\(imageSuffix)")
                }
            } else {
                // hide body parts
                for (_, imageView) in imageViews.enumerated() {
                    imageView.isHidden = true
                }
            }
        }
    }
    
    func clearHighlights() {
        frontMuscleChest.isHidden = true
        backMuscleback.isHidden = true
        frontMuscleShoulders.isHidden = true
        backMuscleShoulders.isHidden = true
        backMuscleTriceps.isHidden = true
        frontMuscleBiceps.isHidden = true
        frontMuscleAbs.isHidden = true
        frontMuscleQuadriceps.isHidden = true
        backMuscleHamstrings.isHidden = true
        backMuscleGlutes.isHidden = true
        frontMuscleAdductors.isHidden = true
        backMuscleAdductors.isHidden = true
        frontMuscleAbductors.isHidden = true
        backMuscleAbductors.isHidden = true
        backMuscleCalves.isHidden = true
        frontMuscleTrap.isHidden = true
        backMuscleTrap.isHidden = true
        frontMuscleForearms.isHidden = true
    }
}
