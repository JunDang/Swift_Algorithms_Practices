import Foundation

public class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
    init(_ value: Element) {
        self.value = value
    }
}

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
}
    

public struct BinarySearchTree<Element: Comparable> {
    public private(set) var root: BinaryNode<Element>?
    
    public init() {}
}


extension BinarySearchTree {
    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
    private func insert(from node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>{
        guard let node = node else {
            return BinaryNode(value)
        }
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        return node
    }
    //O(N)
    public func contains(_ value: Element) -> Bool {
        guard let root = root else {
            return false
        }
        var found = false
        root.traverseInOrder {
            if $0 == value {
              found = true
            }
        }
        return found
    }
    //O(logN)
    public func cotains2(_ value: Element) -> Bool {
        var current = root
        while let node = current {
            if node.value == value {
                return true
            }
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return false
    }
}

extension BinaryNode {
    var min: BinaryNode {
        return leftChild?.min ?? self
    }
}

extension BinarySearchTree {
    public mutating func remove(_ value: Element) {
        
    }
    private func remove(node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>? {
        guard let node = node else {
            return nil
        }
        if value == node.value {
            if node.leftChild == nil && node.rightChild == nil {
                return nil
            }
            if node.leftChild == nil {
                return node.rightChild
            }
            if node.rightChild == nil {
                return node.leftChild
            }
            node.value = node.rightChild!.min.value
            node.rightChild = remove(node: node.rightChild, value: node.value)
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        return node
    }
}

extension BinaryNode where Element: Comparable {
    
    var isBinarySearchTree: Bool {
        return isBST(self, min: nil, max: nil)
    }
    private func isBST(_ tree: BinaryNode<Element>?, min: Element?, max: Element?) -> Bool {
        guard let tree = tree else {
            return true
        }
        
        if let min = min, tree.value <= min {
            return false
        }
        
        if let max = max, tree.value >= max {
            return false
        }
        
        return isBST(tree.leftChild, min: min, max: tree.value) && isBST(tree.rightChild, min: tree.value, max: max)
    }
}

extension BinarySearchTree: Equatable {
    //O(n)
    public static func == (lhs: BinarySearchTree,
                           rhs: BinarySearchTree) -> Bool {
        return isEqual(lhs.root, rhs.root)
    }
    
    private static func isEqual<Element: Equatable>(
        _ node1: BinaryNode<Element>?,
        _ node2: BinaryNode<Element>?) -> Bool {
        guard let leftNode = node1, let rightNode = node2 else {
            return node1 == nil && node2 == nil
        }
        return leftNode.value == rightNode.value &&
               isEqual(leftNode.leftChild, rightNode.leftChild) &&
               isEqual(leftNode.rightChild, rightNode.rightChild)
    }
}

extension BinarySearchTree where Element: Hashable {
    //check if current tree contains all the elements of another tree
    public func contains(_ subtree: BinarySearchTree) -> Bool {
        
        var set: Set<Element> = []
        root?.traverseInOrder {
            set.insert($0)
        }
        
        var isEqual =  true
        subtree.root?.traverseInOrder {
            isEqual = isEqual && set.contains($0)
        }
        return isEqual
    }
}
