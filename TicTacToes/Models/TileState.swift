//
//  TileState.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation

enum TileState {
    case x
    case o
    case empty

    var symbol: Character {
        switch self {
        case .x:
            return "x"
        case .o:
            return "o"
        case .empty:
            return "."
        }
    }

    var imageName: String {
        switch self {
        case .x:
            return "xmark"
        case .o:
            return "circle"
        case .empty:
            return ""
        }
    }
}
