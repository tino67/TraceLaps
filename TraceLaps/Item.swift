//
//  Item.swift
//  TraceLaps
//
//  Created by Quentin Noblet on 29/07/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
