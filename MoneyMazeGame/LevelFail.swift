//
//  startPage.swift
//  Money-manGame
//
//  Created by Joseph Allen Blessman on 2/18/25.
//
import SwiftUI
struct LevelFail: View {
    var body: some View {
        ZStack{
            Image("BG3")
                .resizable()
                .frame(width: 410)
                .scaledToFill()
                .ignoresSafeArea(.all)
            VStack{
                Spacer()
                NavigationLink{ SwiftUIView()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:150, height: 70)
                            .foregroundStyle(Color.yellow)
                        Text("Retry")
                            .font(.largeTitle)
                            .bold()
                    }
                }
                
            }
        }
    }
}
#Preview {
    LevelFail()
}
