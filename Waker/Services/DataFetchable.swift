//
//  DataFetchable.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

protocol DataFetchable {
    associatedtype Model: Decodable
    
    func fetch() -> AnyPublisher<[Model], DataFetchError>
}

enum DataFetchError: Error {
    case networking(URLError)
    case decoding(Error)
}
