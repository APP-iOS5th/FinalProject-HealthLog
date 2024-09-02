//
//  RealmManager.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    private(set) var realm: Realm?
    //    var bodyParts: Results<BodyPart>
    
    private init() {
        if let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("open \(realmFileURL)")
        }
        openRealm()
        
        initializeRealmExercise()
        initializeRealmRoutine()
        //        initializeRealmSchedule() // 5,6월 데이터 넣기 위해 잠시 주석처리 해놨습니다 _ 허원열
        
        generateScheduleSampleData()
        
        addInBodySampleData()
        
        Task{ await initializeRealmExerciseImages() }
    }
    
    
    // 현재 init의 do catch 구문을 추후 openRealm 으로 변경 예정
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
            
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    
    func getRealm() -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Could not access Realm database: \(error)")
        }
    }
    
    
    func addInbody(weight: Float, bodyFat:Float, muscleMass: Float) {
        if let realm = realm {
            do {
                try realm.write {
                    // 현재 시간을 한국 시간으로 변환
                    let koreanDate = Date().toKoreanTime()
                    // 날짜 범위 설정(같은 날짜의 데이터를 찾기 위함)
                    let startOfDay = Calendar.current.startOfDay(for: koreanDate)
                    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
                    // 현재 날짜만 선택하여 기존 데이터를 조회
                    let existingInbody = realm.objects(InBody.self).filter("date >= %@ AND date < %@", startOfDay, endOfDay)
                    // 같은 날짜에 이미 기록이 존재하면 데이터를 업데이트
                    if let existingInBodyRecord = existingInbody.first {
                        existingInBodyRecord.weight = weight
                        existingInBodyRecord.bodyFat = bodyFat
                        existingInBodyRecord.muscleMass = muscleMass
                        existingInBodyRecord.date = koreanDate
                    } else {
                        // 같은 날짜에 기록이 없으면 새로운 기록 추가
                        let newInbodyInfo = InBody(value: ["weight": weight, "bodyFat": bodyFat, "muscleMass": muscleMass, "date": koreanDate])
                        realm.add(newInbodyInfo)
                        print("Added new Inbody Info")
                    }
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    func getInBodyDataForChart(from startDate: Date, to endDate: Date) -> [InBody] {
        do {
            let realm = try Realm()
            let results = realm.objects(InBody.self).filter("date >= %@ AND date <= %@", startDate, endDate)
            print("Realm query results count: \(results.count)") // 쿼리 결과의 개수를 출력
            return Array(results)
        } catch {
            print("Error fetching data from Realm: \(error)")
            return []
        }
    }
    
}

// KoreanTime Date Extension 추가
extension Date {
    func toKoreanTime() -> Date {
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return addingTimeInterval(seconds)
    }
}

//extension RealmManager {
//    func bodyPartSearch (_ bodyPartTypes: [BodyPart]) -> [BodyPart] {
//        let filteredBodyParts = bodyParts.filter { bodyPart in
//            bodyPartTypes.contains(bodyPart.name)
//        }
//        return Array(filteredBodyParts)
//    }
//}

// MARK: - InitializeRealmData
extension RealmManager {
    
    func initializeRealmExercise() {
        guard let realm = realm else {return}
        
        if realm.objects(Exercise.self).isEmpty {
            let sampleExercises = [
                Exercise(
                    name: "스쿼트", bodyParts: [.quadriceps, .glutes],
                    descriptionText: "다리 운동", images: [],
                    totalReps: 75, recentWeight: 80, maxWeight: 120,
                    isCustom: true
                ),
                Exercise(name: "Shoulder Press", bodyParts: [.shoulders], descriptionText: "Shoulder exercise TestTe stTestTestTestT estTest TestTestTestTestT estTestT TestTestTestTestTestTe stTestTe stTestTestTes tTestTestTestTest ", images: [], totalReps: 60, recentWeight: 40, maxWeight: 60, isCustom: false),
                Exercise(name: "Bicep Curl", bodyParts: [.biceps], descriptionText: "Arm exercise", images: [], totalReps: 90, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Tricep Dip", bodyParts: [.triceps], descriptionText: "Arm exercise", images: [
                    ExerciseImage(
                        image: nil, url: "https://upload.wikimedia.org/wikipedia/commons/5/5d/Squats-1.png",
                        urlAccessCount: 0),
                    ExerciseImage(
                        image: nil, url: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Squats-2.png",
                        urlAccessCount: 0)
                ], totalReps: 80, recentWeight: 25, maxWeight: 40, isCustom: false),
                Exercise(name: "Lateral Raise", bodyParts: [.shoulders], descriptionText: "Shoulder isolation exercise", images: [], totalReps: 70, recentWeight: 10, maxWeight: 15, isCustom: false),
                Exercise(name: "레그 프레스", bodyParts: [.quadriceps, .glutes], descriptionText: "다리 운동2", images: [], totalReps: 50, recentWeight: 180, maxWeight: 200, isCustom: true),
                Exercise(name: "Plank", bodyParts: [.abs], descriptionText: "Core exercise", images: [
                    ExerciseImage(
                        image: nil, url: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Squats-2.png",
                        urlAccessCount: 0)
                ], totalReps: 5, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Leg Curl", bodyParts: [.hamstrings], descriptionText: "Hamstring exercise", images: [], totalReps: 60, recentWeight: 50, maxWeight: 60, isCustom: false),
                Exercise(name: "Calf Raise", bodyParts: [.calves, .biceps, .forearms, .abductors, .quadriceps, .triceps], descriptionText: "Calf exercise", images: [], totalReps: 100, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Pull-up", bodyParts: [.back, .biceps], descriptionText: "Back and biceps exercise", images: [], totalReps: 40, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Chest Fly", bodyParts: [.chest], descriptionText: "Chest isolation exercise", images: [], totalReps: 70, recentWeight: 25, maxWeight: 40, isCustom: false),
                Exercise(name: "Russian Twist", bodyParts: [.abs], descriptionText: "Core rotational exercise", images: [], totalReps: 50, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Glute Bridge", bodyParts: [.glutes], descriptionText: "Glute exercise", images: [], totalReps: 30, recentWeight: 40, maxWeight: 60, isCustom: false),
                Exercise(name: "Lunges", bodyParts: [.quadriceps, .glutes], descriptionText: "Leg exercise", images: [], totalReps: 60, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Hammer Curl", bodyParts: [.biceps], descriptionText: "Bicep exercise", images: [], totalReps: 80, recentWeight: 15, maxWeight: 25, isCustom: false),
                Exercise(name: "Tricep Kickback", bodyParts: [.triceps], descriptionText: "Tricep isolation exercise", images: [], totalReps: 75, recentWeight: 10, maxWeight: 15, isCustom: false),
                Exercise(name: "Side Plank", bodyParts: [.abs], descriptionText: "Core stabilization exercise", images: [], totalReps: 5, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Hip Thrust", bodyParts: [.glutes], descriptionText: "Glute exercise", images: [], totalReps: 50, recentWeight: 60, maxWeight: 80, isCustom: false)
            ]
            
            try! realm.write {
                realm.add(sampleExercises)
            }
            
            print("기본 Exercise 더미데이터 넣기")
        } else {
            print("기본 Exercise 데이터가 이미 존재합니다.")
        }
    }
    
    @MainActor
    func initializeRealmExerciseImages() async {
        print("initializeRealmExerciseImages")
        guard let realm = realm else { return }
        
        let exercises = realm.objects(Exercise.self)
        
        let exercisesCount = exercises.count
        for exercisesIndex in 0..<exercisesCount {
            let exercise = exercises[exercisesIndex]
//            print("--start exercise \(exercise.name) --")
//            print(exercise.images)
            guard exercise.isCustom == false
            else {
//                print("-- end \(exercise.name) 유저가 추가했으므로, 이미지 url 없음 - exercise.isCustom - \(exercise.isCustom) --")
                continue
            }
            
            guard !exercise.images.isEmpty else {
//                print("-- end \(exercise.name) 더미 데이터지만, 이미지 배열은 비어있음 - exercise.images.isEmpty - \(exercise.images.isEmpty) --")
                continue
            }
            
            let imagesCount = exercise.images.count
//            print("exercise.images.count - \(imagesCount)")
            for index in 0..<imagesCount {
//                print("-- start exerciseImage \(index) --")
                let exerciseImage = exercise.images[index]
                print(exerciseImage)
                
                let accessCount = exerciseImage.urlAccessCount ?? -1
                
                guard let url = URL(string: String(exerciseImage.url ?? "")),
                      exerciseImage.image == nil,
                      0 <= accessCount && accessCount < 3
                else {
//                    print("-- end exerciseImage -- initializeRealmExerciseImages - not url, not nil")
                    continue
                }
                
                do {
                    print("image \(index) url - \(url)")
                    let (imageData, _) = try await URLSession.shared.data(from: url)
                    print(imageData)
                    print("image \(index) write realm")
                    realm.writeAsync {
                        exerciseImage.image = imageData
                        exerciseImage.urlAccessCount = -1
                    }
                    
                } catch {
                    print("image\(index) 이미지 다운로드 실패: \(error)")
                    realm.writeAsync {
                        exerciseImage.urlAccessCount = accessCount + 1
                    }
                }
                
//                print("--end exerciseImage \(index) --")
            }
            
//            print("--end exercise \(exercise.name) --")
        }
        
    }
    
    
    func initializeRealmRoutine() {
        guard let realm = realm else { return }
        
        
        
        if realm.objects(Routine.self).isEmpty {
            
            // 1. 기존 Exercise 객체 조회
            let exercises = realm.objects(Exercise.self)
            
            // Exercise 데이터가 존재하지 않는 경우 처리
            guard !exercises.isEmpty else {
                print("Routine - 기존 Exercise 데이터가 없습니다.")
                return
            }
            
            // 2. RoutineExercise 및 RoutineExerciseSet 생성
            let routineExercises1 = [
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    sets: [
                        RoutineExerciseSet(order: 2, weight: 90, reps: 12)
                    ]
                ),
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 150, reps: 10),
                        RoutineExerciseSet(order: 2, weight: 160, reps: 8)
                    ]
                )
            ]
            
            let routineExercises2 = [
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 85, reps: 15),
                        RoutineExerciseSet(order: 2, weight: 95, reps: 12)
                    ]
                ),
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 160, reps: 10),
                        RoutineExerciseSet(order: 2, weight: 170, reps: 8)
                    ]
                )
            ]
            
            let routineExercises3 = [
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 90, reps: 12),
                        RoutineExerciseSet(order: 2, weight: 100, reps: 10)
                    ]
                ),
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 160, reps: 12),
                        RoutineExerciseSet(order: 1, weight: 170, reps: 10),
                        RoutineExerciseSet(order: 2, weight: 180, reps: 8)
                    ]
                )
            ]
            
            let routine1 = Routine(name: "하체 루틴 1", exercises: routineExercises1, exerciseVolume: 2)
            let routine2 = Routine(name: "하체 루틴 2", exercises: routineExercises2, exerciseVolume: 2)
            let routine3 = Routine(name: "하체 루틴 3", exercises: routineExercises3, exerciseVolume: 2)
            
            // 3. Realm에 샘플 데이터 추가
            try! realm.write {
                realm.add([routine1, routine2, routine3])
            }
            
            
            print("기본 Routine 더미데이터 넣기")
        } else {
            print("기본 Routine 데이터가 이미 존재합니다.")
        }
    }
    
    func initializeRealmSchedule() {
        guard let realm = realm else {return}
        
        if realm.objects(Schedule.self).isEmpty {
            
            // 1. 기존 Exercise 객체 조회
            let exercises = realm.objects(Exercise.self)
            
            // Exercise 데이터가 존재하지 않는 경우 처리
            guard !exercises.isEmpty else {
                print("Schedule - 기존 Exercise 데이터가 없습니다.")
                return
            }
            
            // 2. ScheduleExercise 및 HighlightedBodyPart 생성
            let sampleExercises1 = [
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    order: 1,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 80, reps: 15, isCompleted: true)
                    ]
                ),
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    order: 2,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 150, reps: 6, isCompleted: true),
                        ScheduleExerciseSet(order: 2, weight: 160, reps: 8, isCompleted: true)
                    ]
                )
            ]
            let sampleExercises2 = [
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    order: 1,
                    isCompleted: true,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 90, reps: 15, isCompleted: true)
                    ]
                ),
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    order: 2,
                    isCompleted: true,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 170, reps: 12, isCompleted: true)
                    ]
                )
            ]
            let sampleExercises3 = [
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    order: 1,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 80, reps: 15, isCompleted: true),
                        ScheduleExerciseSet(order: 2, weight: 90, reps: 10, isCompleted: true),
                    ]
                ),
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    order: 2,
                    isCompleted: false,
                    sets: [ScheduleExerciseSet(order: 1, weight: 180, reps: 12, isCompleted: true)]
                )
            ]
            
            
            let sampleSchedule = [
                Schedule(date: getDate(year: 2024, month: 7, day: 15), exercises: sampleExercises1),
                Schedule(date: getDate(year: 2024, month: 8, day: 15), exercises: sampleExercises2),
                Schedule(date: getDate(year: 2024, month: 8, day: 21), exercises: sampleExercises3),
            ]
            
            // 3. Realm에 샘플 데이터 추가
            try! realm.write {
                realm.add(sampleSchedule)
            }
            
            print("기본 Schedule 더미데이터 넣기")
        } else {
            print("기본 Schedule 데이터가 이미 존재합니다.")
        }
    }
    
    
    // MARK: - 초기화에 필요한 함수들
    private func getDate(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents) ?? Date()
    }
    
}

