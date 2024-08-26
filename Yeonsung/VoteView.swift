import SwiftUI
import FirebaseFirestore

struct VoteView: View {
    let TableMenu = menuVote()
    @State private var selectedMenuItem: String? = nil // Track the selected menu item
    @State private var navigateToTop10 = false // State to control navigation
    @Binding var showVotingView: Bool // Binding to control the visibility of VoteView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("오늘의 맛도리는?")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(Color(hex: "#323232"))
                
                Spacer()
                
                Button(action: {
                    showVotingView = false // Close the VoteView when X button is pressed
                }) {
                    Image(systemName: "xmark") // X button
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.leading)
                }
            }
            .padding(.bottom, 25)
            
            ScrollView {
                ForEach(0..<TableMenu.count, id: \.self) { index in
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(TableMenu[index], id: \.self) { menuItem in
                            Button(action: {
                                selectedMenuItem = menuItem
                            }) {
                                Text(menuItem)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(selectedMenuItem == menuItem ? .white : Color(hex: "#323232"))
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .background(selectedMenuItem == menuItem ? Color(hex: "#FF6347") : Color(hex: "F5F5DC")) // Change color when selected
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 4, y: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            
            Button(action: {
                if let selectedItem = selectedMenuItem {
                    incrementVoteCount(for: selectedItem)
                }
            }) {
                Text("결과 보기 →")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "#323232"))
                    .frame(width: 120, height: 40)
                    .background(Color(hex: "F5F5DC"))
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 4, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(.top, 50)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(selectedMenuItem == nil) // Disable button if no menu is selected
            
            // NavigationLink to Top10View
            NavigationLink(destination: Top10View(), isActive: $navigateToTop10) {
                EmptyView()
            }
        }
        .padding(20)
        .background(Color(hex: "ADD8E6"))
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.6), radius: 4, x: 4, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 3)
        )
        .padding()
    }
    
    // Function to increment vote count in Firestore
    func incrementVoteCount(for menuItem: String) {
        let docRef = db.collection("votes").document("dailyMenu")
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if var items = document.get("items") as? [String: [String: Any]] {
                    for (key, value) in items {
                        if let name = value["itemName"] as? String, name == menuItem {
                            var count = value["voteCount"] as? Int ?? 0
                            count += 1
                            items[key]?["voteCount"] = count
                        }
                    }
                    
                    docRef.updateData(["items": items]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            saveVotingDate() // Save the voting date
                            navigateToTop10 = true // Trigger navigation
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    func saveVotingDate() {
        let today = getTodayDateString()
        UserDefaults.standard.set(today, forKey: "lastVoteDate")
    }

}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    VoteView(showVotingView: .constant(true))
}
