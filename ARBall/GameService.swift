//
//  GameService.swift
//  ARBall
//
//  Created by Sebastian Strus on 2023-07-14.
//

import SwiftUI

class GameService: ObservableObject {
    @Published var currentEasyPassed: [String] = []
    @Published var currentMediumPassed: [String] = []
    @Published var currentHardPassed: [String] = []

    @AppStorage("passedEasy") private(set) var passedEasy: String = "" {
        didSet {
            setPassedEasy()
        }
    }
    
    @AppStorage("passedMedium") private(set) var passedMedium: String = "" {
        didSet {
            setPassedMedium()
        }
    }
    
    @AppStorage("passedHard") private(set) var passedHard: String = "" {
        didSet {
            setPassedHard()
        }
    }
    
    

    public init() {
        setPassedEasy()
        setPassedMedium()
        setPassedHard()
    }
    
    

    func updatePassedEasy(gameNr: String) {
        let currentEasy = passedEasy.components(separatedBy: ",").compactMap { $0 }
        if !currentEasy.contains(gameNr) {
            passedEasy = currentEasy.isEmpty ? gameNr : passedEasy + "," + gameNr
        }
    }
    
    func updatePassedMedium(gameNr: String) {
        let currentMedium = passedMedium.components(separatedBy: ",").compactMap { $0 }
        if !currentMedium.contains(gameNr) {
            passedMedium = currentMedium.isEmpty ? gameNr : passedMedium + "," + gameNr
        }
    }
    
    func updatePassedHard(gameNr: String) {
        let currentHard = passedHard.components(separatedBy: ",").compactMap { $0 }
        if !currentHard.contains(gameNr) {
            passedHard = currentHard.isEmpty ? gameNr : passedHard + "," + gameNr
        }
    }
    
    func resetEasy() {
        passedEasy = ""
    }
    
    
    
    private func setPassedEasy() {
        currentEasyPassed = passedEasy.components(separatedBy: ",").compactMap { $0 }
    }
    
    private func setPassedMedium() {
        currentMediumPassed = passedMedium.components(separatedBy: ",").compactMap { $0 }
    }
    
    private func setPassedHard() {
        currentHardPassed = passedHard.components(separatedBy: ",").compactMap { $0 }
    }
}
