import XCTest

public struct LinkedList<Value> {
    public final class Node<Value> {
        
    }
    
    public var isEmpty: Bool { true }
    
    public mutating func append(_ value: Value) {}
    public mutating func push(_ value: Value) {}
    public mutating func pop() -> Value? { nil }
    public mutating func removeLast() -> Value? { nil }
//    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {}
//    public mutating func remove(after node: Node<Value>) -> Value? {}
}

extension LinkedList {
    public func toArray() -> [Value] { [] }
}

final class UnitTests: XCTestCase {
    func testAppend() {
        // Given
        var list = LinkedList<Int>()
        
        // Then
        XCTAssertEqual(list.toArray(), [])
        
        // When
        list.append(1)
        list.append(2)
        list.append(3)
        
        // Then
        XCTAssertEqual(list.toArray(), [1,2,3])
    }
    
    func testPush() {
        // Given
        var list = LinkedList<Int>()
        
        // When
        list.push(3)
        list.push(2)
        list.push(1)
        
        // Then
        XCTAssertEqual(list.toArray(), [1,2,3])
    }
    
    func testPop() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        let value = list.pop()
        
        // Then
        XCTAssertEqual(value, 1)
        XCTAssertEqual(list.toArray(), [])
    }
    
    func testRemoveLast() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        let value = list.removeLast()
        
        // Then
        XCTAssertEqual(value, 3)
        XCTAssertEqual(list.toArray(), [1,2])
    }
}

UnitTests.defaultTestSuite.run()