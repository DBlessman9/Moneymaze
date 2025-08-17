//
//  GameViewController.swift
//  Money-manGame
//
//  Created by Joseph Allen Blessman on 1/28/25.
//
import SwiftUI
import GameplayKit

// Identify the positions

struct spaces: Identifiable, Hashable{
    var num : Int
    var id = UUID()
}

struct portal: View, Identifiable, Hashable{
    var id = UUID()
    var body: some View {
        Rectangle().frame(width: 20 , height: 20).foregroundStyle(.clear)
    }
}
struct boost: View, Identifiable, Hashable{
    var id = UUID()
    var body: some View{
        Image("boost")
            .resizable()
            .frame(width: 16, height: 16).foregroundStyle(.purple)
    }
}
struct wall: View, Identifiable, Hashable{
    var id = UUID()
    var body: some View {
        Rectangle().frame(width: 21, height: 21).foregroundStyle(.blue)
    }
    
}
struct coins: View, Identifiable, Hashable{
    var id = UUID()
    var body: some View{
        Image(.coin)
            .resizable()
            .frame(width: 8, height: 8).foregroundStyle(.yellow)
    }
}
struct moneyMan: View, Identifiable, Hashable{
    var id = UUID()
    var body: some View{
        Image("MM")
            .resizable()
            .frame(width:21, height:21).foregroundStyle(.orange)
    }
}
struct ops: View, Identifiable, Hashable{
    var id = UUID()
//    var position:  (row: Int, col: Int)
//    let orginalPosition: (row: Int, col: Int)
    var body: some View{
        Image("B3")
            .resizable()
            .frame(width: 14 , height: 14)
            
    }
    
}
struct blankSpace: View, Identifiable, Hashable{
    var id = UUID()
    var body: some View{
        Rectangle().frame(width: 7 , height: 7).foregroundStyle(.clear)
    }
}


enum Direction {
    case up, down, left, right
}

enum GameState {
    case playing, won, gameOver
}
// Now of the fun stuff,
//Now its time to make a observable class in order to display the board, and bind the  numbers to a specific task

