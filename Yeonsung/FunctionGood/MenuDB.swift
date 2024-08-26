import Foundation
import FirebaseFirestore

// 메뉴 가져오기 -> DB와 투표 창에서 쓸 것
func menuVote() -> [[String]] {
    // fetchTableMenu 함수를 호출하여 식단 정보를 가져옵니다.
    let menuArray = fetchTableMenu()
    
    // 처리된 식단 정보를 저장할 이중 배열
    var processedMenuArray = [[String]]()
    
    // 각 식단 정보를 처리합니다.
    for menu in menuArray {
        // 앞뒤 공백을 제거하고 공백을 기준으로 식단을 분리합니다.
        var menuItems = menu.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        
        // 빈 문자열을 걸러냅니다.
        menuItems = menuItems.filter { !$0.isEmpty }
        
        // "광", "복", "절"이 연속으로 나타나면 해당 항목들을 제거합니다.
        if let gwangIndex = menuItems.firstIndex(of: "광"),
           gwangIndex + 2 < menuItems.count, // 최소한 2개의 항목이 더 있는지 확인
           menuItems[gwangIndex + 1] == "복",
           menuItems[gwangIndex + 2] == "절" {
            
            // "광", "복", "절"을 제거합니다.
            menuItems.removeSubrange(gwangIndex...gwangIndex + 2)
        }
        
        // "광", "복", "절"이 연속으로 나타나면 해당 항목들을 제거합니다.
        if let gwangIndex = menuItems.firstIndex(of: "식"),
           gwangIndex + 2 < menuItems.count, // 최소한 2개의 항목이 더 있는지 확인
           menuItems[gwangIndex + 1] == "당",
           menuItems[gwangIndex + 2] == "휴",
           menuItems[gwangIndex + 3] == "무"
        {
            
            // "광", "복", "절"을 제거합니다.
            menuItems.removeSubrange(gwangIndex...gwangIndex + 3)
        }
        
        // 필터링된 항목 중 제거할 항목들
        if menuItems.contains("※동계방학") {
            menuItems.removeAll { $0 == "※동계방학" || $0 == "동안은" || $0 == "전" || $0 == "메뉴" || $0 == "코너" || $0 == "1에서" || $0 == "제공됩니다." }
        }
        
        if menuItems.contains("등록된") {
            menuItems.removeAll { $0 == "등록된" || $0 == "식단내용이(가)" || $0 == "없습니다." }
        }
        
        if menuItems.contains("오늘은") {
            menuItems.removeAll { $0 == "오늘은" || $0 == "메뉴가" || $0 == "없습니다." }
        }
        
        if menuItems.contains("방학") {
            menuItems.removeAll { $0 == "방학" || $0 == "중에는" || $0 == "면" || $0 == "º" || $0 == "분식류" || $0 == "ⓢ" || $0 == "에서" || $0 == "제공됩니다" || $0 == ":)" }
        }
        
        if menuItems.contains("하계방학") {
            menuItems.removeAll { $0 == "하계방학" || $0 == "전체휴무"}
        }
        
        if menuItems.contains("식당") {
            menuItems.removeAll { $0 == "식당" || $0 == "미운영"}
        }
        if menuItems.contains("운영없음") {
            menuItems.removeAll { $0 == "운영없음"}
        }
        if menuItems.contains("현충일") {
            menuItems.removeAll { $0 == "현충일"}
        }
        if menuItems.contains("부처님오신날") {
            menuItems.removeAll { $0 == "부처님오신날"}
        }
        if menuItems.contains("대체공휴일(어린이날)") {
            menuItems.removeAll { $0 == "대체공휴일(어린이날)"}
        }
        if menuItems.contains("식당") {
            menuItems.removeAll { $0 == "식당"  || $0 == "휴무"}
        }
        
        
        // 각 식단 항목을 새 배열에 추가합니다.
        processedMenuArray.append(menuItems)
    }
    
    return processedMenuArray
}

let db = Firestore.firestore()

func checkAndUpdateMenu() {
    let todayDate = getTodayDateString()
    
    let docRef = db.collection("meta").document("dailyUpdate")
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            if let lastUpdate = document.get("lastUpdate") as? String {
                print("Today Date: \(todayDate)") // Log today's date
                print("Last Update Date: \(lastUpdate)") // Log last update date
                
                if lastUpdate == todayDate {
                    print("Menu already updated today")
                } else {
                    updateDailyMenu()
                }
            } else {
                updateDailyMenu()
            }
        } else {
            updateDailyMenu()
        }
    }
}

func getTodayDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // Set to Korea Standard Time
    return dateFormatter.string(from: Date())
}

func updateDailyMenu() {
    let todayMenu = menuVote() // 이중 배열로 구성된 오늘의 메뉴

    var itemsData: [String: [String: Any]] = [:]

    // 이중 배열을 순회하여 데이터를 구성
    for (sectionIndex, sectionItems) in todayMenu.enumerated() {
        for (itemIndex, menuItem) in sectionItems.enumerated() {
            let itemKey = "item\(sectionIndex)_\(itemIndex)" // 각 항목에 고유한 키 생성
            itemsData[itemKey] = [
                "itemName": menuItem,
                "voteCount": 0
            ]
        }
    }

    // 'votes' 컬렉션의 'dailyMenu' 문서 참조
    let docRef = db.collection("votes").document("dailyMenu")

    // 기존 문서가 존재하는 경우 삭제
    docRef.delete { err in
        if let err = err {
            print("문서 삭제 중 오류 발생: \(err)")
        } else {
            print("문서가 성공적으로 삭제되었습니다!")
            
            // 삭제 후, 새로운 데이터를 삽입
            docRef.setData([
                "items": itemsData
            ]) { err in
                if let err = err {
                    print("메뉴 문서 업데이트 중 오류 발생: \(err)")
                } else {
                    print("메뉴 문서가 성공적으로 업데이트되었습니다!")

                    // "lastUpdate" 필드를 "dailyUpdate" 문서에서 업데이트
                    let todayDate = getTodayDateString()
                    db.collection("meta").document("dailyUpdate").setData([
                        "lastUpdate": todayDate
                    ])
                }
            }
        }
    }
}
