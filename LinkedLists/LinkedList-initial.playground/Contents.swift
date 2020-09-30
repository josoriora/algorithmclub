import XCTest

public struct LinkedList<Value> {
    public final class Node<Value> {
        public let value: Value
        public var nextNode: Node?
        
        public init(value: Value, nextNode: Node? = nil) {
            self.value = value
            self.nextNode = nextNode
        }
    }
    
    public var head: Node<Value>?
    public var tail: Node<Value>?
    public private(set) var count: Int = 0
    public var isEmpty: Bool { self.head == nil }
    
    public mutating func push(_ value: Value) {
        print("----- push ----------")
        let newNode = Node(value: value, nextNode: self.head)
        
        self.head = newNode
        
        if self.tail == nil {
            self.tail = self.head
        }
        
        count += 1
    }
    
    @discardableResult
    public mutating func pop() -> Value? {
        print("----- pop ----------")
        defer {
            self.head = self.head?.nextNode
            count -= 1
            
            if isEmpty {
                self.tail = nil
            }
        }
        
        copyNodes()
        
        return self.head?.value
    }
    
    public mutating func append(_ value: Value) {
        print("----- append ----------")
        copyNodes()
        
        guard let tail = self.tail else {
            self.push(value)
            return
        }
        
        tail.nextNode = Node(value: value)
        self.tail = tail.nextNode
        count += 1
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
        print("----- remove last ----------")
        
        copyNodes()
        
        if self.head?.nextNode == nil {
            return self.pop()
        }
        
        var previousNode: Node<Value>? = nil
        
        forEachWhile { (node: Node<Value>) -> (Bool) in
            if node.nextNode?.nextNode == nil {
                previousNode = node
                return false
            } else {
                return true
            }
        }
        
        let tailValue = self.tail?.value
        previousNode?.nextNode = nil
        self.tail = previousNode
        count -= 1
        
        return tailValue
    }
    
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        let nextNode = copyNodes(with: node.nextNode) ?? node.nextNode
        let newNode = Node(value: value, nextNode: nextNode)
        
        if newNode.nextNode == nil {
            self.tail = newNode
        }
        
        node.nextNode = newNode
        count += 1
        return newNode
    }
    
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            let newNode = copyNodes(with: node) ?? node
            if newNode.nextNode === self.tail {
                self.tail = newNode
            }
            
            count -= 1
            newNode.nextNode = newNode.nextNode?.nextNode
        }
        
        return node.nextNode?.value
    }
    
    @discardableResult
    private mutating func copyNodes(with referencedNode: Node<Value>? = nil) -> Node<Value>? {
        guard !isKnownUniquelyReferenced(&self.head), let oldHead = head else {
            return nil
        }
        
        var copiedReferencedNode: Node<Value>?
        var newNode: Node<Value>?
        head = Node(value: oldHead.value)
        newNode = head
        
        if oldHead === referencedNode {
            copiedReferencedNode = self.head
        }
        
        while let nextOldNode = oldHead.nextNode {
            newNode?.nextNode = Node(value: nextOldNode.value)
            newNode = newNode?.nextNode
        }
        
        if tail === referencedNode {
            copiedReferencedNode = newNode
        }
        
        tail = newNode
        
        return copiedReferencedNode
    }
    
    private func forEachWhile(closure: (Node<Value>) -> (Bool)) {
        var currentNode = self.head
        
        while currentNode != nil {
            guard closure(currentNode!) else { return }
            currentNode = currentNode?.nextNode
        }
    }
    
    private func forEach(closure: (Node<Value>) -> ()) {
        forEachWhile { (node: Node<Value>) -> (Bool) in
            closure(node)
            return true
        }
    }
}

extension LinkedList.Node: CustomStringConvertible {
    public var description: String {
        guard let next = nextNode else {
            return "\(value) -> nil"
        }
        return "\(value) -> " + String(describing: next)
    }
}

/*
extension LinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Value
    
    public init(arrayLiteral elements: LinkedList.ArrayLiteralElement...) {
        self.init()
        elements.forEach { append($0) }
    }
}
*/

extension LinkedList {
    public func toArray() -> [Value] {
        var array = [Value]()
        
        self.forEach { (node: Node<Value>) in
            array.append(node.value)
        }
        
        return array
    }
}

final class UnitTests: XCTestCase {
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
        list.push(3)
        list.push(2)
        list.push(1)
        
        // When
        let value = list.pop()
        
