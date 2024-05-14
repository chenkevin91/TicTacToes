//
//  ContentView-ViewModel.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation

struct Constants {
    static let gridSize = 4
    static let emptyBoard: [[Character]] = Array(repeating: Array(repeating: TileState.empty.symbol, count: Constants.gridSize),
                                                 count: Constants.gridSize)
}

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

enum GameState {
    case done
    case ongoing
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var currentPlayer: Player = .o
        @Published var board: [[Character]] = Constants.emptyBoard
        @Published var showingWinAlert = false
        @Published var gameState: GameState = .ongoing

        func newGameTapped() {
            board = Constants.emptyBoard
            gameState = .ongoing
        }

        func tileTappedAt(row: Int, col: Int) {
            switch currentPlayer {
            case .x:
                board[row][col] = TileState.x.symbol
            case .o:
                board[row][col] = TileState.o.symbol
            }
            if didWinAt(row: row, col: col) {
                gameState = .done
                showingWinAlert = true
            } else {
                currentPlayer.toggle()
            }

        }

        private func didWinAt(row: Int, col: Int) -> Bool {
            let target = Constants.gridSize

            // Check row
            for x in 0..<target {
                guard currentPlayer.symbol == board[row][x] else { break }
                if x == target - 1 {
                    return true
                }
            }

            // Check column
            for y in 0..<target {
                guard currentPlayer.symbol == board[y][col] else { break }
                if y == target - 1 {
                    return true
                }
            }

            // Check diagonal
            if row == col {
                for i in 0..<target {
                    guard currentPlayer.symbol == board[i][i] else { break }
                    if i == target - 1 {
                        return true
                    }
                }
            }

            // Check reverse-diagonal
            if row + col == target - 1 {
                for i in 0..<target {
                    guard currentPlayer.symbol == board[i][target - 1 - i] else { break }
                    if i == target - 1 {
                        return true
                    }
                }
            }

            return checkCorners() || checkSquare(row: row, col: col)
        }

        private func checkCorners() -> Bool {
            let lastIndex = Constants.gridSize - 1
            return currentPlayer.symbol == board[0][0] && currentPlayer.symbol == board[0][lastIndex] &&
            currentPlayer.symbol == board[lastIndex][0] && currentPlayer.symbol == board[lastIndex][lastIndex]
        }

        private func checkSquare(row: Int, col: Int) -> Bool {
            var results = [Bool]()

            // Check above-right square if possible
            if row > 0 && col < board[0].count - 1 {
                results.append(currentPlayer.symbol == board[row - 1][col] &&
                               currentPlayer.symbol == board[row - 1][col + 1] &&
                               currentPlayer.symbol == board[row][col + 1])
            }
            // Check above-left square if possible
            if row > 0 && col > 0 {
                results.append(currentPlayer.symbol == board[row - 1][col - 1] &&
                               currentPlayer.symbol == board[row - 1][col] &&
                               currentPlayer.symbol == board[row][col - 1])

            }
            // Check bottom-right square if possible
            if row < board.count - 1 && col < board[0].count - 1 {
                results.append(currentPlayer.symbol == board[row][col + 1] &&
                               currentPlayer.symbol == board[row + 1][col] &&
                               currentPlayer.symbol == board[row + 1][col + 1])
            }
            // Check bottom-left square if possible
            if row < board.count - 1 && col > 0 {
                results.append(currentPlayer.symbol == board[row][col - 1] &&
                               currentPlayer.symbol == board[row + 1][col - 1] &&
                               currentPlayer.symbol == board[row + 1][col])
            }

            return results.reduce(false) { $0 || $1 }
        }
    }
}
