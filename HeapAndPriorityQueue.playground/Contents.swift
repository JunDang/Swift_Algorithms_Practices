import Foundation


struct Heap<Element: Equatable> {
    //an array to hold the elements in the heap
    var elements: [Element] = []
    //a sort function that defines how the heap should be ordered.
    let sort: (Element, Element) -> Bool
    
    init(sort: @escaping (Element, Element) -> Bool) {
        self.sort = sort
    }
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements
        
        if !elements.isEmpty {
            for i in stride(from: elements.count / 2 - 1, to: 0, by: -1) {
                siftDown(from: i)
            }
        }
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    var peek: Element? {
        return elements.first
    }
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        return 2 * index +  1
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        return 2 * index + 2
    }
    
    func parentIndex(ofChildAt index: Int) -> Int {
        return (index - 1) / 2
    }
    
    mutating func remove() -> Element? {
        guard !isEmpty else { return nil }
        elements.swapAt(0, count - 1)
        defer {
            siftDown(from: 0)
        }
        return elements.removeLast()
    }
    // complexity O(logn)
    mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let left  = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            if left < count && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < count && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
    mutating func siftDown2(from index: Int, upTo size: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            if left < size && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < size && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
    
    
    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
        
    }
    
    mutating func siftUp(from index: Int) {
        var child = index
        var parent =  parentIndex(ofChildAt: child)
        while child > 0 && sort(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(ofChildAt: child)
        }
    }
    
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else {
            return nil
        }
        if index == elements.count - 1 {
            return elements.removeLast()
        } else {
            elements.swapAt(index, elements.count - 1)
            defer{
                siftDown(from: index)
                siftUp(from: index)
            }
        }
        return elements.removeLast()
    }
    
    mutating func index(of element: Element, startingAt i: Int) -> Int? {
        if i >= count {
            return nil
        }
        if sort(element, elements[i]) {
            return nil
        }
        if element == elements[i] {
            return i
        }
        if let j =  index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
            return j
        }
        if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
            return j
        }
        return nil
    }
    // check if is a min heap
    mutating func isMinHeap<Element: Comparable>(elements: [Element]) -> Bool {
        guard !elements.isEmpty else {
            return true
        }
        for i in stride(from: elements.count / 2 - 1, to: 0, by: -1) {
            let left = leftChildIndex(ofParentAt: i)
            let right = rightChildIndex(ofParentAt: i)
            if elements[left] < elements[i] {
                return false
            }
            if elements[right] < elements[i] {
                return false
            }
        }
        return true
    }
}

//get nth smallest element
func getNthSmallestElement(n: Int, elements: [Int]) -> Int? {
    var heap = Heap(sort: <, elements: elements)
    var current = 1
    while !heap.isEmpty {
        let element = heap.remove()
        if current == n {
            return element
        }
        current += 1
    }
    return nil
}
//HeapSort
extension Heap {
    func sorted() -> [Element] {
        var heap = Heap(sort: sort, elements: elements)
        for index in heap.elements.indices.reversed() {
            heap.elements.swapAt(0, index)
            heap.siftDown2(from: 0, upTo: index)
        }
        return heap.elements
    }
}

// Priority Queue
public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct PriorityQueue<Element: Equatable>: Queue {
    
    private var heap: Heap<Element>
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        heap = Heap(sort: sort, elements: elements)
    }
    var isEmpty: Bool {
        return heap.isEmpty
    }
    var peek: Element? {
        return heap.peek
    }
    mutating func enqueue(_ element: Element) {
        heap.insert(element)
    }
    mutating func dequeue() -> Element? {
        return heap.remove()
    }
}

struct PriorityQueueFromArray<Element: Equatable>: Queue {
    private var arr: [Element] = []
    let sort: (Element, Element) -> Bool
    
    public init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []){
        self.sort = sort
        self.arr = elements
        self.arr.sort(by: sort)
    }
    
    var isEmpty: Bool {
        return arr.isEmpty
    }
    var count: Int {
        return arr.count
    }
    var peek: Element? {
        return arr.first
    }
    mutating func enqueue(_ element: Element) {
        arr.append(element)
    }
    mutating func dequeue() -> Element? {
        return isEmpty ? nil : arr.removeFirst()
    }
}
// concert tickes sold by prioritizing someone with military background, followed by senority.
public struct Person: Equatable {
    let name: String
    let age: Int
    let isMilitary: Bool
}

func sort (person1: Person, person2: Person) -> Bool {
    if person1.isMilitary == person2.isMilitary {
        return person1.age > person2.age
    }
    return person1.isMilitary
}
