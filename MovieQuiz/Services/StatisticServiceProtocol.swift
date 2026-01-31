//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 21.01.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
