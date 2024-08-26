import SwiftSoup
import SwiftUI
import Foundation
import GoogleMobileAds

// 카테고리 함수 (Ex: 코너1 코너2 코너3)
func fetchTableCategory() -> [String] {
    var thTextArray = [String]() // 빈 배열을 생성합니다.
    
    let urlString = "https://www.yeonsung.ac.kr/ko/582/subview.do"
    
    guard let url = URL(string: urlString) else {
        print("유효하지 않은 URL입니다.")
        return thTextArray // 빈 배열을 반환합니다.
    }
    
    do {
        let htmlString = try String(contentsOf: url)
        let doc = try SwiftSoup.parse(htmlString)
        
        // tbody 태그를 선택합니다.
        guard let tbody = try doc.select("tbody").first() else {
            print("tbody를 찾을 수 없습니다.")
            return thTextArray // 빈 배열을 반환합니다.
        }
        
        // tbody 내부의 모든 tr 태그를 선택합니다.
        let trs = try tbody.select("tr")
        
        for tr in trs {
            // tr 태그 내부의 th 태그를 선택합니다.
            let ths = try tr.select("th")
            
            for th in ths {
                // th 태그의 텍스트를 가져와 배열에 추가합니다.
                let thText = try th.text()
                thTextArray.append(thText)
                
            }
        }
    } catch {
        print("HTML 파싱 중 오류가 발생했습니다: \(error)")
        return thTextArray // 빈 배열을 반환합니다.
    }
    return thTextArray // 결과 배열을 반환합니다.
}

// 식단 내용 함수 (Ex: 라면, 떡볶이, 치킨덮밥..)
func fetchTableMenu() -> [String] {
    
    // 식단을 저장할 배열
    var menuArray = [String]()
    // 오늘 요일 불러오기
    let currentDayOfWeek = currentDay()
    let categolyCount = fetchTableCategory()
    // 요일별 메뉴
    var mondayMenu = [String]()
    var tuesdayMenu = [String]()
    var wednesdayMenu = [String]()
    var thursdayMenu = [String]()
    var fridayMenu = [String]()
    
    // URL of the webpage containing the menu
    let urlString = "https://www.yeonsung.ac.kr/ko/582/subview.do"
    
    // Create URL object
    guard let url = URL(string: urlString) else {
        print("Invalid URL.")
        return menuArray
    }
    
    do {
        // Get HTML string from URL and parse it
        let htmlString = try String(contentsOf: url)
        let doc = try SwiftSoup.parse(htmlString)
        
        // Select tbody tag
        guard let tbody = try doc.select("tbody").first() else {
            print("tbody not found.")
            return menuArray
        }
        
        // select all tr ​​tags within tbody
        let trs = try tbody.select("tr")
        
        // Loop through each tr tag
        for tr in trs {
            // Select td tag corresponding to each day of the week
            let tds = try tr.select("td")
            
            // Loop through each td tag
            for (index, td) in tds.enumerated() {
                // Get the text value of the td tag
                let tdText = try td.text()
                
                // Add tdText to the corresponding day of the week variable
                switch index {
                case 0:
                    mondayMenu.append(tdText)
                case 1:
                    tuesdayMenu.append(tdText)
                case 2:
                    wednesdayMenu.append(tdText)
                case 3:
                    thursdayMenu.append(tdText)
                case 4:
                    fridayMenu.append(tdText)
                default:
                    break
                }
            }
        }
        
        // 해당 요일에 따라 결과 반환
        switch currentDayOfWeek {
        case "월요일":
            menuArray = mondayMenu
        case "화요일":
            menuArray = tuesdayMenu
        case "수요일":
            menuArray = wednesdayMenu
        case "목요일":
            menuArray = thursdayMenu
        case "금요일":
            menuArray = fridayMenu
        default:
            // 토요일과 일요일은 메뉴가 없음
            for _ in categolyCount{
                menuArray.append("오늘은 메뉴가 없습니다.")
            }
        }
    } catch {
        print("An error occurred while parsing HTML: \(error)")
    }
    
    return menuArray
}

