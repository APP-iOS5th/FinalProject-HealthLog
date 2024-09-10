//
//  RealmManager.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Network
import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    private(set) var realm: Realm?
    //    var bodyParts: Results<BodyPart>
    
    private init() {
//        if let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL {
//            print("open \(realmFileURL)")
//        }
        openRealm()
        
        initializeRealmExercise()
        //        initializeRealmSchedule() // 5,6월 데이터 넣기 위해 잠시 주석처리 해놨습니다 _ 허원열
        
//        generateScheduleSampleData()
//        
//        addInBodySampleData()
        
        Task{ await self.initializeRealmExerciseImages() }
    }
    
    
    // 현재 init의 do catch 구문을 추후 openRealm 으로 변경 예정
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
            if let url = realm?.configuration.fileURL {
                print("open \(url))")
            }
            
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
                    let koreanDate = Calendar.current.startOfDay(for: Date())
                    // 날짜 범위 설정(같은 날짜의 데이터를 찾기 위함)
                    let startOfDay = koreanDate
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
    
    func toUTC() -> Date {
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let seconds = -TimeInterval(timeZone.secondsFromGMT(for: self))
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
            
            // 운동리스트 데이터 CSV 파일 Read
            var sampleExercises: [Exercise] = []
            if let csvPath = Bundle.main.path(forResource: "ExerciseData", ofType: "csv") {
                do {
                    let csvString = try String(contentsOfFile: csvPath, encoding: .utf8)
                    let exercisesJson = csvToJson(csvString: csvString)
                    let exercises = jsonToRealmObject(exercisesJson: exercisesJson)
                    sampleExercises = exercises
                } catch {
                    print("CSV 파일을 불러오는 데 실패했습니다: \(error)")
                }
            } else {
                print("CSV 파일 경로를 찾을 수 없습니다.")
            }
            
            try! realm.write {
                realm.add(sampleExercises)
            }
            
            print("Exercise 초기 데이터 넣기")
        } else {
            print("초기 Exercise 데이터가 이미 존재합니다.")
        }
    }
    
    @MainActor
    func initializeRealmExerciseImages() async {
        //        print("initializeRealmExerciseImages")
        guard let realm = realm else { return }
        
        print("initializeRealmExerciseImages - 이미지 확인 처리")
        
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
                //                print(exerciseImage)
                
                let accessCount = exerciseImage.urlAccessCount ?? -1
                
                guard let url = URL(string: String(exerciseImage.url ?? "")),
                      exerciseImage.image == nil,
                      0 <= accessCount && accessCount < 3
                else {
                    //                    print("-- end exerciseImage -- initializeRealmExerciseImages - not url, not nil")
                    continue
                }
                
                do {
                    //                    print("image \(index) url - \(url)")
                    let (imageData, _) = try await URLSession.shared.data(from: url)
                    //                    print(imageData)
                    //                    print("image \(index) write realm")
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
            
            // MARK: 영우 - toKoreanTime 추가
            var date = DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 1).date!.toKoreanTime()
            let endDate = DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 30).date!.toKoreanTime()
            
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
            
            let inBody = InBody(date: date.toKoreanTime(), weight: weight, bodyFat: bodyFat, muscleMass: muscleMass)
            sampleData.append(inBody)
        }
        
        
        for day in 1...25 {
            let date = makeDate(year: 2024, month: 8, day: day)
            let weight = Float.random(in: 60...90)
            let bodyFat = Float.random(in: 10...25)
            let muscleMass = Float.random(in: 20...40)
            
            let inBody = InBody(date: date.toKoreanTime(), weight: weight, bodyFat: bodyFat, muscleMass: muscleMass)
            sampleData.append(inBody)
        }
        
        for day in 1...2 {
            let date = makeDate(year: 2024, month: 9, day: day)
            let weight = Float.random(in: 60...90)
            let bodyFat = Float.random(in: 10...25)
            let muscleMass = Float.random(in: 20...40)
            
            let inBody = InBody(date: date.toKoreanTime(), weight: weight, bodyFat: bodyFat, muscleMass: muscleMass)
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

// MARK: - Routine Fucntion
extension RealmManager {
    
    func addRoutine(routine: Routine) {
        guard let realm = realm else { return }
        var volume: Int = 0
        for exercise in routine.exercises {
            for sets in exercise.sets {
                volume += sets.weight * sets.reps
            }
        }
        routine.exerciseVolume = volume
        do {
            try realm.write {
                realm.add(routine)
            }
        } catch {
            print("저장 실패")
        }
    }
    
    func fetchRoutine() -> [Routine] {
        var routine: [Routine] = []
        guard let realm = realm else { return routine }
        let fetchRoutine = realm.objects(Routine.self)
        fetchRoutine.forEach {
            routine.append($0)
            
        }
        return routine
    }
    
    func updetaRoutine(newRoutine: Routine, index: Int) {
        guard let realm = realm else { return }
        let oldRoutine = fetchRoutine()[index]
        
        
        do {
            try realm.write {
                oldRoutine.exercises = newRoutine.exercises
                oldRoutine.name = newRoutine.name
                oldRoutine.exerciseVolume = newRoutine.exerciseVolume
            }
        } catch {
            print("수정 실패")
        }
    }
    
    func hasRoutineName(name: String) -> Bool {
        guard let realm = realm else {
            return false
        }
        
        let isRoutineName = realm.objects(Routine.self)
            .map{ $0.name }
            .contains{ $0 == name}
        return isRoutineName
    }
    
    func deleteRoutine(id: ObjectId) {
        guard let realm = realm else { return }
        do{
            let routine = realm.objects(Routine.self)
                .filter { $0.id == id }
                .map{ $0 }
            
            try realm.write {
                realm.delete(routine)
                print("삭제 완료")
            }
        } catch {
            print("삭제 실패")
        }
    }
    
    func hasSchedule(date: Date) -> Schedule {
        guard let realm = realm else { return Schedule() }
        guard let schedule = realm.objects(Schedule.self).filter("date == %@", date).first else {
            return Schedule()
        }
        
        return schedule
    }
    
    
    func updateSchedule(index: Int) {
        guard let realm = realm else { return }
        let date = Calendar.current.startOfDay(for: Date()).toKoreanTime()
        print("동작은해\(date)")
        let routine = fetchRoutine()[index]
        if let schedule = realm.objects(Schedule.self).filter("date == %@", date).first
        {
            do {
                try realm.write {
                    for exercises in routine.exercises {
                        var schedulExeriseSets: [ScheduleExerciseSet] = []
                        
                        for sets in exercises.sets {
                            schedulExeriseSets.append(ScheduleExerciseSet(order: sets.order, weight: sets.weight, reps: sets.reps, isCompleted: false))
                        }
                        
                        schedule.exercises.append(ScheduleExercise(exercise: exercises.exercise!, order: schedule.exercises.count + 1, isCompleted: false, sets: schedulExeriseSets))
                        print("여까지도 잘동 잘해")
                    }
                }
            } catch {
                print("추가 실패")
                
            }
        } else {
            do {
                var order: Int = 1
                var scheduleExercise:[ScheduleExercise] = []
                for exercises in routine.exercises {
                    var schedulExeriseSets: [ScheduleExerciseSet] = []
                    
                    for sets in exercises.sets {
                        schedulExeriseSets.append(ScheduleExerciseSet(order: sets.order, weight: sets.weight, reps: sets.reps, isCompleted: false))
                    }
                    scheduleExercise.append(ScheduleExercise(exercise: exercises.exercise!, order: order, isCompleted: false, sets: schedulExeriseSets))
                    order += 1
                }
                
                let schedule = Schedule(date: date, exercises: scheduleExercise)
                try realm.write {
                    realm.add(schedule)
                }
            }
            catch {
                print("만들기 실패")
            }
        }
    }
}

// MARK: AddSchedule
extension RealmManager {
    // 세트 무게, 횟수 저장
    func updateSet(selectedExercises: [ScheduleExercise], at exerciseIndex: Int, setIndex: Int, weight: Int, reps: Int) {
        guard exerciseIndex < selectedExercises.count,
              setIndex < selectedExercises[exerciseIndex].sets.count else { return }
        guard let realm = realm else { return }
        do {
            try realm.write {
                selectedExercises[exerciseIndex].sets[setIndex].weight = weight
                selectedExercises[exerciseIndex].sets[setIndex].reps = reps
            }
        } catch {
            print("Error updating set: \(error.localizedDescription)")
        }
    }
    
    // 스케줄 해당 날짜에 저장
    func saveSchedule(selectedExercises: [ScheduleExercise], for date: Date) {
        guard let realm = realm else { return }
        
        do {
            if let existingSchedule = realm.objects(Schedule.self).filter("date == %@", date).first {
                try realm.write {
                    let maxOrder = existingSchedule.exercises.max(of: \.order) ?? 0
                    for (index, exercise) in selectedExercises.enumerated() {
                        exercise.order = maxOrder + index + 1
                    }
                    existingSchedule.exercises.append(objectsIn: selectedExercises)
                }
            } else {
                let newSchedule = Schedule(date: date, exercises: selectedExercises)
                try realm.write {
                    realm.add(newSchedule)
                }
            }
        } catch {
            print("Error saving schedule: \(error.localizedDescription)")
        }
    }
}

extension RealmManager {
    
    func csvToJson(csvString: String) -> [[String: String]] {
        var jsonArray: [[String: String]] = []
        
        let normalizedString = csvString
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        
        let rows = normalizedString.split(separator: "\n")
        
        guard let headerRow = rows.first else { return jsonArray }
        let headers = headerRow.split(separator: ",").map { String($0) }
        
        for row in rows.dropFirst() {
            let columns = row.split(separator: ",").map { String($0) }
            if columns.count == headers.count {
                var jsonDict: [String: String] = [:]
                for (index, header) in headers.enumerated() {
                    jsonDict[header] = columns[index]
                }
                jsonArray.append(jsonDict)
            }
        }
        
        return jsonArray
    }
    
    func jsonToRealmObject(exercisesJson: [[String: String]])  -> [Exercise] {
        var exercises: [Exercise] = []
        
        for json in exercisesJson {
            if let name = json["이름"],
               let bodyPart = json["부위"],
               let description = json["설명"],
               let firstURL = json["URL_1번 이미지"],
               let secondURL = json["URL_2번 이미지"] {
                
                let bodyPartsKey = bodyPart.split(separator: "/")
                var bodyParts = bodyPartsKey.map { key in
                    if let bodyPart = BodyPart(rawValue: String(key)) {
                        return bodyPart
                    } else {
                        return BodyPart.other
                    }
                }
                
                let overOtherCaseCount = bodyParts.filter ({
                    bodypart in bodypart == .other
                }).count
                
                if (overOtherCaseCount > 1) ||
                    (bodyParts.isEmpty == true) {
                    bodyParts = [BodyPart.other]
                }
                
                let exercise = Exercise(
                    name: name,
                    bodyParts: bodyParts,
                    descriptionText: description,
                    images: [
                        ExerciseImage(image: nil, url: firstURL,urlAccessCount: 0),
                        ExerciseImage(image: nil, url: secondURL, urlAccessCount: 0)
                    ],
                    totalReps: 0, recentWeight: 0, maxWeight: 0,
                    isCustom: false)
//                print(exercise)
                exercises.append(exercise)
            }
        }
//        print()
        return exercises
    }
}
