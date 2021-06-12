//
//  Repository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

protocol Repository {
    associatedtype Model: Decodable
    
    var dataSubject: CurrentValueSubject<[Model], Never> { get }
    init(subscriptable: AnyDataSubscriptable<Model>, fetchable: AnyDataFetchable<Model>)
    func fetch()
}


class AnyRepository<Model: Decodable>: Repository {
    private let subscriptable: AnyDataSubscriptable<Model>
    private let fetchable: AnyDataFetchable<Model>
    
    let dataSubject = CurrentValueSubject<[Model], Never>([])
    let errorSubject = PassthroughSubject<DataFetchableError, Never>()
    
    var subscriptableCanceller: AnyCancellable?
    var fetchableCanceller: AnyCancellable?
    
    required init(subscriptable: AnyDataSubscriptable<Model>, fetchable: AnyDataFetchable<Model>) {
        self.subscriptable = subscriptable
        self.fetchable = fetchable
        
        subscriptableCanceller = subscriptable.dataPublisher.sink { models in
            self.dataSubject.send(models)
        }
    }
    
    deinit {
        self.subscriptableCanceller?.cancel()
        self.fetchableCanceller?.cancel()
    }
    
    func fetch() {
        fetchableCanceller = fetchable.fetch().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let e):
                self.errorSubject.send(e)
            }
        } receiveValue: { models in
            self.dataSubject.send(models)
        }
    }
}