class Game: ObservableObject {
    @State private var timer: Timer?
    @Published var mazeSpaces: [[spaces]] = []
    @Published var MazeLayoutEz: [[Int]] = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                                            [1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
                                            [1,3,1,1,0,0,0,1,0,1,1,0,1,1,0,1,1,3,1],
                                            [1,0,0,1,1,0,0,0,0,0,0,0,1,0,0,1,1,0,1],
                                            [1,1,0,1,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1],
                                            [2,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,2],
                                            [1,0,1,1,0,0,0,0,1,1,1,1,1,0,1,1,1,0,1],
                                            [1,0,1,1,0,1,0,0,0,0,0,0,0,0,1,1,1,0,1],
                                            [1,0,1,1,0,1,0,1,1,0,0,1,1,0,0,1,0,0,1],
                                            [1,0,0,0,0,1,0,1,5,5,5,5,1,0,0,0,0,0,1],
                                            [1,0,0,1,0,0,0,1,1,1,1,1,1,0,0,1,0,0,1],
                                            [1,0,1,1,0,1,0,0,0,0,0,0,0,0,1,1,1,0,1],
                                            [2,0,1,1,0,1,1,1,0,1,1,0,1,0,0,1,0,0,2],
                                            [1,0,1,0,0,0,0,0,0,7,0,0,1,1,0,0,0,0,1],
                                            [1,3,1,0,1,0,0,1,1,1,1,0,0,1,1,0,1,3,1],
                                            [1,0,0,0,1,1,0,0,1,1,1,1,0,0,0,0,1,0,1],
                                            [1,0,1,1,1,1,1,0,0,0,1,0,0,1,1,1,1,0,1],
                                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    
    //  Once the class is made to generate the board, the spaces in the board and the counter we then have to make rules for our numbers .
    
   
    
    var moneyManIndexRow = 13
    var moneyManIndexCol = 9
    var moneyManNewPositionRow = 13
    var moneyManNewPositionCol = 8
    
    var badge1positionR = 9
    var badge1positionC = 8
    var newBadge1positionR = 10
    var newBadge1positionC = 8
    
    var badge2positionR = 9
    var badge2positionC = 9
    var newBadge2positionR = 9
    var newBadge2positionC = 8
    
    var badge3positionR = 9
    var badge3positionC = 10
    var newBadge3positionR = 9
    var newBadge3positionC = 9
    
    var badge4positionR = 9
    var badge4positionC = 11
    var newBadge4positionR = 8
    var newBadge4positionC = 11
    
    
    
    var portalLeftR = 5
    var portalLeftC = 0
    
    var portalRightR = 5
    var portalRightC = 18
    
    var portalleftr2 = 12
    var portalleftc2 = 0
    
    var portalrightr2 = 12
    var portalrightc2 = 18
    
    //    var moneyManLives = lives
    
    var lives = 3
    
    var coinCounter = 0
    
    var MMScore = 0
    
    let winCondition1 = 50 // Change this number to adjust win condition
    
    //   after idenfying all the important pieces, we then need to make functions for our SwiftUI view
    func generateBoard() {
        // Only generate board if it doesn't already exist
        if !mazeSpaces.isEmpty {
            return
        }
        
        for row in MazeLayoutEz{
            var spaceRow: [spaces] = []
            for cell in row {
                let space = spaces(num: cell)
                spaceRow.append(space)
            }
            mazeSpaces.append(spaceRow)
        }
        print(mazeSpaces)
    }
    
    func getSwipeDirection(_ value: DragGesture.Value) -> Direction {
        if abs(value.translation.width) > abs(value.translation.height){
            return value.translation.width > 0 ? .right : .left
        }else {
            return value.translation.height > 0 ? .down : .up
        }
    }
    
    func moveMoneyMan(direction: Direction) {
        //        find moneyman then store his current p to have an old and new p
        for (IndexR, Row) in mazeSpaces.enumerated(){
            for (IndexC, _) in Row.enumerated(){
                if mazeSpaces[IndexR][IndexC].num == 7 {
                    moneyManIndexCol = IndexC
                    moneyManIndexRow = IndexR
                    
                    moneyManNewPositionCol = IndexC
                    moneyManNewPositionRow = IndexR
                }
            }
        }
        //        one of the mentors helped me alot this one, the portals are coded first because they can have the potential to falling off the board, so lets sent a rule for those first.
        if mazeSpaces[portalLeftR][portalLeftC].num == 7 &&  direction == .left{
            mazeSpaces[portalLeftR][portalLeftC].num = 4
            mazeSpaces[portalRightR][portalRightC].num = 7
        }else if mazeSpaces[portalRightR][portalRightC].num == 7 && direction == .right {
            mazeSpaces[portalRightR][portalRightC].num = 4
            mazeSpaces[portalLeftR][portalLeftC].num = 7
        }else if mazeSpaces[portalleftr2][portalleftc2].num == 7 && direction == .left {
            mazeSpaces[portalleftr2][portalleftc2].num = 4
            mazeSpaces[portalrightr2][portalrightc2].num = 7
            
        }else if mazeSpaces[portalrightr2][portalrightc2].num == 7 && direction == .right{
            mazeSpaces[portalrightr2][portalrightc2].num = 4
            mazeSpaces[portalleftr2][portalleftc2].num = 7
            
        }else{
            //          we neeed to make a switch case in order to create a case for each direction
            switch direction {
            case .up:
                moneyManNewPositionRow -= 1
            case .down:
                moneyManNewPositionRow += 1
            case .left:
                moneyManNewPositionCol -= 1
            case .right:
                moneyManNewPositionCol += 1
            }
            //now we want money man to have the illision of movemet so we have to take the newpostion move it to our money man and take the previous picture and replace it with a blank space.
            if mazeSpaces[moneyManNewPositionRow][moneyManNewPositionCol].num != 1 &&  mazeSpaces[moneyManNewPositionRow][moneyManNewPositionCol].num != 5{
                // Check if Money-man is collecting a coin
                if mazeSpaces[moneyManNewPositionRow][moneyManNewPositionCol].num == 0 {
                    coinCounter += 1
                    print("Coin collected! Total: \(coinCounter)")
                    
                    // Check win condition after collecting coin
                    if checkWinCondition() {
                        print("🎉 YOU WIN! All coins collected!")
                        // TODO: Navigate to level complete screen
                    }
                }
                
                // Check if Money-man is collecting a boost
                if mazeSpaces[moneyManNewPositionRow][moneyManNewPositionCol].num == 3 {
                    activateBoost()
                }
                
                mazeSpaces[moneyManIndexRow][moneyManIndexCol].num = 4
                mazeSpaces[moneyManNewPositionRow][moneyManNewPositionCol].num = 7
            }
        }
    }
    
    //    now we can make a funtion for the ghost
    //    func moveBadgesToMoneyMan(direction: lives){
    //        for (IndexR, Row) in mazeSpaces.enumerated(){
    //            for (IndexC, _) in Row.enumerated(){
    //                if mazeSpaces[badge2positionR][badge2positionC].num == 5 && mazeSpaces[badge1positionR][badge1positionC].num == 5 && mazeSpaces[badge3positionR][badge3positionC].num == 5 &&
    //                    mazeSpaces[badge4positionR][badge4positionC].num == 5{
    //                    badge1positionC = IndexC
    //                    badge1positionR = IndexR
    //                    newBadge1positionC = IndexC
    //                    newBadge1positionR = IndexR
    //
    //                    badge2positionC = IndexC
    //                    badge2positionR = IndexR
    //                    newBadge2positionC = IndexC
    //                    newBadge2positionR = IndexR
    //
    //                    badge3positionC = IndexC
    //                    badge3positionR = IndexR
    //                    newBadge3positionC = IndexC
    //                    newBadge3positionR = IndexR
    //
    //                    badge4positionC = IndexC
    //                    badge4positionR = IndexR
    //                    newBadge4positionC = IndexC
    //                    newBadge4positionR = IndexR
    //
    //                }
    //            }
    //        }
    //
    //        if mazeSpaces[newBadge1positionR][newBadge1positionC].num != 1 && mazeSpaces[newBadge1positionR][newBadge1positionC].num != 2 && mazeSpaces[newBadge2positionR][newBadge2positionC].num != 1 && mazeSpaces[newBadge2positionR][newBadge2positionC].num != 2 && mazeSpaces[newBadge3positionR][newBadge3positionC].num != 1 && mazeSpaces[newBadge3positionR][newBadge3positionC].num != 2 && mazeSpaces[newBadge4positionR][newBadge4positionC].num != 1 && mazeSpaces[newBadge4positionR][newBadge4positionC].num != 2{
    //
    //            mazeSpaces[badge1positionR][badge1positionC].num = 0
    //            mazeSpaces[newBadge1positionR][newBadge1positionC].num = 5
    //
    //            mazeSpaces[badge2positionR][badge2positionC].num = 0
    //            mazeSpaces[newBadge2positionR][newBadge2positionC].num = 5
    //
    //            mazeSpaces[badge3positionR][badge3positionC].num = 0
    //            mazeSpaces[newBadge3positionR][newBadge3positionC].num = 5
    //
    //            mazeSpaces[badge4positionR][badge4positionC].num = 0
    //            mazeSpaces[newBadge4positionR][newBadge4positionC].num = 5
    //
    //
    //
    //
    //        } else if mazeSpaces[newBadge1positionR][newBadge1positionC].num == 7 || mazeSpaces[newBadge2positionR][newBadge2positionC].num == 7 || mazeSpaces[newBadge3positionR][newBadge3positionC].num == 7 || mazeSpaces[newBadge4positionR][newBadge4positionC].num == 7{
    //            print("You lost a Life, you have \(lives - 1 ) left")
    //
    //        }
    //    }
    //}
    
    
    
    
    //            for (rowIndex, row) in MazeLayoutEz.enumerated() {
    //                for (colIndex, tile) in row.enumerated() {
    //                    if tile == 0{
    //
    //                    }
    //                    if tile == 1{
    //
    //                    }
    //                    if tile == 2{
    //
    //                    }
    //                    if tile == 3{
    //
    //                    }
    //                    if tile == 5{
    //
    //                    }
    //                    if tile == 7{
    //                        moneyManIndexRow = rowIndex
    //                        moneyManIndexCol = colIndex
    //
    //                        moneyManNewPositionRow = rowIndex
    //                        moneyManNewPositionCol = colIndex
    //                    }
    //                }
    //            }
    //        var newRow = moneyManIndexRow
    //        var newCol = moneyManIndexCol
    //
    //        if newRow >= 0 && newRow < mazeSpaces.count &&
    //            newCol >= 0 && newCol < mazeSpaces[0].count {
    //
    //            if MazeLayoutEz[newRow][newCol] != 1 && MazeLayoutEz[newRow][newCol] != 4 {
    //                moneyManIndexRow = newRow
    //                moneyManIndexCol = newCol
    //            }
    //        }
    
    
    
    
    
    
    
    
    
    
    //        for row in 0 ..< rows {
    //            for col in 0 ..< cols {
    //                let cell = UIView()
    //                var backgroundColor : UIColor
    //
    //                switch mazeSpaces[row][col] {
    //                case spaces(num: 0):
    //                    backgroundColor = .black
    //                case spaces(num: 1):
    //                    backgroundColor = .blue
    //                case spaces(num: 2):
    //                    backgroundColor = .gray
    //                case spaces(num: 3):
    //                    backgroundColor = .red
    //                case spaces(num: 4):
    //                    backgroundColor = .green
    //                case spaces(num: 5):
    //                    backgroundColor = .orange
    //                case spaces(num: 7):
    //                    backgroundColor = .brown
    //                default:
    //                    backgroundColor = .black
    //                }
    //                cell.backgroundColor = backgroundColor
    //                cell.frame = CGRect(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize, width: cellSize, height: cellSize)
    //
    //            }
    //        }
    
    //func moveMoneyman(direction: Direction){
    //
    //    }
    
    // take swipe gesture and generate new coordinates
    //var newposition + (newPos1)(newPos2)
    //loop to find his positon
    //find the new positions
    
    //var arr = [[1,2,3]]
    
    //for (index1,intArr) in arr.enumerated() {
    //    for (index2, num) in intArr.enumerated() {
    //        if mazeSpace[index1][index2].number == 7 {
    //
    //            //I know pac's position now
    //
    //              moneyman1= index1
    //                moneyman2 = index2
    //
    //            newposition = index1
    //            newposition = index2
    //
    //        }
    //
    //    }
    //}
    
    //        let cellSize: CGFloat = 20
    //        let rows = MazeLayoutEz.count
    //        let cols = MazeLayoutEz[0].count
    //
    //        func moneyManPosition(row: Int, col: Int) -> Bool {
    //            return row == moneyManIndexRow && col == moneyManIndexCol
    //        }
    //
    
    // Badge AI system - move badges randomly like Pac-Man ghosts
    func moveBadges() {
        moveBadge(badgeIndex: 1, currentRow: badge1positionR, currentCol: badge1positionC)
        moveBadge(badgeIndex: 2, currentRow: badge2positionR, currentCol: badge2positionC)
        moveBadge(badgeIndex: 3, currentRow: badge3positionR, currentCol: badge3positionC)
        moveBadge(badgeIndex: 4, currentRow: badge4positionR, currentCol: badge4positionC)
    }
    
    func moveBadge(badgeIndex: Int, currentRow: Int, currentCol: Int) {
        // Get random direction
        let directions: [Direction] = [.up, .down, .left, .right]
        let randomDirection = directions.randomElement() ?? .up
        
        // Calculate new position
        var newRow = currentRow
        var newCol = currentCol
        
        switch randomDirection {
        case .up: newRow -= 1
        case .down: newRow += 1
        case .left: newCol -= 1
        case .right: newCol += 1
        }
        
        // Check if new position is valid (not a wall)
        if newRow >= 0 && newRow < mazeSpaces.count && 
           newCol >= 0 && newCol < mazeSpaces[0].count &&
           mazeSpaces[newRow][newCol].num != 1 {
            
            // Check if new position is not occupied by another badge
            if mazeSpaces[newRow][newCol].num != 5 {
                // Move the badge
                mazeSpaces[currentRow][currentCol].num = 0 // Leave a coin behind
                mazeSpaces[newRow][newCol].num = 5 // Place badge
                
                // Update badge position
                switch badgeIndex {
                case 1:
                    badge1positionR = newRow
                    badge1positionC = newCol
                case 2:
                    badge2positionR = newRow
                    badge2positionC = newCol
                case 3:
                    badge3positionR = newRow
                    badge3positionC = newCol
                case 4:
                    badge4positionR = newRow
                    badge4positionC = newCol
                default:
                    break
                }
            }
        }
    }
    

    
    // Reset Money-man position after losing a life
    func resetMoneyManPosition() {
        // Remove Money-man from current position
        mazeSpaces[moneyManIndexRow][moneyManIndexCol].num = 4
        
        // Reset to starting position (row 13, col 9)
        moneyManIndexRow = 13
        moneyManIndexCol = 9
        moneyManNewPositionRow = 13
        moneyManNewPositionCol = 9
        
        // Place Money-man at starting position
        mazeSpaces[moneyManIndexRow][moneyManIndexCol].num = 7
    }
    
    // Check win condition - collect target number of coins
    func checkWinCondition() -> Bool {
        // Win if player has collected the target number of coins
        if coinCounter >= winCondition1 {
            print("🎉 Level Complete! Target of \(winCondition1) coins reached!")
            gameState = .won
            showWinScreen = true
            return true
        }
        
        return false
    }
    
    // Game state management
    @Published var gameState: GameState = .playing
    @Published var showWinScreen = false
    
    // Boost system - make badges vulnerable
    @Published var isBoostActive = false
    @Published var boostTimer: Timer?
    
    func activateBoost() {
        isBoostActive = true
        print("🚀 Boost activated! Badges are now vulnerable!")
        
        // Start boost timer (10 seconds)
        boostTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
            self.deactivateBoost()
        }
    }
    
