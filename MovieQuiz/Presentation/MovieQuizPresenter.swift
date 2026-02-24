//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 17.02.2026.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    // MARK: - Dependencies
    private lazy var statisticService: StatisticServiceProtocol = StatisticService()
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    // MARK: - State
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    // MARK: - Init
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Navigation
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            viewController?.show(quiz: viewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        
        viewController?.unlockButtons()
    }
    
    // MARK: - User Actions
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Answer Handling
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let isCorrect = (isYes == currentQuestion.correctAnswer)
        if isCorrect { correctAnswers += 1 }
        proceedWithAnswer(isCorrect: isCorrect)
    }
    
    // MARK: - View Models
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            imageData: model.imageData,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // MARK: - Helpers
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        let currentGameScore = "\(correctAnswers)/\(questionsAmount)"
        let bestGameScore = "\(bestGame.bestGameCorrect)/\(bestGame.bestGameTotal)"
        let bestGameDate = bestGame.bestGameDate.dateTimeString
        let gamesCount = statisticService.gamesCount
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        
        return """
        Ваш результат: \(currentGameScore)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGameScore) (\(bestGameDate))
        Средняя точность: \(accuracy)%
        """
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.viewController?.hideLoadingIndicator()
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
}