extension RealmManager {
    
    func generateScheduleSampleData() {
        guard let realm = realm else {return}
        
        if realm.objects(Schedule.self).isEmpty {
            let allExercises = realm.objects(Exercise.self)
            var schedules: [Schedule] = []
            
            var date = DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 1).date!
            let endDate = DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 30).date!
            
            while date <= endDate {
                var scheduleExercises: [ScheduleExercise] = []
                
                for i in 0..<3 {
                    guard let exercise = allExercises.randomElement() else {return}
                    
                    let weights = [10,20,30,40,50,60,70,80,90,100]
                    
                    let sets = [
                        ScheduleExerciseSet(order: 1, weight: weights.randomElement() ?? 60, reps: 10, isCompleted: Bool.random()),
                        ScheduleExerciseSet(order: 2, weight: weights.randomElement() ?? 60, reps: 10, isCompleted: Bool.random()),
                        ScheduleExerciseSet(order: 3, weight: weights.randomElement() ?? 60, reps: 10, isCompleted: Bool.random()),
                    ]
                    
                    let scheduleExercise = ScheduleExercise(exercise: exercise, order: i+1, isCompleted: Bool.random(), sets: sets)
                    scheduleExercises.append(scheduleExercise)
                }
                let schedule = Schedule(date: date, exercises: scheduleExercises)
                schedules.append(schedule)
                
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                
            }
            
