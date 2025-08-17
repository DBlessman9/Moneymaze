//
//  HomePage.swift
//  Money-manGame
//
//  Created by Joseph Allen Blessman on 2/18/25.
//
import SwiftUI
import AVKit


class soundManager {
    static let instance = soundManager()
    
    var player: AVAudioPlayer?
    
    enum soundOptions: String {
        case VDO
        case Intro
        case BGM
        case coin
    }
    
    func playSound(sound: soundOptions) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {return}
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
}


struct HomePage: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Image("BG1")
                HStack{
                    NavigationLink{ SwiftUIView()
                    } label: {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:150, height: 70)
                                .foregroundStyle(Color.yellow)
                            VStack{
                                Text("Start")
                                    .font(.largeTitle)
                                    .bold()
                            }
                        }
                        
                    }
                    
                    NavigationLink {TutorialPage()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 150, height: 70)
                                .foregroundStyle(Color.yellow)
                            Text("Tutorial")
                                .font(.largeTitle)
                                .bold()
                        }
                    }
                }
                .padding(.top,600)
            }
        }
    }
}
#Preview {
    HomePage()
}
