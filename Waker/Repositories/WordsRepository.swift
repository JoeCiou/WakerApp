//
//  WordsRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/12.
//

import Foundation
import Combine

enum WordsRepositorySource {
    case store(WordsStore)
    case service(WordsService)
    case serviceWithSyncableStore(WordsService, WordsStore & WordsSyncable)
}

class WordsRepository: Repository {
    typealias Model = [Word]
    
    static let shared = WordsRepository()
    
    private let source: WordsRepositorySource
    private var dataSubject: PassthroughSubject<[Word], Never>?
    private var refreshResultSubject: PassthroughSubject<RepositoryRefreshResult, Never>?
    private var storeCanceller: AnyCancellable?
    private var serviceCanceller: AnyCancellable?
    
    var isConnected: Bool {
        dataSubject != nil
    }
    
    init(source: WordsRepositorySource = .serviceWithSyncableStore(WordsService.shared, WordsRealmStore.shared)) {
        self.source = source
    }
    
    deinit {
        disconnect()
    }
    
    func connect() -> (AnyPublisher<[Word], Never>, AnyPublisher<RepositoryRefreshResult, Never>) {
        dataSubject = PassthroughSubject<[Word], Never>()
        refreshResultSubject = PassthroughSubject<RepositoryRefreshResult, Never>()
        
        switch source {
        case .store(let store):
            storeCanceller = store.connect().sink { [unowned self] words in
                self.dataSubject?.send(words)
            }
        case .service(let service):
            refreshWith(service: service)
        case .serviceWithSyncableStore(let service, let store):
            storeCanceller = store.connect().sink { [unowned self] words in
                self.dataSubject?.send(words)
            }
            refreshWith(service: service, store: store)
        }
        
        return (dataSubject!.eraseToAnyPublisher(), refreshResultSubject!.eraseToAnyPublisher())
    }
    
    func disconnect() {
        storeCanceller?.cancel()
        serviceCanceller?.cancel()
        dataSubject = nil
        refreshResultSubject = nil
        
        switch source {
        case .store(let store):
            if store.isConnected {
                store.disconnect()
            }
        case .service(_):
            break
        case .serviceWithSyncableStore(_, let store):
            if store.isConnected {
                store.disconnect()
            }
        }
    }
    
    func refresh() {
        switch source {
        case .store(_):
            return // Realm store will update immediately if there are any changes
        case .service(let service):
            refreshWith(service: service)
        case .serviceWithSyncableStore(let service, let store):
            refreshWith(service: service, store: store)
        }
    }
    
    private func refreshWith(service: WordsService, store: (WordsStore & WordsSyncable)? = nil) {
        serviceCanceller = service.fetch()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    self.refreshResultSubject?.send(.completed)
                case .failure(let error):
                    self.refreshResultSubject?.send(.failed(error))
                }
                self.serviceCanceller?.cancel()
            } receiveValue: { words in
                self.dataSubject?.send(words)
                store?.sync(data: words)
            }
    }
}
