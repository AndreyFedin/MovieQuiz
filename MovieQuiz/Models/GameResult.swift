//
//  GameResult.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 21.01.2026.
//

import Foundation

struct GameResult {
    let bestGameCorrect: Int
    let bestGameTotal: Int
    let bestGameDate: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        bestGameCorrect > another.bestGameCorrect
    }
}
