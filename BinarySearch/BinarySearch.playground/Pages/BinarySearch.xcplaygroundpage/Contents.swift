import XCTest

func binarySearch<C>(
    for element: C.Element,
    in collection: C
) -> C.Index? where C: RandomAccessCollection, C.Element: Comparable {
    print("----- binary search ------")
    
    var range = collection.startIndex..<collection.endIndex
    
    while range.lowerBound < range.upperBound {
        let distance = collection.distance(from: range.lowerBound, to: range.upperBound)
        let middleIndex = collection.index(range.lowerBound, offsetBy: distance / 2)
        let middleElement = collection[middleIndex]
        
        if middleElement > element {
            range = range.lowerBound..<middleIndex
        } else if middleElement < element {
            range = middleIndex..<range.upperBound
        } else {
            return middleIndex
        }
    }
    /*
     value = 5
     
     1 - 2 - 3 - 4 - 5
     
     it 1:
     m = (4 - 0) / 2 = 2
     
     cv = collection[m]
     
     if cv > v
        right = m - 1
     else if cv < v
        left = m + 1
     else
        return cv
     */
    return nil
}

final class UnitTests: XCTestCase {
    let sut = (0..<1000)
    
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
    /*
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
    
    
     Challenge: Create a findIndices free function that return the range of the indices for an element
     Suggestion: Create a startIndex and endIndex free function
    func testBinarySearch_startIndex() {
        let index = startIndex(of: 3,
                               in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 2)
    }
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
