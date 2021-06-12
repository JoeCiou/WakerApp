//
//  DataSubscriptable.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

protocol DataSubscriptable {
    associatedtype Model
    
    var dataPublisher: AnyPublisher<[Model], Never> { get }
}

class AnyDataSubscriptable<Model>: DataSubscriptable {
    var dataPublisher: AnyPublisher<[Model], Never>
    
    init(_ dataPublisher: AnyPublisher<[Model], Never>) {
        self.dataPublisher = dataPublisher
    }
}
