import SwiftUI

struct GradientCard<Content: View>: View {
    let content: Content
    var colors: [Color] = [Color.pink, Color.purple]

    init(colors: [Color] = [Color.pink, Color.purple], @ViewBuilder content: () -> Content) {
        self.colors = colors
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.9)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
