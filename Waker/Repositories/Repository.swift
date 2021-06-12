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
    
    var dataSubject: CurrentValueSubject<[Model], Never> { get }
    var fetchResultSubject: PassthroughSubject<DataFetchResult, Never> { get }
    func fetch()
}

enum DataFetchResult {
    case completed
    case failed(DataFetchError)
}
