import SwiftUI

struct AppStartView: View {
    @State private var isReady = false

    var body: some View {
        Group {
            if isReady {
                MainSelectView()
                    .onAppear {
                        runUpdateIfNeeded()
                    }
            } else {
                LoadingView()
            }
        }
        .onAppear {
            initializeApp()
        }
    }

    private func initializeApp() {
        // Perform any setup or initialization tasks here
        // Example: Data loading, API calls, etc.
        
        // Simulate an initialization task (Replace this with actual code)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Once initialization is done, set isReady to true
            isReady = true
        }
    }
}

#Preview {
    AppStartView()
}
