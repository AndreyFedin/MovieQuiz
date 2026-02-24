//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 24.02.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func lockButtons()
    func unlockButtons()
    
    func showNetworkError(message: String)
}
