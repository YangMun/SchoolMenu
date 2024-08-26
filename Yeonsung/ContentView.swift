import SwiftUI

struct ContentView: View {
    
    @State private var showVotingView = false
    @State private var isLoading = false // State variable to track loading
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // For controlling view dismissal
    @Environment(\.colorScheme) var colorScheme
    
    let CategorytArray = fetchTableCategory()
    let TableMenu = menuInformation()
    
    var body: some View {
        ZStack { // 전체 레이아웃을 ZStack으로 감싸기
            VStack {
                ZStack {
                    // 중앙에 날짜 텍스트를 위치시킵니다.
                    Text(currentDateFormatted())
                        .font(.custom("Helvetica Neue", size: 18))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // 왼쪽 상단에 "뒤로" 버튼을 추가합니다.
                    HStack {
                        if UIDevice.current.userInterfaceIdiom != .pad { // iPad가 아닌 경우에만 버튼 표시
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                            }) {
                                Image(systemName: "chevron.left") // Use system image for back arrow
                                    .font(.title)
                                    .padding(.leading)
                                    .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            startLoadingAndPerformAction() // Start loading and perform the action
                        }) {
                            Text("투표")
                                .font(.custom("Helvetica Neue", size: 18))
                                .padding()
                                .frame(height: 40)
                                .background(canVoteToday() ? Color.blue : Color.gray.opacity(0.4))
                                .foregroundColor(canVoteToday() ? Color.white : Color.gray)
                                .cornerRadius(10)
                                .padding(.trailing)
                        }
                        .disabled(!canVoteToday()) // Disable if the user has already voted today

                    }
                }
                
                TabView {
                    ForEach(0..<CategorytArray.count, id: \.self) { index in
                        VStack {
                            Text(CategorytArray[index])
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
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                VStack{
                    AdBannerViewController(adUnitID: "")
                        .frame(width: 50, height: 50)
                }
            }
            
            // 투표 뷰
            if showVotingView {
                Color.black.opacity(0.6) // 반투명 검은색 배경
                    .ignoresSafeArea()
                    .onTapGesture {
                        showVotingView = false // 배경을 탭하면 VoteView를 닫음
                    }

                VoteView(showVotingView: $showVotingView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            // Show custom loading indicator if isLoading is true
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                CustomLoadingView()
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
    
    func startLoadingAndPerformAction() {
        isLoading = true // Show the loading indicator
        
        // Simulate a delay (for example, fetching data or performing a time-consuming task)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Perform the action after the delay
            self.isLoading = false // Hide the loading indicator
            self.showVotingView = true // Show the voting view
        }
    }

    // Check if the user can vote today
    func canVoteToday() -> Bool {
        let today = getTodayDateString()
        if let lastVoteDate = UserDefaults.standard.string(forKey: "lastVoteDate") {
            return lastVoteDate != today
        }
        return true
    }
}

#Preview {
    ContentView()
}
