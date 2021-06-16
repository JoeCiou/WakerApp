//
//  Repository.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

enum RepositoryRefreshResult {
    case completed
    case failed(ServiceFetchError)
}

protocol Repository {
    associatedtype Model
    
    var isConnected: Bool { get }
    func connect() -> (AnyPublisher<Model, Never>, AnyPublisher<RepositoryRefreshResult, Never>)
    func disconnect()
    func refresh()
}

