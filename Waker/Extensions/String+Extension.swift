//
//  String+Extension.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/12.
//

import Foundation

extension String {
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
