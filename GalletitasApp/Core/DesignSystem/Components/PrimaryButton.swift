import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading = false
    var isDisabled = false

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : AppTheme.accent)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    PrimaryButton(title: "Iniciar sesión", action: {})
}