func menuInformation() -> [[String]] {
    // fetchTableMenu 함수를 호출하여 식단 정보를 가져옵니다.
    let menuArray = fetchTableMenu()
    
    // 처리된 식단 정보를 저장할 이중 배열
    var processedMenuArray = [[String]]()
    
    // 각 식단 정보를 처리합니다.
    for menu in menuArray {
        // 앞뒤 공백을 제거하고 공백을 기준으로 식단을 분리합니다.
        let menuItems = menu.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        
        // 빈 문자열을 걸러냅니다.
        var filteredMenuItems = menuItems.filter { !$0.isEmpty }
        
        // 필터링 된 항목 중 제거
        if filteredMenuItems.contains("※동계방학"){
            filteredMenuItems.removeAll { $0 == "※동계방학" || $0 == "동안은" || $0 == "전"||$0 == "메뉴"||$0 == "코너"||$0 == "1에서"||$0 == "제공됩니다." }
        }
        
        if filteredMenuItems.contains("등록된") {
            filteredMenuItems.removeAll { $0 == "등록된" || $0 == "식단내용이(가)" || $0 == "없습니다." }
            filteredMenuItems.append("등록된 식단내용이(가) 없습니다.")
        }
        
        if filteredMenuItems.contains("오늘은") {
            filteredMenuItems.removeAll { $0 == "오늘은" || $0 == "메뉴가" || $0 == "없습니다." }
            filteredMenuItems.append("오늘은 메뉴가 없습니다.")
        }
        if filteredMenuItems.contains("방학") {
            filteredMenuItems.removeAll { $0 == "방학" || $0 == "중에는" || $0 == "면" || $0 == "º" || $0 == "분식류" || $0 == "ⓢ" || $0 == "에서" || $0 == "제공됩니다" || $0 == ":)"}
        }

        
        // 각 식단 항목을 새 배열에 추가합니다.
        processedMenuArray.append(filteredMenuItems)
    }
    
    return processedMenuArray
}




// 오늘 날짜 나타내기 함수
func currentDateFormatted() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: Date())
}

// 오늘의 요일 나타내기 함수
func currentDay() -> String {
    let today = Date() // 현재 날짜를 가져옴
    let calendar = Calendar.current
    
    let weekday = calendar.component(.weekday, from: today) // 요일을 가져옴 (1: 일요일, 2: 월요일, ..., 7: 토요일)
    
    // 요일에 따라 문자열로 반환
    switch weekday {
    case 1:
        return "일요일"
    case 2:
        return "월요일"
    case 3:
        return "화요일"
    case 4:
        return "수요일"
    case 5:
        return "목요일"
    case 6:
        return "금요일"
    case 7:
        return "토요일"
    default:
        return "알 수 없음"
    }
}

// 여기부터는 교직원 식당 관해서
// 카테고리 함수 (Ex: 코너1 코너2 코너3)
func teacherFetchTableCategory() -> [String] {
    var thTextArray = [String]() // 빈 배열을 생성합니다.
    
    let urlString = "https://www.yeonsung.ac.kr/ko/583/subview.do"
    
    guard let url = URL(string: urlString) else {
        print("유효하지 않은 URL입니다.")
        return thTextArray // 빈 배열을 반환합니다.
    }
    
    do {
        let htmlString = try String(contentsOf: url)
        let doc = try SwiftSoup.parse(htmlString)
        
        // tbody 태그를 선택합니다.
        guard let tbody = try doc.select("tbody").first() else {
            print("tbody를 찾을 수 없습니다.")
            return thTextArray // 빈 배열을 반환합니다.
        }
        
        // tbody 내부의 모든 tr 태그를 선택합니다.
        let trs = try tbody.select("tr")
        
        for tr in trs {
            // tr 태그 내부의 th 태그를 선택합니다.
            let ths = try tr.select("th")
            
            for th in ths {
                // th 태그의 텍스트를 가져와 배열에 추가합니다.
                let thText = try th.text()
                thTextArray.append(thText)
            }
        }
    } catch {
        print("HTML 파싱 중 오류가 발생했습니다: \(error)")
        return thTextArray // 빈 배열을 반환합니다.
    }
    return thTextArray // 결과 배열을 반환합니다.
}

