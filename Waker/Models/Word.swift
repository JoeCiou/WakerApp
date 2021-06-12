//
//  Question.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/9.
//

import Foundation

struct Word: Decodable, Identifiable {
    let id: Int
    let value: String
    var ipa: String
    let translation: String
    let example: String
    let exampleTranslation: String
    let partOfSpeech: String
}

struct WordsApiResponse: Decodable {
    let words: [Word]
}
