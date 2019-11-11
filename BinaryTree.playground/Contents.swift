import Foundation

public class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
    init(_ value: Element) {
        self.value = value
    }
    

}

var tree: BinaryNode<Int> = {
    let zero = BinaryNode(0)
    let one = BinaryNode(1)
    let five = BinaryNode(5)
    let seven = BinaryNode(7)
    let eight = BinaryNode(8)
    let nine = BinaryNode(9)
    
    seven.leftChild = one
    one.leftChild = zero
    one.rightChild = five
    seven.rightChild = nine
    nine.leftChild = eight
    
    return seven
}()

extension BinaryNode {
    //in-order traversal
    public func traverseInOrder(visit: (Element) -> Void) {
        leftChild?.traverseInOrder(visit: visit)
        visit(value)
        rightChild?.traverseInOrder(visit: visit)
    }
    //pre-order traversal
    public func traversePreOrder(visit: (Element?) -> Void) {
        visit(value)
        if let leftChild = leftChild {
            leftChild.traversePostOrder(visit: visit)
        } else {
            visit(nil)
        }
        if let rightChild = rightChild {
            rightChild.traversePostOrder(visit: visit)
        } else {
            visit(nil)
        }
    }
    //post-order traversal
    public func traversePostOrder(visit: (Element) -> Void) {
        leftChild?.traversePostOrder(visit: visit)
        rightChild?.traversePostOrder(visit: visit)
        visit(value)
    }
    //find the height of binary tree
    public func height<Element>(_ tree: BinaryNode<Element>?) -> Int {
        guard tree != nil else {
            return -1
        }
        
        return 1 + max(height(leftChild), height(rightChild))
    }
    //serilization: save into array
    func serialize<T>(_ node: BinaryNode<T>) -> [T?] {
        var arr: [T?] = []
        node.traversePreOrder { arr.append($0) }
        return arr
    }
    //deserialize
    func deserialize<T>(_ array: inout [T?]) -> BinaryNode<T>? {
        guard let value = array.removeFirst() else { return nil }
        
        let node = BinaryNode(value)
        node.left = deserialize(&array)
        node.right = deserialize(&array)
        return node
    }
}


// Queue from array
public struct Queue<T> {
    
    fileprivate var arr = [T]()
    
    public var isEmpty: Bool {
        return arr.isEmpty
    }
    
    public var count: Int {
        return arr.count
    }
    
    public var peek: T? {
        return arr.first
    }
    
    public mutating func enqueue(_ element: T) {
        arr.append(element)
    }
    
    public mutating func dequeue() -> T?{
        return isEmpty ? nil : arr.removeFirst()
    }
}

