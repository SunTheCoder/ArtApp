//
//  MessageView.swift
//  LCVAPortal
//
//  Created by Sun English on 11/15/24.
//

import SwiftUI
import FirebaseFirestore

struct MessageView: View {
    let message: Message
    let isAdmin: Bool
    let dateFormatter: DateFormatter
    let deleteAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // Display the username
                        Text(message.username ?? "Anonymous")
                            .font(.subheadline)
                            .foregroundColor(.blue)
            
            HStack {
                Text(message.text)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Delete button, visible only if user is admin
                if isAdmin {
                    Button(action: deleteAction) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(4)
                    }
                }
            }

            // Display formatted timestamp
            Text(dateFormatter.string(from: message.timestamp.dateValue()))
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 8)
        }
    }
}
