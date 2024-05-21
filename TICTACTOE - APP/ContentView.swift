import SwiftUI

enum Player {
    case player1
    case player2
}

enum CellState {
    case empty
    case byPlayer1
    case byPlayer2
}

struct ContentView: View {
    @State private var showPlay = false
    @State private var isAnimated: Bool = false
    @State private var gameStatus: String = "Player 1's turn"
    @State private var gameEnded: Bool = false // Added game end flag
    
    // Array for the grid
    @State private var grid: [[CellState]] = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
    
    @State private var currentTurn: Player = .player1
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Image("player1")
                        .resizable()
                        .frame(width: isAnimated ? 70 : 100, height: isAnimated ? 70 : 100)
                        .saturation(isAnimated ? 0 : 1)
                        .padding(.top, 100)
                    
                    Text("Player 1")
                        .padding(.top, -10)
                }
                
                Spacer()
                
                Text("VS")
                    .font(.title)
                    .padding(.top, 100)
                
                Spacer()
                
                VStack {
                    Image("player2")
                        .resizable()
                        .frame(width: isAnimated ? 100 : 70, height: isAnimated ? 100 : 70)
                        .saturation(isAnimated ? 1 : 0)
                        .padding(.top, 100)
                    Text("Player 2")
                        .padding(.top, -10)
                }
            }
            .padding(.horizontal)
            
            // Announcement area
            HStack {
                Text(gameStatus)
                    .padding(50)
            }
            
            VStack(spacing: 0) {
                ForEach(0..<3) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3) { column in
                            Button(action: {
                                onClick(row: row, column: column)
                            }, label: {
                                ZStack {
                                    ButtonLabel()
                                    if grid[row][column] == .byPlayer1 {
                                        Image("X")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                    } else if grid[row][column] == .byPlayer2 {
                                        Image("O")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                    }
                                }
                            })
                            .overlay(
                                Rectangle()
                                    .frame(width: 2) // Right border thickness
                                    .foregroundColor(.black),
                                alignment: .trailing
                            )
                        }
                    }
                }
            }
            
            Button(action: {
                reset()
            }, label: {
                Image("reset")
            })
            .padding(.top, 50)
        }
    }
    
    func ButtonLabel() -> some View {
        Text("")
            .frame(width: 110, height: 110)
            .background(Color.white)
            .border(Color.black)
    }
    
    func onClick(row: Int, column: Int) {
        // Check if the game has ended
        guard !gameEnded else {
            return
        }
        
        // Check if the cell is already occupied
        guard grid[row][column] == .empty else {
            return
        }
        
        if currentTurn == .player1 {
            grid[row][column] = .byPlayer1
            if checkWin(for: .byPlayer1) {
                gameStatus = "Player 1 wins!"
                gameEnded = true // Set game end flag
                return
            }
            currentTurn = .player2
            gameStatus = "Player 2's turn"
        } else {
            grid[row][column] = .byPlayer2
            if checkWin(for: .byPlayer2) {
                gameStatus = "Player 2 wins!"
                gameEnded = true // Set game end flag
                return
            }
            currentTurn = .player1
            gameStatus = "Player 1's turn"
        }
        
        // Check for a draw
        if isDraw() {
            gameStatus = "It's a draw!"
            gameEnded = true // Set game end flag
        }
        
        // Toggle animation only when a valid move is made
        withAnimation(.default) {
            isAnimated.toggle()
        }
    }
    
    func reset() {
        grid = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
        currentTurn = .player1
        isAnimated = false
        gameStatus = "Player 1's turn"
        gameEnded = false // Reset game end flag
    }
    
    func checkWin(for player: CellState) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if (grid[i][0] == player && grid[i][1] == player && grid[i][2] == player) ||
               (grid[0][i] == player && grid[1][i] == player && grid[2][i] == player) {
                return true
            }
        }
        // Check diagonals
        if (grid[0][0] == player && grid[1][1] == player && grid[2][2] == player) ||
           (grid[0][2] == player && grid[1][1] == player && grid[2][0] == player) {
            return true
        }
        return false
    }
    
    func isDraw() -> Bool {
        for row in grid {
            if row.contains(.empty) {
                return false
            }
        }
        return true
    }
}

#Preview {
    ContentView()
}
