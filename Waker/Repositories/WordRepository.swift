//
//  WordRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/12.
//

import Foundation
import Combine

class WordRepository: Repository {
    typealias Model = Word
    
    static let shared = WordRepository()
    
    private var dataSubject: PassthroughSubject<[Word], Never>?
    private var fetchResultSubject: PassthroughSubject<DataFetchResult, Never>?
    private var storeCanceller: AnyCancellable?
    private var serviceCanceller: AnyCancellable?
    
    var isConnected: Bool {
        storeCanceller != nil
    }
    
    private init() {
        
    }
    
    deinit {
        disconnect()
        serviceCanceller?.cancel()
    }
    
    func connect() -> AnyPublisher<[Word], Never> {
        dataSubject = PassthroughSubject<[Word], Never>()
        storeCanceller = WordStore.shared.connect().sink { [unowned self] words in
            self.dataSubject?.send(words)
        }
        
        return dataSubject!.eraseToAnyPublisher()
    }
    
    func disconnect() {
        storeCanceller?.cancel()
        WordStore.shared.disconnect()
    }
    
    func fetch() -> AnyPublisher<DataFetchResult, Never> {
        fetchResultSubject = PassthroughSubject<DataFetchResult, Never>()
        serviceCanceller = WordService.shared.fetch()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    self.fetchResultSubject?.send(.completed)
                case .failure(let error):
                    self.fetchResultSubject?.send(.failed(error))
                }
                self.serviceCanceller?.cancel()
                self.fetchResultSubject = nil
            } receiveValue: { words in
                self.dataSubject?.send(words)
                WordStore.shared.sync(data: words)
            }
        
        return fetchResultSubject!.eraseToAnyPublisher()
    }
}