    func deactivateBoost() {
        isBoostActive = false
        print("⚠️ Boost deactivated! Badges are dangerous again!")
        boostTimer?.invalidate()
        boostTimer = nil
    }
    
    // Enhanced collision detection with boost
    func checkBadgeCollisions() {
        if mazeSpaces[moneyManIndexRow][moneyManIndexCol].num == 5 {
            if isBoostActive {
                // Badge is vulnerable - destroy it
                destroyBadge(at: moneyManIndexRow, col: moneyManIndexCol)
                print("💥 Badge destroyed! Boost active!")
            } else {
                // Badge is dangerous - lose a life
                lives -= 1
                print("Badge collision! Lives remaining: \(lives)")
                
                if lives <= 0 {
                    print("Game Over!")
                    // TODO: Handle game over
                } else {
                    resetMoneyManPosition()
                }
            }
        }
    }
    
    // Destroy a badge when boost is active
    func destroyBadge(at row: Int, col: Int) {
        mazeSpaces[row][col].num = 0 // Replace with a coin
        
        // Find which badge was destroyed and reset its position
        if row == badge1positionR && col == badge1positionC {
            resetBadgePosition(badgeIndex: 1)
        } else if row == badge2positionR && col == badge2positionC {
            resetBadgePosition(badgeIndex: 2)
        } else if row == badge3positionR && col == badge3positionC {
            resetBadgePosition(badgeIndex: 3)
        } else if row == badge4positionR && col == badge4positionC {
            resetBadgePosition(badgeIndex: 4)
        }
    }
    
