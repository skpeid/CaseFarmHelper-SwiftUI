//
//  ModalSheetHeader.swift
//  CaseFarmHelper-SwiftUI
//
//  Created by Kuanysh Auyelgazy on 11.09.2025.
//

import SwiftUI

struct ModalSheetHeaderView: View {
    let title: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "multiply")
                    .font(.system(size: 24))
            }
        }
    }
}
