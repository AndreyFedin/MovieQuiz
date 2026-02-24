//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 24.02.2026.
//

import XCTest
@testable import MovieQuiz

// Test double that avoids subclassing a final class.
// Conforms to the view protocol the presenter should depend on.
final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func lockButtons() { }
    func unlockButtons() { }
    func show(quiz step: QuizStepViewModel) { }
    func show(quiz result: QuizResultsViewModel) { }
    func highlightImageBorder(isCorrectAnswer: Bool) { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
    func showNetworkError(message: String) { }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(imageData: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.imageData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