    // Reset badge to starting position after being destroyed
    func resetBadgePosition(badgeIndex: Int) {
        switch badgeIndex {
        case 1:
            badge1positionR = 9
            badge1positionC = 8
            mazeSpaces[9][8].num = 5
        case 2:
            badge2positionR = 9
            badge2positionC = 9
            mazeSpaces[9][9].num = 5
        case 3:
            badge3positionR = 9
            badge3positionC = 10
            mazeSpaces[9][10].num = 5
        case 4:
            badge4positionR = 9
            badge4positionC = 11
            mazeSpaces[9][11].num = 5
        default:
            break
        }
    }
    
    // Reset entire game to start over
    func resetGame() {
        // Reset game state
        gameState = .playing
        showWinScreen = false
        
        // Reset counters
        coinCounter = 0
        lives = 3
        
        // Reset boost
        isBoostActive = false
        boostTimer?.invalidate()
        boostTimer = nil
        
        // Reset Money-man position
        moneyManIndexRow = 13
        moneyManIndexCol = 9
        moneyManNewPositionRow = 13
        moneyManNewPositionCol = 9
        
        // Reset badge positions
        resetBadgePosition(badgeIndex: 1)
        resetBadgePosition(badgeIndex: 2)
        resetBadgePosition(badgeIndex: 3)
        resetBadgePosition(badgeIndex: 4)
        
        // Regenerate the board
        mazeSpaces.removeAll()
        generateBoard()
        
        print("🔄 Game reset! Starting over...")
    }
}
