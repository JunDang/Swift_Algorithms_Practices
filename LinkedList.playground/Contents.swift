import Foundation

public class Node<T> {
    public var value: T
    public var next: Node?
    
    public init(_ value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

public struct LinkedList<T> {
    public var head: Node<T>?
    public var tail: Node<T>?
    
    public init() { }
    public var isEmpty: Bool {
        return head == nil
    }
    
    public mutating func push(_ value: T) {
        head = Node(value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    public mutating func append(_ value: T) {
        guard !isEmpty else {
            push(value)
            return
        }
        tail = Node(value)
        tail = tail!.next
    }
    
    public func node(at index: Int) -> Node<T>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        return currentNode
    }
    
    @discardableResult
    public mutating func insert(_ value: T,
                                after node: Node<T>) -> Node<T>{
        guard tail !== node else {
            append(value)
            return tail!
        }
        node.next = Node(value, next: node.next)
        return node.next!
    }
    
    @discardableResult
    public mutating func pop() -> T? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> T? {
        guard let head = head else {
            return nil
        }
        
        guard head.next != nil else {
            return pop()
        }
        var prev =  head
        var current = head
        while let next =  current.next {
            prev = current
            current =  next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    @discardableResult
    public mutating func remove(after node: Node<T>) -> T? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
    
    private mutating func copyNodes() {
        guard var oldNode = head else {
            return
        }
        head = Node(oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(nextOldNode.value)
            newNode = newNode!.next
            
            oldNode = nextOldNode
        }
        tail = newNode
    }
    
    // print linkedlist in reverse order
    private func printInReverse<T>(_ node: Node<T>?) {
        guard let node = node else { return }
        printInReverse(node.next)
        print(node.value)
    }
    
    // get middle element of a list
    func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
        var slow = list.head
        var fast = list.head
        
        while let nextFast = fast!.next {
            fast = nextFast.next
            slow = slow?.next
        }
        return slow
    }
    // tell if there is circle in linkedlist
    func hasCycle(_ list: LinkedList<T>) -> Bool {
        var slow = head
        var fast = head
        while let nextFast = fast!.next {
            fast = nextFast.next
            slow = slow?.next
            if slow === fast {
                return true
            }
        }
        return false
    }
    //reverse a linked list O(n)
    mutating func reverse() {
        var tempList = LinkedList<T>()
        for value in self {
            tempList.push(value)
        }
        head = tempList.head
    }
    // there is a significant resource cost in the previous solution. reverse will have to allocate new nodes for each push mtehod on the tempory list
    mutating func reverse2() {
        tail = head
        var prev = head
        var current = head?.next
        prev?.next =  nil
        while current != nil {
            let next = current?.next
            current?.next = prev
            prev = current
            current =  next
        }
        head = prev
    }
}


extension LinkedList: Collection {
    public subscript(position: Index) -> T{
          return position.node!.value
    }
    
    
    public var startIndex: Index {
        return Index(node: head)
    }
    
    public var endIndex:Index {
        return Index(node: tail?.next)
    }
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    
    public struct Index: Comparable {
        public var node: Node<T>?
        
        static public func == (lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func < (lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains{ $0 === rhs.node}
        }
    }
}


