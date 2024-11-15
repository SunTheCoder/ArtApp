//
//  ChatMessage.swift
//  LCVAPortal
//
//  Created by Sun English on 11/14/24.
//

import FirebaseCore

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var timestamp: Timestamp
    var artPieceID: Int
}
