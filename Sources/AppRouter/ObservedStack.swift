import SwiftUI

public extension AppRouter {
    struct ObservedStack<Root> : View where Root : View {
        @ObservedObject var stack: AppRouter.StackController
        
        @ViewBuilder
        var root: Root
        
        public var body: some View {
            NavigationStack(
                path: self.$stack.path
            ) {
                self.root
                    .navigationDestination(
                        for: Route.self
                    ) {
                        $0.content
                            .frame(maxHeight: .infinity)
                            .navigationTitle("")
                    }
                    .frame(maxHeight: .infinity)
                    .navigationTitle("")
            }
            .environmentObject(self.stack)
            .sheet(item: self.$stack.sheetRoute) { sheetRoute in
                AppRouter.Stack {
                    sheetRoute.route.content
                }
                .presentationDetents(sheetRoute.presentation)
                .presentationDragIndicator(.visible)
            }
#if os(iOS)
            .fullScreenCover(
                item: self.$stack.fullScreenCoverRoute
            ) { coverRoute in
                AppRouter.Stack {
                    coverRoute.content
                }
            }
#endif
        }
    }
}
