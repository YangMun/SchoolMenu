
import SwiftUI

struct TeacherMenuView: View {
    
    let CategorytArray = teacherFetchTableCategory()
    let TableMenu = teacherMenuInformation()
    
    var body: some View {
        VStack {
            HStack {
                Text(currentDateFormatted())
                    .font(.custom("Helvetica Neue", size: 18))
                    .padding(.leading) // 원하는 글꼴과 크기로 변경
            }

            TabView {
                ForEach(0..<CategorytArray.count, id: \.self) { index in
                    VStack {
                        Text(CategorytArray[index])
                            .font(.title)
                        Form {
                            List {
                                ForEach(TableMenu[index], id: \.self) { menuItem in
                                    HStack {
                                        Text(menuItem)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 페이지 스타일로 변경
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // 페이지 인덱스 스타일 설정
        }
        AdBannerViewController(adUnitID: "")
            .frame(width: 50, height: 50)
    }
}

#Preview {
    TeacherMenuView()
}
