//
//  MainMenuView.swift
//  ARBall
//
//  Created by Sebastian Strus on 2023-07-14.
//

import SwiftUI

enum Level: String, CaseIterable {
    case easy, medium, hard
    
    var text:String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
    
    var data: [Int] {
        switch self {
        case .easy:
            return [1, 2, 3, 4, 5, 6]//.map { "\($0) }
        case .medium:
            return [1, 2, 3, 4]//.map { "\($0)" }
        case .hard:
            return [1, 2]//.map { "\($0)" }
        }
    }
}

struct MainMenuView: View {
    
    @StateObject var gameService: GameService
    
    public init() {
        _gameService = StateObject(wrappedValue: GameService())
    }
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("MazeAR")
                    .font(Font.custom("B1 Maze", size: 74))//RubikMaze-Regular, B1 Maze
                    .foregroundColor(.white)
                Text("Navigate AR Labyrinths")
                    .font(.system(size: 30))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                
                Spacer()
                
                ForEach(Level.allCases, id: \.self) { level in
                    NavigationLink(value: level) {
                        Text(level.text)
                        //RubikMaze-Regular, B1 Maze
                            .font(.system(size: 40))
                            .fontWeight(.light)
                            //.font(Font.custom("B1 Maze", size: 50))
                            .frame(width: 260, height: 80)
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 52)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding([.bottom], 10)
                        
                            
                    }
                }
                
                Spacer()
            }
            .background(Image("background"))
            .edgesIgnoringSafeArea(.all)
            

         
            .navigationDestination(for: Level.self) { level in
                LevelView(level: level)
            }
         
            //.navigationTitle("Main menu")
        }.environmentObject(gameService)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    //@StateObject var gameService: GameService
    
    static var previews: some View {
        MainMenuView()
    }
}

