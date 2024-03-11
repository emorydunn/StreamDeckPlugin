//
//  Clamped.swift
//  
//
//  Created by Emory Dunn on 5/22/20.
//

import Foundation

extension Comparable {
    
    /// Limit a value to the specified range.
    ///
    /// ```
    /// 4.clamped(to: 1..<10) // 4
    /// 11.clamped(to: 1..<10) // 10
    /// 0.clamped(to: 1..<10) // 1
    /// ```
    ///
    /// - Parameter limits: Bounds of allowable values.
    /// - Returns: The clamped value
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Strideable where Stride: SignedInteger {
    
    /// Limit a value to the specified range.
    ///
    /// ```
    /// 4.clamped(to: 1..<10) // 4
    /// 11.clamped(to: 1..<10) // 10
    /// 0.clamped(to: 1..<10) // 1
    /// ```
    ///
    /// - Parameter limits: Bounds of allowable values.
    /// - Returns: The clamped value
    public func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