// 식단 내용 함수 (Ex: 라면, 떡볶이, 치킨덮밥..)
func teacherFetchTableMenu() -> [String] {
    
    // 식단을 저장할 배열
    var menuArray = [String]()
    // 오늘 요일 불러오기
    let currentDayOfWeek = currentDay()
    let categolyCount = teacherFetchTableCategory()
    // 요일별 메뉴
    var mondayMenu = [String]()
    var tuesdayMenu = [String]()
    var wednesdayMenu = [String]()
    var thursdayMenu = [String]()
    var fridayMenu = [String]()
    
    // URL of the webpage containing the menu
    let urlString = "https://www.yeonsung.ac.kr/ko/583/subview.do"
    
    // Create URL object
    guard let url = URL(string: urlString) else {
        print("Invalid URL.")
        return menuArray
    }
    
    do {
        // Get HTML string from URL and parse it
        let htmlString = try String(contentsOf: url)
        let doc = try SwiftSoup.parse(htmlString)
        
        // Select tbody tag
        guard let tbody = try doc.select("tbody").first() else {
            print("tbody not found.")
            return menuArray
        }
        
        // select all tr ​​tags within tbody
        let trs = try tbody.select("tr")
        
        // Loop through each tr tag
        for tr in trs {
            // Select td tag corresponding to each day of the week
            let tds = try tr.select("td")
            
            // Loop through each td tag
            for (index, td) in tds.enumerated() {
                // Get the text value of the td tag
                let tdText = try td.text()
                
                // Add tdText to the corresponding day of the week variable
                switch index {
                case 0:
                    mondayMenu.append(tdText)
                case 1:
                    tuesdayMenu.append(tdText)
                case 2:
                    wednesdayMenu.append(tdText)
                case 3:
                    thursdayMenu.append(tdText)
                case 4:
                    fridayMenu.append(tdText)
                default:
                    break
                }
            }
        }
        
        // 해당 요일에 따라 결과 반환
        switch currentDayOfWeek {
        case "월요일":
            menuArray = mondayMenu
        case "화요일":
            menuArray = tuesdayMenu
        case "수요일":
            menuArray = wednesdayMenu
        case "목요일":
            menuArray = thursdayMenu
        case "금요일":
            menuArray = fridayMenu
        default:
            // 토요일과 일요일은 메뉴가 없음
            for _ in categolyCount{
                menuArray.append("오늘은 메뉴가 없습니다.")
            }
        }
    } catch {
        print("An error occurred while parsing HTML: \(error)")
    }
    
    return menuArray
}

func teacherMenuInformation() -> [[String]] {
    // fetchTableMenu 함수를 호출하여 식단 정보를 가져옵니다.
    let menuArray = teacherFetchTableMenu()
    
    // 처리된 식단 정보를 저장할 이중 배열
    var processedMenuArray = [[String]]()
    
    // 각 식단 정보를 처리합니다.
    for menu in menuArray {
        // 앞뒤 공백을 제거하고 공백을 기준으로 식단을 분리합니다.
        let menuItems = menu.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        
        // 빈 문자열을 걸러냅니다.
        var filteredMenuItems = menuItems.filter { !$0.isEmpty }
        
        // 필터링 된 항목 중 제거
        if filteredMenuItems.contains("※동계방학"){
            filteredMenuItems.removeAll { $0 == "※동계방학" || $0 == "동안은" || $0 == "전"||$0 == "메뉴"||$0 == "코너"||$0 == "1에서"||$0 == "제공됩니다." }
        }
        
        if filteredMenuItems.contains("등록된") {
            filteredMenuItems.removeAll { $0 == "등록된" || $0 == "식단내용이(가)" || $0 == "없습니다." }
            filteredMenuItems.append("등록된 식단내용이(가) 없습니다.")
        }
        
        if filteredMenuItems.contains("오늘은") {
            filteredMenuItems.removeAll { $0 == "오늘은" || $0 == "메뉴가" || $0 == "없습니다." }
            filteredMenuItems.append("오늘은 메뉴가 없습니다.")
        }
        
        if filteredMenuItems.contains("부처님") {
            filteredMenuItems.removeAll { $0 == "부처님" || $0 == "오신날" }
            filteredMenuItems.append("부처님 오신날")
        }
        

        
        // 각 식단 항목을 새 배열에 추가합니다.
        processedMenuArray.append(filteredMenuItems)
    }
    
    return processedMenuArray
}

// 배너
struct AdBannerViewController: UIViewControllerRepresentable {
    let adUnitID: String

    func makeUIViewController(context: Context) -> UIViewController {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = context.coordinator.viewController
        bannerView.delegate = context.coordinator

        let viewController = UIViewController()
        viewController.view.addSubview(bannerView)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])

        // Load the ad only once
        bannerView.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        var viewController = UIViewController()

        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Banner ad loaded successfully")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to load banner ad: \(error.localizedDescription)")
        }
    }
}

//전면 광고
class InterstitialAdViewController: UIViewController, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    private let adUnitID: String
    private let onAdDismissed: () -> Void

    init(adUnitID: String, onAdDismissed: @escaping () -> Void) {
        self.adUnitID = adUnitID
        self.onAdDismissed = onAdDismissed
        super.init(nibName: nil, bundle: nil)
        loadAd()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                self?.onAdDismissed()
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            self?.showAd()
        }
    }

    private func showAd() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
        } else {
            onAdDismissed()
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onAdDismissed()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present interstitial ad with error: \(error.localizedDescription)")
        onAdDismissed()
    }
}
