//
//  Question.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/9.
//

import Foundation
import RealmSwift

class Word: Object, Decodable, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var value: String = ""
    @objc dynamic var ipa: String = ""
    @objc dynamic var translation: String = ""
    @objc dynamic var example: String = ""
    @objc dynamic var exampleTranslation: String = ""
    @objc dynamic var partOfSpeech: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case value
        case ipa
        case translation
        case example
        case exampleTranslation
        case partOfSpeech
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        value = try container.decode(String.self, forKey: .value)
        ipa = try container.decode(String.self, forKey: .ipa)
        translation = try container.decode(String.self, forKey: .translation)
        example = try container.decode(String.self, forKey: .example)
        exampleTranslation = try container.decode(String.self, forKey: .exampleTranslation)
        partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        
        super.init()
    }
    
    convenience init(id: Int, value: String, ipa: String, translation: String, example: String, exampleTranslation: String, partOfSpeech: String) {
        self.init()
        self.id = id
        self.value = value
        self.translation = translation
        self.example = example
        self.exampleTranslation = exampleTranslation
        self.partOfSpeech = partOfSpeech
    }
}
