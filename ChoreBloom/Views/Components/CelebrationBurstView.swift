import SwiftUI

struct CelebrationBurstView: View {
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            ForEach(0..<16, id: \.self) { index in
                Circle()
                    .fill([Color.pink, .yellow, .mint, .blue, .purple][index % 5])
                    .frame(width: 10, height: 10)
                    .offset(y: isShowing ? -120 : 0)
                    .rotationEffect(.degrees(Double(index) * 22.5))
                    .opacity(isShowing ? 0 : 1)
                    .animation(.easeOut(duration: 0.75).delay(Double(index) * 0.01), value: isShowing)
            }
        }
        .allowsHitTesting(false)
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                    isShowing = false
                }
            }
        }
    }
}
