import Combine
import SwiftUI

public extension AppRouter {
    
    struct SheetRoute: Identifiable {
        public var id: Route {
            self.route
        }
        
        let route: Route
        let presentation: Set<PresentationDetent>
        
        public init(
            route: Route,
            presentation: Set<PresentationDetent>
        ) {
            self.route = route
            self.presentation = presentation
        }
    }
    
    struct AlertRoute: Identifiable {
        public var id: Route {
            self.route
        }
        
        let route: Route
        let title: LocalizedStringKey?
        let message: LocalizedStringKey?
        let buttons: AnyView?
        
        public init(
            route: Route,
            title: LocalizedStringKey?,
            message: LocalizedStringKey? = nil,
            buttons: AnyView? = nil
        ) {
            self.route = route
            self.title = title
            self.message = message
            self.buttons = buttons
        }
    }
}

public extension AppRouter {
    
    class StackController: ObservableObject {
        @Published
        var path: [Route]
        
        var currentRoute: Route? {
            self.path.last
        }
        
        @Published
        var sheetRoute: SheetRoute?
        
        @Published
        var fullScreenCoverRoute: Route?
        
        @Published
        var alert: Alert? {
            didSet {
                isPresentingAlert = alert != nil
            }
        }
        
        @Published
        var isPresentingAlert: Bool = false
        
        public init(path: [Route] = []) {
            self.path = path
        }
        
        public func goBack(_ count: Int = 1) {
            guard canGoBack() else { return }

            self.path.removeLast(count)
        }
        
        public func reset() {
            self.path = .init()
        }
        
        public func canGoBack() -> Bool {
            self.path.isEmpty == false
        }
        
        @MainActor
        public func push(route: Route) {
            self.path.append(route)
        }
        
        @MainActor
        public func push(routes: [Route]) {
            self.path.append(contentsOf: routes)
        }
        
        @MainActor
        public func present(route: Route, with presentation: Set<PresentationDetent>) {
            self.sheetRoute = .init(
                route: route,
                presentation: presentation
            )
        }
        
        public func presentFullScreenCover(route: Route) {
            self.fullScreenCoverRoute = route
        }
        
        public func presentAlert<T: View>(title: LocalizedStringKey,
                subtitle: LocalizedStringKey? = nil,
                @ViewBuilder buttons: @escaping () -> T) where T: View {
            self.alert = Alert(
                title: title,
                subtitle: subtitle,
                buttons: buttons())
        }
    }
}

