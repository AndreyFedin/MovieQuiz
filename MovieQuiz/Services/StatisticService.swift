//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 21.01.2026.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    internal var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    internal var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            guard let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date else {
                return GameResult(bestGameCorrect: correct, bestGameTotal: total, bestGameDate: Date())
            }
            return GameResult(bestGameCorrect: correct, bestGameTotal: total, bestGameDate: date)
        }
        set {
            storage.set(newValue.bestGameCorrect, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.bestGameTotal, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.bestGameDate, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    internal var totalAccuracy: Double {
        let questions = totalQuestionsAsked
        guard questions > 0 else { return 0.0 }
        return (Double(totalCorrectAnswers) / Double(questions)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let newBestGame = GameResult(bestGameCorrect: count, bestGameTotal: amount, bestGameDate: Date())
        if newBestGame.isBetterThan(bestGame) {
            bestGame = newBestGame
        }
    }
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    private var totalCorrectAnswers: Int {
        get { storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue) }
    }
    
    private var totalQuestionsAsked: Int {
        get { storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue) }
    }
}
