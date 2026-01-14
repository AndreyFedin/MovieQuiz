//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 14.01.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
