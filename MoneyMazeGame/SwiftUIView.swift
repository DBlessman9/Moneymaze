//
//  SwiftUIView.swift
//  Money-manGame
//
//  Created by Joseph Allen Blessman on 1/31/25.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var badgeTimer: Timer?
    @State var printDirec = Direction.left
    @EnvironmentObject var gameScene:Game
    @Environment(\.dismiss) private var dismiss
    var body: some View{
        ZStack {
            // Main Game Content
            VStack {
                // Game Board
                Grid(horizontalSpacing: 0, verticalSpacing: 0){
                    ForEach(gameScene.mazeSpaces, id: \.self){ row in GridRow{
                        ForEach(row, id:\.id){
                            spaces in
                            switch spaces.num {
                            case 0: coins()
                            case 1: wall()
                            case 2: portal()
                            case 3: boost()
                            case 5: ops()
                            case 7: moneyMan()
                            case 4:blankSpace()
                            default: blankSpace()
                                }
                            }
                        }
                    }
                }
                .opacity(gameScene.gameState == .playing ? 1.0 : 0.3)
                .disabled(gameScene.gameState != .playing)
                
                // Game Stats
                VStack(spacing: 10) {
                    HStack {
                        Text("Coins: \(gameScene.coinCounter)/\(gameScene.winCondition1)")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .padding()
                        
                        Text("Lives: \(gameScene.lives)")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding()
                        
                        if gameScene.isBoostActive {
                            Text("🚀 BOOST!")
                                .font(.title2)
                                .foregroundColor(.purple)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Progress bar for coins
                    ProgressView(value: Double(gameScene.coinCounter), total: Double(gameScene.winCondition1))
                        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        .frame(width: 200, height: 8)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(4)
                }
                
                Text("\(printDirec)")
                Spacer()
                
                // Controller
                Image("CC")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.top, 50)
                    .gesture(DragGesture().onEnded({value in
                        let direc = gameScene.getSwipeDirection(value)
                        printDirec = direc
                        gameScene.moveMoneyMan(direction: direc)}))
            }
            
            // Win Screen Overlay
            if gameScene.showWinScreen {
                VStack(spacing: 30) {
                    Text("🎉 YOU WIN! 🎉")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.yellow)
                    
                    Text("Coins Collected: \(gameScene.coinCounter)")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Target: \(gameScene.winCondition1)")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        Button("Play Again") {
                            gameScene.resetGame()
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        
                        Button("Main Menu") {
                            // Stop timer and navigate back to main menu
                            stopBadgeTimer()
                            dismiss() // This will return to the previous view (HomePage)
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                .padding(40)
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .shadow(radius: 20)
            }
        }
        .onAppear(perform: {
            gameScene.generateBoard()
            startBadgeTimer()
        })
        .onDisappear {
            stopBadgeTimer()
        }
    }
    
    // Badge movement timer functions
    func startBadgeTimer() {
        badgeTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            // Only continue game if still playing
            if gameScene.gameState == .playing {
                gameScene.moveBadges()
                gameScene.checkBadgeCollisions()
                
                // Check win condition after each badge move
                if gameScene.checkWinCondition() {
                    print("🎉 Level Complete! Target of \(gameScene.winCondition1) coins reached!")
                    stopBadgeTimer() // Stop the timer when game is won
                }
            }
        }
    }
    
    func stopBadgeTimer() {
        badgeTimer?.invalidate()
        badgeTimer = nil
    }
}

#Preview {
    SwiftUIView()
        .environmentObject(Game())
}
