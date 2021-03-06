//
//  Service.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

enum ServiceFetchError: Error {
    case networking(URLError)
    case decoding(Error)
}

protocol Service {
    associatedtype Model: Decodable
    
    func fetch() -> AnyPublisher<Model, ServiceFetchError>
}