            do {
                try realm.write {
                    realm.add(schedules)
                }
                
                print("5,6월 Schedule 샘플 데이터를 추가하였습니다.")
            } catch {
                print("5,6월 Schedule 샘플 데이터를 추가에 실패했습니다. \(error)")
            }
        }
        
        else {
            print(" 5,6월 Schedule 샘플 데이터가 이미 존재합니다.")
        }
    }
    
    func addInBodySampleData() {
        guard let realm = realm else {return}
        
        var sampleData = [InBody]()
        
        for day in 1...14 {
            let date = makeDate(year: 2024, month: 7, day: day)
            let weight = Float.random(in: 50...70)
            let bodyFat = Float.random(in: 10...25)
            let muscleMass = Float.random(in: 20...40)
            
            let inBody = InBody(date: date, weight: weight, bodyFat: bodyFat, muscleMass: muscleMass)
            sampleData.append(inBody)
        }
        
        
        for day in 1...25 {
            let date = makeDate(year: 2024, month: 8, day: day)
            let weight = Float.random(in: 60...90)
            let bodyFat = Float.random(in: 10...25)
            let muscleMass = Float.random(in: 20...40)
            
            let inBody = InBody(date: date, weight: weight, bodyFat: bodyFat, muscleMass: muscleMass)
            sampleData.append(inBody)
        }
        
        if realm.objects(InBody.self).isEmpty {
            try! realm.write {
                realm.add(sampleData)
                print("인바디 샘플 데이터를 추가하였습니다.")
            }
        }
    }
    
    func makeDate(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
