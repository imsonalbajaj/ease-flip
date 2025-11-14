//
//  ScoreModel.swift
//  easeFlip
//
//  Created by Sonal on 13/11/25.
//

import SwiftData

@Model
final class ScoreModel {
    var timestamp: Double
    var score: Int
    var level: String
    
    init(timestamp: Double, score: Int, level: String) {
        self.timestamp = timestamp
        self.score = score
        self.level = level
    }
}
