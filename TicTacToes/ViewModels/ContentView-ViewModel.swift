//
//  ContentView-ViewModel.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import Foundation

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
            if didWinAt(row: row, col: col) {
                createWinningTiles()
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
                guard currentPlayer.symbol == board[row][x].symbol else { break }
                winningCoordinates.append((row, x))
                if x == target - 1 {
                    return true
                }
            }
            winningCoordinates = []

            // Check column
            for y in 0..<target {
                guard currentPlayer.symbol == board[y][col].symbol else { break }
                winningCoordinates.append((y, col))
                if y == target - 1 {
                    return true
                }
            }
            winningCoordinates = []

            // Check diagonal
            if row == col {
                for i in 0..<target {
                    guard currentPlayer.symbol == board[i][i].symbol else { break }
                    winningCoordinates.append((i, i))
                    if i == target - 1 {
                        return true
                    }
                }
            }
            winningCoordinates = []

            // Check reverse-diagonal
            if row + col == target - 1 {
                for i in 0..<target {
                    guard currentPlayer.symbol == board[i][target - 1 - i].symbol else { break }
                    winningCoordinates.append((i, target - 1 - i))
                    if i == target - 1 {
                        return true
                    }
                }
            }
            winningCoordinates = []

            return checkCorners() || checkSquare(row: row, col: col)
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
            if row > 0 && col < board[0].count - 1 {
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
            if row < board.count - 1 && col < board[0].count - 1 {
                results.append(currentPlayer.symbol == board[row][col + 1].symbol &&
                               currentPlayer.symbol == board[row + 1][col].symbol &&
                               currentPlayer.symbol == board[row + 1][col + 1].symbol)
                if results.last == true {
                    winningCoordinates = [(row, col), (row, col + 1), (row + 1, col), (row + 1, col + 1)]
                }
            }
            // Check bottom-left square if possible
            if row < board.count - 1 && col > 0 {
                results.append(currentPlayer.symbol == board[row][col - 1].symbol &&
                               currentPlayer.symbol == board[row + 1][col - 1].symbol &&
                               currentPlayer.symbol == board[row + 1][col].symbol)
                if results.last == true {
                    winningCoordinates = [(row, col), (row, col - 1), (row + 1, col - 1), (row + 1, col)]
                }
            }

            return results.reduce(false) { $0 || $1 }
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
