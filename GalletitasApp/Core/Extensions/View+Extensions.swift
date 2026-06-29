import SwiftUI

extension View {
    func embedInNavigation() -> some View {
        NavigationStack { self }
    }

    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack {
            if shouldShow { placeholder() }
            self
        }
    }
}