        // Then
        XCTAssertEqual(value, 1)
        XCTAssertEqual(list.toArray(), [2, 3])
    }
    
    func testPopUntilEmpty() {
        // Given
        var list = LinkedList<Int>()
        list.push(3)
        list.push(2)
        list.push(1)
        
        // When
        _ = list.pop()
        _ = list.pop()
        let value = list.pop()
        
        // Then
        XCTAssertEqual(value, 3)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
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
    
    func testRemoveLastUntilEmpty() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        _ = list.removeLast()
        _ = list.removeLast()
        let value = list.removeLast()
        
        // Then
        XCTAssertEqual(value, 1)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func testRemoveAfter() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        guard let node0 = list.head else {
            XCTFail("Node at Index 0 should exist")
            return
        }
        let value = list.remove(after: node0)
        
        // Then
        XCTAssertEqual(value, 2)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssert(list.head?.nextNode === list.tail)
        XCTAssertEqual(list.tail?.value, 3)
    }
    
    func testRemoveAfterNodeBeforeTail() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        let node1 = list.insert(2, after: list.head!)
        list.insert(3, after: node1)
        
        // When
        let value = list.remove(after: node1)
        
        // Then
        XCTAssertEqual(value, 3)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
    }
    
    func testLinkedListCopyOnWriteAppend() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        
        // When
        var otherList = list
        otherList.append(3)
        
        // Then
        XCTAssertTrue(isKnownUniquelyReferenced(&list.head))
        XCTAssertNotEqual(list.toArray(), otherList.toArray())
    }
    
    func testLinkedListCopyOnWriteInsert() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(3)
        
        // When
        var otherList = list
        otherList.insert(2, after: otherList.head!)
        
        // Then
        XCTAssertTrue(isKnownUniquelyReferenced(&list.head))
        XCTAssertNotEqual(list.toArray(), otherList.toArray())
    }
    
    /*
    func testCollectionConformance() {
        // Given
        var list = LinkedList<Int>()
        
        for i in 0...9 {
            list.append(i)
        }
        
        // When
        let firstValue = list.first
        let initialValue = list[list.startIndex]
        let sumAllValues = list.reduce(0, +)
        let lastValue = list.sorted(by: >).first
        
        // Then
        XCTAssertEqual(firstValue, 0)
        XCTAssertEqual(initialValue, 0)
        XCTAssertEqual(lastValue, 9)
        XCTAssertEqual(sumAllValues, 45)
    }
     */
}

UnitTests.defaultTestSuite.run()

//: Challenges
extension LinkedList {
    func reversed() -> LinkedList<Value> {
        .init()
    }
    
    func middle() -> Node<Value>? {
        nil
    }
}

extension LinkedList where Value: Comparable {
    //Assume both list passed are sorted
    static func mergeSortedList(lhs: LinkedList<Value>,
                                rhs: LinkedList<Value>) -> LinkedList<Value> {
        .init()
    }
    
    mutating func remove(value: Value) {
    }
}

final class ChallengesTests: XCTestCase {

    // Create a function that prints out the elements of a linked list in reverse order
    func testReverseList() {
        // Given
        var list = LinkedList<Int>()
        (1...3).forEach { list.append($0) }
        
        // When
        let reversed = list.reversed()
        
        // Then
        XCTAssertEqual(reversed.toArray(),
                       [3, 2, 1])
    }

    // Create a function that returns the middle node of a linked list
    func testFindMiddle() {
        // Given
        var list = LinkedList<Int>()
        (1...3).forEach { list.append($0) }
        
        // When
        let middleNode = list.middle()
        
        // Then
        XCTAssertEqual(middleNode?.value, 2)
    }
    
    // Create a function that takes two sorted linked lists and merges them into a single sorted linked list
    func testMergeSorted() {
        // Given
        var list1 = LinkedList<Int>()
        [1,4,5].forEach { list1.append($0) }
        var list2 = LinkedList<Int>()
        [2,3].forEach { list2.append($0) }
        
        // When
        let list = LinkedList<Int>.mergeSortedList(lhs: list1, rhs: list2)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 5)
        XCTAssertEqual(list.toArray(), [1,2,3,4,5])
    }
    
    // Create a function that removes all occurrences of a specific element from a linked list
    func testRemoveOccurrences() {
        // Given
        var list = LinkedList<Int>()
        [5,5,1,5,2,5,3,5,4,5].forEach { list.append($0) }
        
        // When
        list.remove(value: 5)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 4)
        XCTAssertEqual(list.toArray(), [1, 2, 3, 4])
    }
}

ChallengesTests.defaultTestSuite.run()
