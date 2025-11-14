//
//  GameLevel.swift
//  easeFlip
//
//  Created by Sonal on 13/11/25.
//

import Foundation

enum GameLevel: String, CaseIterable {
    case easy
    case medium
    case hard
    
    func getRowCol() -> (Int, Int) {
        switch self {
        case .easy:
            return (3, 3)
        case .medium:
            return (4, 4)
        case .hard:
            return (5, 5)
        }
    }
    
    func getDifficulty() -> Int {
        switch self {
        case .easy:
            return 0
        case .medium:
            return 1
        case .hard:
            return 2
        }
    }
}
