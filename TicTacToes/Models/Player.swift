//
//  Player.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation

enum Player {
    case x
    case o

    mutating func toggle() {
        switch self {
        case .x:
            self = .o
        case .o:
            self = .x
        }
    }

    var symbol: Character {
        switch self {
        case .x:
            return "x"
        case .o:
            return "o"
        }
    }

    var title: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        }
    }

    var imageName: String {
        switch self {
        case .x:
            return "xmark"
        case .o:
            return "circle"
        }
    }
}
