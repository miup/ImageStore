//
//  Array+Appended.swift
//  FBSnapshotTestCase
//
//  Created by kazuya-miura on 2017/09/05.
//

import Foundation

extension Array {
    func appended(_ element: Array.Element) -> [Array.Element] {
        var newArray = self
        newArray.append(element)
        return newArray
    }
}
