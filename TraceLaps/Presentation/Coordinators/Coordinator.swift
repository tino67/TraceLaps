//
//  Coordinator.swift
//  TraceLaps
//
//  Created by Jules on 29/07/2025.
//

import Foundation
import SwiftUI

@MainActor
protocol Coordinator {
    func start() -> AnyView
}
