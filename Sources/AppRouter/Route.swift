import SwiftUI

public protocol AppRoute: Identifiable, Hashable {
    associatedtype RouteView: View
    
    var content: RouteView { get }
}
