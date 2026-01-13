//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 10.01.2026.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
