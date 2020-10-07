//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let sut = (0..<1000)

func useRandomAccessCollection<C>(collection: C, range: Range<C.Index>) where C: RandomAccessCollection, C.Element: Comparable {
    print("random \(collection)")
    print("collection: \(collection[range])")
}

useRandomAccessCollection(collection: sut, range: 0..<3)

//: [Next](@next)
