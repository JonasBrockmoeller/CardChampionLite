//
//  ConnectionManager.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 19.04.22.
//

import Foundation

protocol ConnectionManager{}

struct GameInformation: Codable, Equatable{
    var card: Card
    var button: String
    var deckCount: Int
    var result: String?
}
