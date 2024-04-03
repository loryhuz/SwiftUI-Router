import Combine
import SwiftUI

public extension AppRouter {
    
    struct SheetRoute: Identifiable {
        public var id: Route {
            self.route
        }
        
        let route: Route
        let presentation: Set<PresentationDetent>
        let background: AnyShapeStyle?
        
        public init(
            route: Route,
            presentation: Set<PresentationDetent>,
            background: AnyShapeStyle? = nil
        ) {
            self.route = route
            self.presentation = presentation
            self.background = background
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
        var parentRouter: AppRouter.StackController?
        
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
        
        var dismissStack: DismissAction
        
        public init(
            path: [Route] = [],
            parentRouter: AppRouter.StackController?,
            dismiss: DismissAction
        ) {
            self.path = path
            self.parentRouter = parentRouter
            self.dismissStack = dismiss
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
        public func present(route: Route, with presentation: Set<PresentationDetent>, background: AnyShapeStyle? = nil) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            
            self.sheetRoute = .init(
                route: route,
                presentation: presentation,
                background: background
            )
        }
        
        public func presentFullScreenCover(route: Route) {
            self.fullScreenCoverRoute = route
        }
        
        public func dismiss() {
            self.dismissStack()
        }
        
        public func dismissSheet() {
            if let parentRouter = parentRouter {
                parentRouter.dismissSheet()
            } else {
                self.sheetRoute = nil
            }
            
        }
        
        public func dismissFullScreenCover() {
            if let parentRouter = parentRouter {
                parentRouter.dismissFullScreenCover()
            } else {
                self.fullScreenCoverRoute = nil
            }
        }
    }
}


extension AppRouter.StackController {
    
    @MainActor
    public func presentAlert<T: View>(title: LocalizedStringKey,
                                      subtitle: LocalizedStringKey? = nil,
                                      @ViewBuilder buttons: @escaping () -> T) where T: View {
        DispatchQueue.main.async {
            self.alert = Alert(
                title: title,
                subtitle: subtitle,
                buttons: buttons())
        }
        
    }
    
}

