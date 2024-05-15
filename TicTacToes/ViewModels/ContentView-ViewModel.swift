//
//  ContentView-ViewModel.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation

enum Direction {
    case left
    case right
    case up
    case down
    case upRight
    case downLeft
    case upLeft
    case downRight
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var currentPlayer: Player = .o
        @Published var board: [[TileState]] = Constants.emptyBoard
        @Published var showingWinAlert = false
        @Published var gameState: GameState = .ongoing
        private var winningCoordinates = [(row: Int, col: Int)]()

        func newGameTapped() {
            board = Constants.emptyBoard
            gameState = .ongoing
            winningCoordinates = []
        }

        func tileTappedAt(row: Int, col: Int) {
            switch currentPlayer {
            case .x:
                board[row][col] = TileState.x(isWinningTile: false)
            case .o:
                board[row][col] = TileState.o(isWinningTile: false)
            }
            if didWinAt(row: row, col: col, goal: Constants.gridSize) {
                createWinningTiles()
                gameState = .done
                showingWinAlert = true
            } else {
                currentPlayer.toggle()
            }
        }

        private func didWinAt(row: Int, col: Int, goal: Int) -> Bool {
            return checkVertical(row: row, col: col, goal: goal) || checkHorizontal(row: row, col: col, goal: goal) ||
            checkDiagonal(row: row, col: col, goal: goal) || checkRevDiagonal(row: row, col: col, goal: goal) ||
            checkCorners() || checkSquare(row: row, col: col)
        }

        private func checkCorners() -> Bool {
            let lastIndex = Constants.gridSize - 1
            if currentPlayer.symbol == board[0][0].symbol &&
                currentPlayer.symbol == board[0][lastIndex].symbol &&
                currentPlayer.symbol == board[lastIndex][0].symbol &&
                currentPlayer.symbol == board[lastIndex][lastIndex].symbol {
                winningCoordinates = [(0, 0), (0, lastIndex), (lastIndex, 0), (lastIndex, lastIndex)]
                return true
            } else {
                return false
            }
        }

        private func checkSquare(row: Int, col: Int) -> Bool {
            var results = [Bool]()

            // Check above-right square if possible
            if row > 0 && col < Constants.gridSize - 1 {
                results.append(currentPlayer.symbol == board[row - 1][col].symbol &&
                               currentPlayer.symbol == board[row - 1][col + 1].symbol &&
                               currentPlayer.symbol == board[row][col + 1].symbol)
                if results.last == true {
                    winningCoordinates = [(row, col), (row - 1, col), (row - 1, col + 1), (row, col + 1)]
                }
            }
            // Check above-left square if possible
            if row > 0 && col > 0 {
                results.append(currentPlayer.symbol == board[row - 1][col - 1].symbol &&
                               currentPlayer.symbol == board[row - 1][col].symbol &&
                               currentPlayer.symbol == board[row][col - 1].symbol)
                if results.last == true {
                    winningCoordinates = [(row, col), (row - 1, col - 1), (row - 1, col), (row, col - 1)]
                }
            }
            // Check bottom-right square if possible
            if row < Constants.gridSize - 1 && col < Constants.gridSize - 1 {
                results.append(currentPlayer.symbol == board[row][col + 1].symbol &&
                               currentPlayer.symbol == board[row + 1][col].symbol &&
                               currentPlayer.symbol == board[row + 1][col + 1].symbol)
                if results.last == true {
                    winningCoordinates = [(row, col), (row, col + 1), (row + 1, col), (row + 1, col + 1)]
                }
            }
            // Check bottom-left square if possible
            if row < Constants.gridSize - 1 && col > 0 {
                results.append(currentPlayer.symbol == board[row][col - 1].symbol &&
                               currentPlayer.symbol == board[row + 1][col - 1].symbol &&
                               currentPlayer.symbol == board[row + 1][col].symbol)
                if results.last == true {
                    winningCoordinates = [(row, col), (row, col - 1), (row + 1, col - 1), (row + 1, col)]
                }
            }

            return results.reduce(false) { $0 || $1 }
        }

        private func checkHorizontal(row: Int, col: Int, goal: Int) -> Bool {
            let left = checkValue(row: row, col: col - 1, direction: .left)
            let right = checkValue(row: row, col: col + 1, direction: .right)

            if left + right + 1 >= goal {
                winningCoordinates.append((row, col))
                return true
            } else {
                winningCoordinates = []
                return false
            }
        }

        private func checkVertical(row: Int, col: Int, goal: Int) -> Bool {
            let up = checkValue(row: row - 1, col: col, direction: .up)
            let down = checkValue(row: row + 1, col: col, direction: .down)

            if up + down + 1 >= goal {
                winningCoordinates.append((row, col))
                return true
            } else {
                winningCoordinates = []
                return false
            }
        }

        private func checkDiagonal(row: Int, col: Int, goal: Int) -> Bool {
            let downRight = checkValue(row: row + 1, col: col + 1, direction: .downRight)
            let upLeft = checkValue(row: row - 1, col: col - 1, direction: .upLeft)

            if downRight + upLeft + 1 >= goal {
                winningCoordinates.append((row, col))
                return true
            } else {
                winningCoordinates = []
                return false
            }
        }

        private func checkRevDiagonal(row: Int, col: Int, goal: Int) -> Bool {
            let upRight = checkValue(row: row - 1, col: col + 1, direction: .upRight)
            let downLeft = checkValue(row: row + 1, col: col - 1, direction: .downLeft)

            if upRight + downLeft + 1 >= goal {
                winningCoordinates.append((row, col))
                return true
            } else {
                winningCoordinates = []
                return false
            }
        }

        private func checkValue(row: Int, col: Int, direction: Direction) -> Int {
            guard row >= 0,
                  row < Constants.gridSize,
                  col >= 0,
                  col < Constants.gridSize,
                  board[row][col].symbol == currentPlayer.symbol
            else { return 0 }

            winningCoordinates.append((row, col))

            switch direction {
            case .left:
                return checkValue(row: row, col: col - 1, direction: .left) + 1
            case .right:
                return checkValue(row: row, col: col + 1, direction: .right) + 1
            case .up:
                return checkValue(row: row - 1, col: col, direction: .up) + 1
            case .down:
                return checkValue(row: row + 1, col: col, direction: .down) + 1
            case .upRight:
                return checkValue(row: row - 1, col: col + 1, direction: .upRight) + 1
            case .downLeft:
                return checkValue(row: row + 1, col: col - 1, direction: .downLeft) + 1
            case .upLeft:
                return checkValue(row: row - 1, col: col - 1, direction: .upLeft) + 1
            case .downRight:
                return checkValue(row: row + 1, col: col + 1, direction: .downRight) + 1
            }
        }

        private func createWinningTiles() {
            winningCoordinates.forEach { coord in
                switch currentPlayer {
                case .x:
                    board[coord.row][coord.col] = TileState.x(isWinningTile: true)
                case .o:
                    board[coord.row][coord.col] = TileState.o(isWinningTile: true)
                }
            }
        }
    }
}
