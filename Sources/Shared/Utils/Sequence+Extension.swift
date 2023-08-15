//
//  Sequence+Extension.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/13/23.
//

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
