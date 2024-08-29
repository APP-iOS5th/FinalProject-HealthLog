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
    
    private var realm: Realm
    private var notificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    
    private var currentStartDate: Date?
    private var currentEndDate: Date?
    
    init() {
        self.realm = RealmManager.shared.getRealm()
        observeInBodyDataChanges()
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
                let data = self.realm.objects(InBody.self).filter("date >= %@ AND date <= %@", startDate, endDate)
                result(.success(Array(data)))
            }
        }
    }
    
    private func observeInBodyDataChanges() {
        let results = realm.objects(InBody.self)
        
        // Realm 데이터를 Combine으로 변환하여 관찰
        notificationToken = results.observe { [weak self] changes in
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
        notificationToken?.invalidate()
    }
    
    
    
    func getWeight(for date: Date) -> Int {
        return Int(inBodyData.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        })?.weight ?? 0)
    }
    
    func yAxisDomain() -> ClosedRange<Double> {
        let weights = inBodyData.map { Double($0.weight) }
        let minWeight = weights.min() ?? 30.0
        let maxWeight = weights.max() ?? 100.0
        
        // 위 아래 여백을 위한 조절
        let minDomain = minWeight - 10.0
        let maxDomain = maxWeight + 10.0
        
        // 최소 몸무게 = 0
        let adjustedMinDomain = minDomain < 0 ? 0 : minDomain
        
        return adjustedMinDomain...maxDomain
    }
    
}
