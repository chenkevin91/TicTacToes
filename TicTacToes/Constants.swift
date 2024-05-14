//
//  Constants.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation
import SwiftUI

struct Constants {
    static let gridSize = 4
    static let tileLength = 60.0
    static let emptyBoard: [[TileState]] = Array(repeating: Array(repeating: TileState.empty, count: Constants.gridSize),
                                                 count: Constants.gridSize)
    static let backgroundColor = Color(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0)
}
