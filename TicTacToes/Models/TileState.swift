//
//  TileState.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation
import SwiftUI

enum TileState {
    case x(isWinningTile: Bool)
    case o(isWinningTile: Bool)
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

    var color: Color {
        switch self {
        case let .x(isWinningTile), let .o(isWinningTile):
            return isWinningTile ? .green : .black
        case .empty:
            return .black
        }
    }
}
