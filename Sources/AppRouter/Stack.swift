import SwiftUI

public extension AppRouter {
    struct Stack<Root>: View where Root : View {
        @Environment(\.dismiss)
        var dismiss

        @ViewBuilder
        public var root: Root
        
        var parentRouter: AppRouter.StackController?
        
        public init(
            @ViewBuilder root: () -> Root,
            parentRouter: AppRouter.StackController? = nil
        ) {
            self.root = root()
            self.parentRouter = parentRouter
        }
        
        public var body: some View {
            AppRouter.DismissableStackWrapper(
                dismiss: self.dismiss, parentRouter: parentRouter
            ) {
                self.root
            }
        }
    }
}
