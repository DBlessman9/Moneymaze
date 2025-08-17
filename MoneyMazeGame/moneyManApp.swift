//
//  GameScene.swift
//  Money-manGame
//
//  Created by Joseph Allen Blessman on 1/28/25.
//

import SwiftUI
@main
struct moneyManApp: App{
    @StateObject var gameScene = Game()
    var body : some Scene{
        WindowGroup{
            HomePage()
                .environmentObject(gameScene)
        }
    }
}


