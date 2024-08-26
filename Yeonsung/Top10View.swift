import SwiftUI
import FirebaseFirestore

struct Top10View: View {
    @State private var topMenuItems: [String] = Array(repeating: "Loading...", count: 10) // Start with placeholder texts
    @State private var isLoading = false // State variable to track loading
    private let db = Firestore.firestore()
    
    @State private var listener: ListenerRegistration?
    
    var body: some View {
        ZStack {
            // Background color that covers the entire screen
            Color(hex: "#ADD8E6")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Top 10")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        startLoadingAndPerformAction() // Start loading and perform the action
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title) // Adjust the size as needed
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    ForEach(0..<10, id: \.self) { index in
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "#F5F5DC"))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: "#9E9E9E"), lineWidth: 2)
                                    )
                                
                                // Change text color based on index
                                Text("\(index + 1)")
                                    .font(Font.custom("Jalnan2TTF", size: 25, relativeTo: .title))
                                    .fontWeight(.bold)
                                    .foregroundColor(index == 0 ? Color(hex: "#FFD700") : Color(hex: "#595959"))
                            }
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "#F5F5DC"))
                                .frame(height: 50)
                                .overlay(
                                    Text(topMenuItems[index])
                                        .font(.title3)
                                        .foregroundColor(Color(hex: "#323232"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 10)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                
                Spacer()
                VStack{
                    AdBannerViewController(adUnitID: "")
                        .frame(width: 70, height: 70)
                }
            }
            .padding()
            
            // Show custom loading indicator if isLoading is true
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                CustomLoadingView()
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: addRealtimeListener) // Use realtime listener
        .onDisappear(perform: removeRealtimeListener)
    }
    
    // Function to start loading and then replace the view after a delay
    func startLoadingAndPerformAction() {
        isLoading = true // Show the loading indicator
        
        // Simulate a delay (for example, fetching data or performing a time-consuming task)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Perform the action after the delay
            self.isLoading = false // Hide the loading indicator
            replaceWithMainSelectView() // Replace with MainSelectView after the delay
        }
    }
    
    // Function to add a Firestore realtime listener
    func addRealtimeListener() {
        listener = db.collection("votes").document("dailyMenu").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, document.exists, let items = document.get("items") as? [String: [String: Any]] else {
                print("Document does not exist or failed to fetch data")
                return
            }
            
            // Filter out items with voteCount == 0
            let filteredItems = items.filter {
                let voteCount = $0.value["voteCount"] as? Int ?? 0
                return voteCount > 0
            }
            
            // Sort the filtered items by voteCount, and then by their keys (to preserve original order if voteCount is the same)
            let sortedItems = filteredItems.sorted {
                let voteCount1 = $0.value["voteCount"] as? Int ?? 0
                let voteCount2 = $1.value["voteCount"] as? Int ?? 0
                if voteCount1 == voteCount2 {
                    return $0.key < $1.key
                }
                return voteCount1 > voteCount2
            }
            
            // Extract the top items (up to 10)
            var topItems = sortedItems.prefix(10).map { $0.value["itemName"] as? String ?? "Unknown" }
            
            // Fill in any remaining slots with "No Item"
            if topItems.count < 10 {
                topItems.append(contentsOf: Array(repeating: "", count: 10 - topItems.count))
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.topMenuItems = topItems
            }
        }
    }
    
    func replaceWithMainSelectView() {
        let mainSelectView = MainSelectView()
        let mainSelectHostingController = UIHostingController(rootView: mainSelectView)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = mainSelectHostingController
            window.makeKeyAndVisible()
        }
    }
    
    func removeRealtimeListener() {
         listener?.remove()
     }
}

#Preview {
    Top10View()
}
