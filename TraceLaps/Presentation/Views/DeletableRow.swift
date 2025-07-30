//
//  DeletableRow.swift
//  TraceLaps
//
//  Created by Jules on 30/07/2025.
//

import SwiftUI

struct DeletableRow<Content: View>: View {
    @ViewBuilder var content: Content
    var onDelete: () -> Void

    @State private var isDeleted = false

    var body: some View {
        content
            .swipeActions {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .offset(x: isDeleted ? -UIScreen.main.bounds.width : 0)
            .animation(.easeInOut, value: isDeleted)
    }
}
