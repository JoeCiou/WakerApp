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
    
    var isConnected: Bool { get }
    func connect() -> AnyPublisher<[Model], Never>
    func disconnect()
}
