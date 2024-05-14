//
//  ContentView.swift
//  TicTacToes
//
//  Created by Kevin Chen on 5/14/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.gameState == .ongoing ? "Current Player:" : "Winner:")
                    .font(.title)
                Image(systemName: viewModel.currentPlayer.imageName)
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
                    .foregroundColor(.blue)
            }

            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(Array(viewModel.board.enumerated()), id: \.0) { rowIndex, row in
                    GridRow {
                        ForEach(Array(row.enumerated()), id: \.0) { colIndex, tile in
                            if tile == TileState.x.symbol {
                                Image(systemName: TileState.x.imageName)
                                    .resizable()
                                    .frame(width: 60.0, height: 60.0)
                                    .padding(16)
                                    .border(.black, width: 5)
                            } else if tile == TileState.o.symbol {
                                Image(systemName: TileState.o.imageName)
                                    .resizable()
                                    .frame(width: 60.0, height: 60.0)
                                    .padding(16)
                                    .border(.black, width: 5)
                            } else {
                                Button {
                                    if viewModel.gameState == .ongoing {
                                        viewModel.tileTappedAt(row: rowIndex, col: colIndex)
                                    }
                                } label: {
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 60.0, height: 60.0)
                                }
                                .padding(16)
                                .border(.black, width: 5)
                            }
                        }
                    }
                }
            }
            .border(.black, width: 10)
            .background(.white)

            Button {
                viewModel.newGameTapped()
            } label: {
                Text("NEW GAME")
                    .font(.headline)
                    .padding()
            }
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(6.0)
            .padding(20)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        .background(Color(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0))
        .alert(isPresented: $viewModel.showingWinAlert) {
            Alert(title: Text("Congratulations \(viewModel.currentPlayer.title)"),
                  message: Text("You won!"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}
