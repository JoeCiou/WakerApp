//
//  Binding+Extension.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/6.
//

import SwiftUI

extension Binding where Value == Optional<String> {
    func onNone(_ fallback: String) -> Binding<String> {
        return Binding<String>(get: {
            return self.wrappedValue ?? fallback
        }) { value in
            self.wrappedValue = value
        }
    }
}
