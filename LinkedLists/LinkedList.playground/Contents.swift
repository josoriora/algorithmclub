import XCTest

public struct LinkedList<Value> {
    public final class Node<Value> {
        let value: Value
        var nextNode: Node<Value>?
        
        init(value: Value, nextNode: Node<Value>? = nil) {
            self.value = value
            self.nextNode = nextNode
        }
        
        deinit {
            print("deinit: \(self.value)")
        }
    }
    
    public var isEmpty: Bool { self.head == nil }
    
    public var description: String {
        if !self.isEmpty {
            var descriptionString = ""
            
            forEach { (node: Node<Value>) in
                descriptionString += "\(node.value) -> "
            }
            
            descriptionString += "nil"
            return descriptionString
        } else {
            return "Empty List"
        }
    }
    
    public private(set) var count: Int = 0
    
    internal var head: Node<Value>?
    
    internal var tail: Node<Value>?
    
    init(array: [Value]) {
        array.forEach { (value: Value) in
            self.append(value)
        }
    }
    
    public mutating func append(_ value: Value) {
        print("----- append ----------")
        
        guard let tail = self.tail else {
            self.push(value)
            return
        }
        
        tail.nextNode = Node(value: value)
        self.tail = tail.nextNode
        count += 1
    }
        
    public mutating func push(_ value: Value) {
        print("----- push ----------")
        let newNode = Node(value: value, nextNode: self.head)
        
        self.head = newNode
        
        if self.tail == nil {
            self.tail = self.head
        }
        
        count += 1
    }
    
    public mutating func pop() -> Value? {
        print("----- pop ----------")
        defer {
            self.head = self.head?.nextNode
            count -= 1
            
            if isEmpty {
                self.tail = nil
            }
        }
        
        return self.head?.value
    }
    
    public mutating func removeLast() -> Value? {
        print("----- remove last ----------")
        
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
        
        return tailValue
    }
    
    public func node(at index: Int) -> Node<Value>? {
        print("------ node at ---------")
        guard index < count else {
            print("out of bounds")
            return nil
        }
        
        
        var nodeAtIndex: Node<Value>? = nil
        var currentIndex = 0
        
        forEachWhile { (node: Node<Value>) -> (Bool) in
            if currentIndex <= index {
                nodeAtIndex = node
                currentIndex += 1
                
                return true
            } else {
                return false
            }
        }
        
        return nodeAtIndex
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

//    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {

    
    
    //    public mutating func remove(after node: Node<Value>) -> Value? {}
}

extension LinkedList {
    public func toArray() -> [Value] {
        var array = [Value]()
        
        var node = self.head
        
        print("to array")
        print("head: \(node?.value)")
        
        while node != nil {
            if let value = node?.value {
                array.append(value)
                print("append \(value)")
            }
            
            node = node?.nextNode
            
            print("next node: \(node?.value)")
        }
        
        print("-----------------------------")
        
        return array
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Value
    
    public init(arrayLiteral elements: Value...) {
        self.init(array: elements)
    }
}

class LinkedListTests: XCTestCase {
    
    func testDescription() {
        // Given
        var list = LinkedList<Int>()
        
        // Then
        XCTAssertEqual(list.description, "Empty List")
        
        // When
        list.append(1)
        list.append(2)
        list.append(3)
        
        // Then
        XCTAssertEqual(list.description, "1 -> 2 -> 3 -> nil")
    }
    
    func testPush() {
        // Given
        var list = LinkedList<Int>()
        
        // When
        list.push(3)
        list.push(2)
        list.push(1)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 3)
        XCTAssertEqual(list.count, 3)
    }
    
    func testAppend() {
        // Given
        var list = LinkedList<Int>()
        
        // When
        list.append(1)
        list.append(2)
        list.append(3)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 3)
        XCTAssertEqual(list.count, 3)
    }
    
    func testNodeAt() {
        // Given
        let list: LinkedList<Int> = [1,2,3]
        
        // When
        guard let node0 = list.node(at: 0) else {
            XCTFail("Node at Index 0 should exist")
            return
        }
        
        // Then
        XCTAssert(list.head === node0)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(node0.value, 1)
    }

    
}

LinkedListTests.defaultTestSuite.run()
