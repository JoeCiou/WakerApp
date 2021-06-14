//
//  Repository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

protocol Repository {
    associatedtype Model
    
    var isConnected: Bool { get }
    func connect() -> AnyPublisher<[Model], Never>
    func disconnect()
    func fetch() -> AnyPublisher<DataFetchResult, Never>
}

enum DataFetchResult {
    case completed
    case failed(DataFetchError)
}
