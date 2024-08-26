import SwiftUI
import GoogleMobileAds
struct MainSelectView: View {
    
    @State private var showInfoOverlay = false
    @State private var showInfoButton = true
    
    @State private var isNavigatingToTop10View = false // 광고 후 Top10View로 네비게이션
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("backImg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(maxWidth: 300, maxHeight: 450)
                        .cornerRadius(10)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 100)
                        .shadow(radius: 10)
                        .overlay(
                            VStack(spacing: 20) {
                                Text("연성대학교\n  식당메뉴")
                                    .font(Font.custom("Jalnan2TTF", size: 40, relativeTo: .largeTitle))
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 40)
                                    .padding(.top, 100)
                                    .shadow(radius: 10.0, x: 20, y: 10)
                                
                                VStack {
                                    Spacer()
                                    NavigationLink(destination: ContentView()) {
                                        Text("⚪️     푸드코트   ⚪️")
                                            .font(Font.custom("Jalnan2TTF", size: 20, relativeTo: .largeTitle))
                                            .padding()
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                            .frame(maxWidth: 300)
                                    }
                                    Spacer()
                                    NavigationLink(destination: TeacherMenuView()) {
                                        Text("⚪️  교직원 식당  ⚪️")
                                            .font(Font.custom("Jalnan2TTF", size: 20, relativeTo: .largeTitle))
                                            .padding()
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                    }
                                    Spacer()
                                    Button(action: {
                                        presentAdAndNavigateToTop10View()
                                    }) {
                                        Text("⚪️  맛도리 랭킹  ⚪️")
                                            .font(Font.custom("Jalnan2TTF", size: 20, relativeTo: .largeTitle))
                                            .padding()
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                    }
                                    .background(
                                        NavigationLink(
                                            destination: Top10View(),
                                            isActive: $isNavigatingToTop10View,
                                            label: { EmptyView() }
                                        )
                                    )

                                }
                            }
                            .padding(.vertical)
                        )
                    
                    Spacer()
                }
            }
        }
    }
    
    func presentAdAndNavigateToTop10View() {
        let adUnitID = "" // AdMob 전면 광고 ID
        let top10View = Top10View()
        let homePageViewHostingController = UIHostingController(rootView: top10View)

        let adViewController = InterstitialAdViewController(adUnitID: adUnitID) {
            // 전면 광고가 닫히면 홈 페이지로 이동
            UIApplication.shared.windows.first?.rootViewController = homePageViewHostingController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }

        UIApplication.shared.windows.first?.rootViewController?.present(adViewController, animated: true, completion: nil)
    }
}

#Preview {
    MainSelectView()
}
