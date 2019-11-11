import Foundation

public class TreeNode<T> {
    public var value: T
    public var children: [TreeNode] = []
    
    init(_ value: T) {
        self.value = value
    }
    
    public func add(_ child: TreeNode) {
        children.append(child)
    }
}

//depth first transversal
extension TreeNode {
    public func forEachDepthFirst(visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach {
            $0.forEachDepthFirst(visit: visit)
        }
    }
}

func makeBeverageTree() -> TreeNode<String> {
    let tree = TreeNode("Beverage")
    
    let hot = TreeNode("hot")
    let cold =  TreeNode("cold")
    
    let tea = TreeNode("tea")
    let coffee = TreeNode("coffee")
    let chocolate = TreeNode("chocolate")
    
    let blackTea = TreeNode("black")
    let greenTea = TreeNode("green")
    let chiaTea = TreeNode("chai")
    
    let soda = TreeNode("soda")
    let milk = TreeNode("milk")
    
    let gingerAle = TreeNode("giner ale")
    let bitterLemon = TreeNode("bitter lemon")
    
    tree.add(hot)
    tree.add(cold)
    
    hot.add(tea)
    hot.add(coffee)
    hot.add(chocolate)
    
    cold.add(soda)
    cold.add(milk)
    
    tea.add(blackTea)
    tea.add(greenTea)
    tea.add(chiaTea)
    
    soda.add(gingerAle)
    soda.add(bitterLemon)
    
    return tree
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

extension TreeNode where T: Equatable {
    public func forEachLevelOrder(_ visit: (TreeNode) -> Void) {
        visit(self)
        var queue = Queue<TreeNode<T>>()
        children.forEach { queue.enqueue($0)}
        while let node = queue.dequeue() {
            visit(node)
            node.children.forEach { queue.enqueue($0) }
        }
    }
    
    public func search(_ value: T) -> TreeNode? {
        var result: TreeNode?
        forEachLevelOrder{ (node) in
            if node.value == value {
                result = node
            }
        }
        return result
    }
    
    public func printEachLevel<T>(for tree: TreeNode<T>) {
        var queue = Queue<TreeNode<T>>()
        var nodesLeftInCurrentLevel = 0
        
        queue.enqueue(tree)
        
        while !queue.isEmpty {
            nodesLeftInCurrentLevel = queue.count
            
            while nodesLeftInCurrentLevel > 0 {
                guard let node = queue.dequeue() else { break }
                print("\(node.value) ", terminator: "")
                node.children.forEach { queue.enqueue($0) }
                nodesLeftInCurrentLevel -= 1
            }
        }
    }
    
    
}
