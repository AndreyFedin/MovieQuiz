//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 14.01.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
