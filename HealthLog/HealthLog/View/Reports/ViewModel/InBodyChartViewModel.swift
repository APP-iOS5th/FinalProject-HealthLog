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
//    @Published var inbodyRecords: [InBody] = []
    
    private var realm: Realm?
//    private var inputNotificationToken: NotificationToken?
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
            let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            let range = calendar.range(of: .day, in: .month, for: startDate)
            let endDate = calendar.date(from: DateComponents(year: year, month: month, day: range!.count))!
            
            let data = realm.objects(InBody.self).filter("date >= %@ AND date <= %@", startDate, endDate)
            result(.success(Array(data)))
            
            
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
    
   
    
    
    // MARK: - Chart label
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
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
        let adjustedFirstDate = calendar.date(byAdding: .day, value: -1, to: firstDate) ?? firstDate
        let adjustedLastDate = calendar.date(byAdding: .day, value: 1, to: lastDate) ?? lastDate
        
        return adjustedFirstDate...adjustedLastDate
    }
    
    enum realmError: Error {
        case realmInstanceUnavailable
        case dataFetchFailed
        case unknownError
    }
}
