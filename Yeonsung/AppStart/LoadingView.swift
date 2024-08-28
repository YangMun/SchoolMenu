import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var logoRotation: Double = 0
    @State private var textOpacity: Double = 0
    
    let yeongsungBlue = Color(red: 0/255, green: 85/255, blue: 164/255)
    let yeongsungLightBlue = Color(red: 233/255, green: 240/255, blue: 250/255)
    
    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(gradient: Gradient(colors: [yeongsungLightBlue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // 로고와 대학 이름
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(yeongsungBlue.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(yeongsungBlue.opacity(0.3), lineWidth: 8)
                            .frame(width: 140, height: 140)
                        
                        Image(systemName: "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(yeongsungBlue)
                    }
                    
                    Text("연성대학교")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(yeongsungBlue)
                }
                .opacity(textOpacity)
                
                // 학생식당 텍스트
                Text("학생식당")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(
                        Capsule()
                            .fill(yeongsungBlue)
                            .shadow(color: yeongsungBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                    .opacity(textOpacity)
                
                // 로딩 인디케이터
                HStack(spacing: 20) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(yeongsungBlue)
                            .frame(width: 15, height: 15)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.5)) {
                textOpacity = 1
            }
            isAnimating = true
        }
    }
}
#Preview {
    LoadingView()
}
