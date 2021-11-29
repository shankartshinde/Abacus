//
//  PaperModel.swift
//  Abacus
//
//  Created by AyunaLabs on 28/11/21.
//

import Foundation

// MARK: - AbacusRoot
struct AbacusRoot: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let sumes: [Sum]?
}

// MARK: - Sume
struct Sum: Codable {
    let id: Int?
//    let question: Question?
//    let answerOption: AnswerOption?
    var answer, userSelectedAnswer: Int?
    var isSumCorrect: Bool? = false
    var isSumSkipped: Bool? = false
    let option1, option2, option3, option4: Int?
    let row1, row2, row3, row4: Int?
}

// MARK: - AnswerOption
struct AnswerOption: Codable {
    let option1, option2, option3, option4: Int?
}

// MARK: - Question
struct Question: Codable {
    let row1, row2, row3, row4: Int?
}
