//
//  WordStore.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/12.
//

import Foundation
import Combine
import RealmSwift

class WordStore: DataSubscriptable {
    typealias Model = Word
    
    static let shared = WordStore()
    
    private let realm = try! Realm()
    private var words: Results<Word>
    var dataPublisher: AnyPublisher<[Word], Never>
    
    private init() {
        words = realm.objects(Word.self)
        dataPublisher = words.collectionPublisher
            .map({ Array($0) })
            .replaceError(with: [Word]())
            .eraseToAnyPublisher()
    }
    
    func sync(data: [Word]) {
        try! realm.write {
            realm.delete(words)
            realm.add(data)
        }
    }
}
