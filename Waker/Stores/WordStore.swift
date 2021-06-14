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
    private var words: Results<Word>?
    private var dataSubject: PassthroughSubject<[Word], Never>?
    private var canceller: AnyCancellable?
    
    var isConnected: Bool {
        canceller != nil
    }
    
    private init() {
        
    }
    
    deinit {
        disconnect()
    }
    
    func connect() -> AnyPublisher<[Word], Never> {
        dataSubject = PassthroughSubject<[Word], Never>()
        words = realm.objects(Word.self)
        canceller = words!.collectionPublisher
            .map({ Array($0) })
            .replaceError(with: [Word]())
            .sink { words in
                self.dataSubject?.send(words)
            }
        
        return dataSubject!.eraseToAnyPublisher()
    }
    
    func disconnect() {
        canceller?.cancel()
        words = nil
        dataSubject = nil
    }
    
    func sync(data: [Word]) {
        let words = realm.objects(Word.self)
        
        try! realm.write {
            realm.delete(words)
            realm.add(data)
        }
    }
}
