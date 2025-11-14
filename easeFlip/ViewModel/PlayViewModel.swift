//
//  PlayViewModel.swift
//  easeFlip
//
//  Created by Sonal on 29/07/25.
//

import SwiftUI
import SwiftData

class PlayViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    let emogiesSet = ["🐶", "🐱", "🐭", "🦊", "🐻", "🐼", "🐸", "🐵", "🐥", "🐞", "🌻", "🍎", "🍩", "🏀", "🚗", "✈️"]
    let rows: Int
    let columns: Int
    var itemCount: Int {
        return rows * columns
    }
    let gameLevel: GameLevel
    
    @Published var cardAtLocation: [String] = []
    @Published var tapped: [Bool] = []
    
    @Published var youScore: Int = 0
    @Published var gamOver: Bool = false
    @Published var currArr: [Int] = []
    
    init(forLevel: GameLevel, modelContext: ModelContext) {
        self.gameLevel = forLevel
        self.modelContext = modelContext
        
        self.rows = 4 + forLevel.getDifficulty()
        self.columns = 2 + forLevel.getDifficulty()
        setVal()
    }
    
    func setVal() {
        tapped = []
        cardAtLocation = []
        currArr.removeAll()
        
        var tempEmogiesSet = emogiesSet
        tempEmogiesSet.shuffle()
        let arr = Array(tempEmogiesSet.prefix(rows))
        
        var emogis = [String]()
        for _ in 0 ..< columns {
            emogis.append(contentsOf: arr)
        }
        
        youScore = 0
        gamOver = false
        
        tapped = Array(repeating: false, count: itemCount)
        emogis.shuffle()
        cardAtLocation = emogis
    }
    
    
    func cardTapped(idx: Int) {
        if tapped[idx] == true {
            return
        }
        
        playFlipSound()
        
        youScore += 1
        let currEmogi = cardAtLocation[idx]
        tapped[idx] = true
        currArr.append(idx)
        
        if currArr.contains(where: {cardAtLocation[$0] != currEmogi}) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                
                for i in self.currArr {
                    self.tapped[i] = false
                }
                self.currArr.removeAll()
                
                self.playErrorSound()
            }
        } else if currArr.count == columns {
            currArr.removeAll()
        }
        
        checkForWin()
    }
    
    private func checkForWin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self, !self.gamOver else { return }
            
            
            let cond = self.tapped.allSatisfy({$0 == true})
            
            if cond {
                self.gamOver = true
                self.saveTheScore()
                self.playWinSound()
            }
        }
    }
    
    private func saveTheScore() {
        let timeInterval = Date().timeIntervalSince1970
        
        let scoreModel = ScoreModel(
            timestamp: timeInterval,
            score: self.youScore,
            level: self.gameLevel.rawValue
        )
        
        self.modelContext.insert(scoreModel)
        
        do {
            try self.modelContext.save()
            print("Score saved successfully!")
        } catch {
            print("Failed to save score: \(error)")
        }
    }
    
    private func playFlipSound() {
        SoundManager.shared.play(soundFile: .flipcard)
    }
    
    private func playErrorSound() {
        SoundManager.shared.play(soundFile: .error)
    }
    
    private func playWinSound() {
        SoundManager.shared.play(soundFile: .win_sound)
    }
}
