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
