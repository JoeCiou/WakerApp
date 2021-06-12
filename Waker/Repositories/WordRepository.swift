//
//  WordRepository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/12.
//

import Foundation
import Combine

class WordRepository: Repository {
    static let shared = WordRepository()
    
    let dataSubject = CurrentValueSubject<[Word], Never>([])
    let fetchResultSubject = PassthroughSubject<DataFetchResult, Never>()

    var storeCanceller: AnyCancellable?
    var serviceCanceller: AnyCancellable?

    private init() {
        storeCanceller = WordStore.shared.dataPublisher.sink { words in
            self.dataSubject.send(words)
        }
    }

    deinit {
        self.storeCanceller?.cancel()
        self.serviceCanceller?.cancel()
    }

    func fetch() {
        serviceCanceller = WordService.shared.fetch().receive(on: DispatchQueue.main).sink { completion in
            switch completion {
            case .finished:
                self.fetchResultSubject.send(.completed)
            case .failure(let error):
                self.fetchResultSubject.send(.failed(error))
            }
        } receiveValue: { words in
            self.dataSubject.send(words)
            WordStore.shared.sync(data: words)
        }
    }
}
