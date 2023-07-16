//
//  LevelView.swift
//  ARBall
//
//  Created by Sebastian Strus on 2023-07-14.
//

import SwiftUI

struct LevelView: View {
    
    @EnvironmentObject var gameService: GameService
    
    var level: Level
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var isPresented = false
    
    @State private var currentNumber = 1
    
    
    
    var body: some View {
        
        //GameView(level: .easy, number: 1)
        
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(level.data, id: \.self) { number in
                        
                        VStack {
                            HStack {
                                Spacer()
                                
                                Text(String(number))
                                    .font(.largeTitle)
                                    .foregroundColor(gameService.currentMediumPassed.contains(String(number)) ? .green : .red)
                                    .onTapGesture {
                                        currentNumber = number
                                        isPresented = true
                                    }
                                

    //                            NavigationLink {
    //                                //Text("test level: \(level.data.count), number: \(number)")
    //                                    // Navigate to a different view!
    //                                GameView(level: .easy, number: 1)
    //                                //GameView(level: level, number: number)
    //                                } label: {
    //                                    Text(String(number))
    //                                        .font(.largeTitle)
    //                                        .foregroundColor(gameService.currentMediumPassed.contains(String(number)) ? .green : .red)
    //                                }
                                
    //                            Text(number)
    //                                .font(.largeTitle)
    //                                .foregroundColor(gameService.currentMediumPassed.contains(number) ? .green : .red)
                                
                                
                                Spacer()
                            }
                        }.padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal)
                
                Button("Click1") {
                    gameService.updatePassedEasy(gameNr: "3")
                    gameService.updatePassedMedium(gameNr: "2")
                    gameService.updatePassedEasy(gameNr: "1")
    //                gameService.resetEasy()
                }
            }
            .background(Color(red: 104/255, green: 59/255, blue: 15/255))
            //.edgesIgnoringSafeArea(.all)
            .navigationTitle(level.text)
            
            if isPresented {
                GameView(showAlert: false, showGameOver: false, showWin: false, level: level, number: currentNumber)
            }
        }
        
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView(level: Level(rawValue: "Easy")!)
    }
}
