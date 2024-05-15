The TicTacToes app is a simple game of tic tac toe played on a 4x4 grid.
A player wins when they can connect 4 of their symbols in a row, column, or diagonal.
A player can also win by claiming the 4 corners or claiming a 2x2 square on the board.

The app displays a single screen with the current player, a 4x4 board, and a NEW GAME button.
Whenever a tile on the board is tapped, the current player's symbol is drawn on that tile
and the turn goes to the other player. Once a win condition is satisified, the winning symbols
turn green and an alert is prompted congratulating the winner. The NEW GAME button can 
be tapped to reset the board at any time. 

The app is written using SwiftUI to draw the interface. The board dimensions can be configured 
by changing the `Constants.gridSize` value found in the `Constants.swift`. However, to support 
larger boards, the tile sizes in `ContentView.swift` will also have to be changed so changing 
the game board is not fully functional.

Most of the logic exists in the `ContentView-ViewModel.swift` file. When a tile is tapped,
the viewModel's `tileTappedAt` function is called which updates the game board and checks 
if the most recent tile update satisfies any of the win conditions by calling the `didWinAt` 
function. With `didWinAt`, the goal of 4 in a row/column/diagonal is set by the `Constants.gridSize` 
value but it can be changed here if desired. So for instance, the app can be changed to check 
for 4 in a row on a 5x5 board or 6 in a row on 6x6 board. 

The `didWinAt` function calls `checkCorners`, `checkSquare`, `checkVertical`, `checkHorizontal`,
`checkDiagonal`, and `checkRevDiagonal`. The `checkCorners` and `checkSquare` functions check for the
4 corners and the 2x2 square win conditions respectively.

The `checkVertical`, `checkHorizontal`, `checkDiagonal`, and `checkRevDiagonal` functions are 
all written similarly so let's look at `checkVertical` to understand how they all work.
`checkVertical` calls `checkValue` twice, once by passing the tile coordinate above the tapped tile 
coordinate with the `Direction.up` enum and again with the tile coordinate below the tapped tile 
coordinate with the `Direction.down` enum. Using these passed in variables, `checkValue` recursively 
calls itself in the direction that it is given until it reaches a tile that doesn't match the symbol 
of the current user or if it goes out of bounds of the game board. Once the recursion reaches its base
case, it breaks out and returns a 0. In `checkVertical`'s case, this recursion results in an integer value 
representing all the times the current player's symbol appears consecutively above and below the tapped
tile coordinate. If this interger value is >= the goal, `checkVertical` returns true resulting in the
current player winning the game.
