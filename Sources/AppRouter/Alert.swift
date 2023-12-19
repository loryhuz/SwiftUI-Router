//
//  File.swift
//  
//
//  Created by Lory Huz on 19/12/2023.
//

import Foundation
import SwiftUI

struct Alert: Identifiable {
    let id = UUID().uuidString
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    
    let buttons: AnyView

    init<T: View>(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, buttons: T) {
        self.title = title
        self.subtitle = subtitle
        self.buttons = AnyView(buttons)
    }
}

