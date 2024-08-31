//
//  InBodyChartViewModel.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/29/24.
//

import Combine
import RealmSwift
import Foundation


class InBodyChartViewModel: ObservableObject {
    
    @Published var inBodyData: [InBody] = []
    @Published var inbodyRecords: [InBody] = []
    
    private var realm: Realm?
    private var inputNotificationToken: NotificationToken?
    private var monthNotificationToken: NotificationToken?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private var currentStartDate: Date?
    private var currentEndDate: Date?
    
    init() {
        self.realm = RealmManager.shared.getRealm()
        observeInBodyDataChanges()
        observeRealmData()
    }
    
    private func observeRealmData() {
        guard let realm = realm else { return }
        
        // MARK: (youngwoo) RealmCombine 03. 데이터 불러옴
        let results = realm.objects(InBody.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        // result에 담은 Realm DB 데이터를 observe로 감시, DB 값 변경시 안에 있는 실행
        inputNotificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let collection):
                self?.inbodyRecords = Array(collection)
                
                //                    print(self?.inbodyRecords ?? [])
            case .update(let collection, _, _, _):
                self?.inbodyRecords = Array(collection)
            case .error(let error):
                print("results.observe - error: \(error)")
            }
        }
    }
    
    func loadData(for startDate: Date, to endDate: Date) {
        
        // weightRecordVC에서 view did load할 때 현재 날짜 받아서 적용됨
        self.currentStartDate = startDate
        self.currentEndDate = endDate
        
        print("---------------------------------")
        print("\(startDate) ~ \(endDate)")
        
        fetchInBodyData(from: startDate, to: endDate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { [weak self] data in
                self?.inBodyData = data
                print("Fetched data: \(data.count)") // 데이터를 확인합니다.
                print("Assigned data: \(self?.inBodyData.count ?? 0)") // 할당 후 데이터를 확인합니다.
                print("-----------------------------------")
            })
            .store(in: &cancellables)
        
    }
    
    private func fetchInBodyData(from startDate: Date, to endDate: Date) -> Future<[InBody], Error> {
        return Future { result in
            do {
                // 옵셔널 바인딩을 통해 realm이 nil이 아닌지 확인
                guard let realm = self.realm else {
                    result(.failure(realmError.realmInstanceUnavailable)) // 여기서 SomeError는 적절한 에러 타입으로 대체
                    return
                }

                let data = realm.objects(InBody.self).filter("date >= %@ AND date <= %@", startDate, endDate)
                result(.success(Array(data)))
            } catch {
                result(.failure(realmError.dataFetchFailed))
            }
        }
    }
    
    private func observeInBodyDataChanges() {
        guard let realm = realm else {
            print("Realm 인스턴스가 nil입니다.")
            return
        }
        
        
        let results = realm.objects(InBody.self)
        
        // Realm 데이터를 Combine으로 변환하여 관찰
        monthNotificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
                
            case .initial:
                break
            case .update:
                if let startDate = self.currentStartDate, let endDate = self.currentEndDate {
                    self.loadData(for: startDate, to: endDate)
                    print("값 변화됨!")
                }
            case .error(let error):
                print("Realm error: \(error)")
            }
        }
    }
    
    deinit {
        monthNotificationToken?.invalidate()
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "d일"
        return formatter.string(from: date)
    }
    
    
    
    func getWeight(for date: Date) -> Int {
        return Int(inBodyData.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        })?.weight ?? 0)
    }
    
    func getMuscleMass(for date: Date) -> Float {
        return Float(inBodyData.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        })?.muscleMass ?? 0)
    }
    
    func getBodyFat(for date: Date) -> Float {
        return Float(inBodyData.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        })?.bodyFat ?? 0)
    }
    
    
    func weightYAxisDomain() -> ClosedRange<Double> {
        let weights = inBodyData.map { Double($0.weight) }
        let minWeight = weights.min() ?? 30.0
        let maxWeight = weights.max() ?? 100.0
        
        // 위 아래 여백을 위한 조절
        let minDomain = minWeight - 10
        let maxDomain = maxWeight + 10
        
        // 최소 몸무게 = 0
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
    
    func muscleYAxisDomain() -> ClosedRange<Double> {
        let muscles = inBodyData.map { Double($0.muscleMass)}
        let minMuscle = muscles.min() ?? 10.0
        let maxMuscle = muscles.max() ?? 50
        
        let minDomain = minMuscle - 10
        let maxDomain = maxMuscle + 10
        
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
    
    func fatYAxisDomain() -> ClosedRange<Double> {
        let fats = inBodyData.map { Double($0.bodyFat)}
        let minFat = fats.min() ?? 5
        let maxFat = fats.max() ?? 40
        
        let minDomain = minFat - 5
        let maxDomain = maxFat + 5
        
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
    
    
    func xAxisDomain() -> ClosedRange<Date> {
        guard let firstDate = inBodyData.map({ $0.date }).min(),
              let lastDate = inBodyData.map({ $0.date }).max() else {
            let today = Date()
            return today...today
        }

        let calendar = Calendar.current
        let adjustedLastDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? lastDate
        
        return firstDate...adjustedLastDate
    }
    
    enum realmError: Error {
        case realmInstanceUnavailable
        case dataFetchFailed
        case unknownError
    }
}
