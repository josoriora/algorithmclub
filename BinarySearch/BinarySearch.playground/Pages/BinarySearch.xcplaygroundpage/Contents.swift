import XCTest


extension Range {
    var isValid : Bool {
        return self.lowerBound < self.upperBound
    }
}

func binarySearch<C>(
    for element: C.Element,
    in collection: C,
    range: Range<C.Index>? = nil
) -> C.Index? where C: RandomAccessCollection, C.Element: Comparable {
    print("----- binary search ------")
    print("element: \(element)")
    var range = range ?? collection.startIndex..<collection.endIndex
    
    guard range.isValid else { return nil }
    
    let distance = collection.distance(from: range.lowerBound, to: range.upperBound)
    let middleIndex = collection.index(range.lowerBound, offsetBy: distance / 2)
    let middleElement = collection[middleIndex]
    print("middle index: \(middleIndex)")
    print("middle element: \(middleElement)")
    
    if middleElement > element {
        range = range.lowerBound..<middleIndex
        print("lower range: \(range)")
    } else if middleElement < element {
        range = collection.index(after: middleIndex)..<range.upperBound
        print("upper range: \(range)")
    } else {
        print("index found: \(middleIndex)")
        return middleIndex
    }
    
    return binarySearch(for: element, in: collection, range: range)
}



final class UnitTests: XCTestCase {
    let sut = (0..<1000)
    /*
    func testBinarySearch_canFindElement() {
        guard let index = binarySearch(
            for: 501,
            in: sut
        ) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(sut[index], 501)
    }
    
    func testBinarySearch_cannotFindElement() {
        let index = binarySearch(
            for: 1001,
            in: sut
        )
        
        XCTAssertNil(index)
    }
 


    func testBinarySearch_worksLikeIndexOf() {
        let value = 31
        let firstIndex = sut.firstIndex(of: value)
        let binarySeachIndex = binarySearch(
            for: value,
            in: sut
        )
        
        XCTAssertEqual(firstIndex, binarySeachIndex)
    }
     */
    
     //Challenge: Create a findIndices free function that return the range of the indices for an element
     //Suggestion: Create a startIndex and endIndex free function
 
    
    
    func startIndex<C>(of element: C.Element, in collection: C, range: Range<C.Index>? = nil) -> C.Index? where C: RandomAccessCollection, C.Element: Comparable {
        print("----- start Index ------")
        print("element: \(element)")
        var range = range ?? collection.startIndex..<collection.endIndex
        
        guard range.isValid else { return nil }
        
        let distance = collection.distance(from: range.lowerBound, to: range.upperBound)
        let middleIndex = collection.index(range.lowerBound, offsetBy: distance / 2)
        let middleElement = collection[middleIndex]
        print("middle index: \(middleIndex)")
        print("middle element: \(middleElement)")
        
        if middleIndex == range.lowerBound {
            return middleElement == element ? middleIndex : nil
        }
        
        if middleElement > element {
            range = range.lowerBound..<middleIndex
            print("lower range: \(range)")
        } else if middleElement < element {
            range = collection.index(after: middleIndex)..<range.upperBound
            print("upper range: \(range)")
        } else {
            print("index found: \(middleIndex)")
            let indexBefore = collection.index(before: middleIndex)
            let indexBeforeValue = collection[indexBefore]
            
            if indexBeforeValue != middleElement {
                return middleIndex
            } else {
                range = range.lowerBound..<middleIndex
            }
        }
        
        return startIndex(of: element, in: collection, range: range)
    }
    
    func testBinarySearch_startIndex() {
        let index = startIndex(of: 3,
                               in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 2)
    }
    
    func testBinarySearch_startIndex_lowerBound() {
        let index = startIndex(of: 3,
                               in: [3,3,3,4,5,5])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 0)
    }
    
    /*
    func testBinarySearch_endIndex() {
        let index = endIndex(of: 3,
                             in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 5)
    }
    func testBinarySearchFindIndices_freeFunction() {
        let indices = findIndices(of: 3,
                                  in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(indices)
        XCTAssertEqual(indices, 2..<5)
    }
     */
}

UnitTests.defaultTestSuite.run()
