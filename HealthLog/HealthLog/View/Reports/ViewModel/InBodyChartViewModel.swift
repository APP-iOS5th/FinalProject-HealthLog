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
    
    var currentYear: Int
    var currentMonth: Int
    
    init() {
        self.realm = RealmManager.shared.getRealm()
        
        let currentDate = Date()
        let calendar = Calendar.current
        self.currentYear = calendar.component(.year, from: currentDate)
        self.currentMonth = calendar.component(.month, from: currentDate)
        
        self.fetchAndLoadData()
        
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
    
    func updateYearAndMonth(year: Int, month: Int) {
        self.currentYear = year
        self.currentMonth = month
        
        fetchAndLoadData()
    }
    
    
    func fetchAndLoadData() {
        
        fetchInBodyData(year: currentYear, month: currentMonth)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { [weak self] data in
                self?.inBodyData = []
                self?.inBodyData = data
                print("Fetched data: \(data.count)") // 데이터를 확인합니다.
                print("Assigned data: \(self?.inBodyData.count ?? 0)") // 할당 후 데이터를 확인합니다.
                print("-----------------------------------")
            })
            .store(in: &cancellables)
    }
    
    private func fetchInBodyData(year: Int, month: Int) -> Future<[InBody], Error> {
        return Future { result in
            
            guard let realm = self.realm else {
                result(.failure(realmError.realmInstanceUnavailable))
                return
            }
            
            let calendar = Calendar.current
            let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!.toKoreanTime()
            let range = calendar.range(of: .day, in: .month, for: startDate)
            let endDate = calendar.date(from: DateComponents(year: year, month: month, day: range!.count))!.toKoreanTime()
            
            let data = realm.objects(InBody.self).filter("date >= %@ AND date <= %@", startDate, endDate)
            result(.success(Array(data)))
            
            print("\(startDate) ~ \(endDate)")
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
                self.fetchAndLoadData()
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
//        formatter.locale = Locale(identifier: "ko_KR")
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
