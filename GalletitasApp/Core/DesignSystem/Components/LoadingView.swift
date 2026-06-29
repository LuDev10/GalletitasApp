import SwiftUI

struct LoadingView: View {
    var message: String = "Cargando..."

    var body: some View {
        VStack(spacing: AppTheme.padding) {
            ProgressView()
                .scaleEffect(1.2)
            Text(message)
                .foregroundColor(AppTheme.textSecondary)
        }
    }
}

#Preview {
    LoadingView()
}
