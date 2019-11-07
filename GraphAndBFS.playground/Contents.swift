import Foundation

// define EdgeTypes, directed or undirected
public enum EdgeTypes {
    case directed
    case undirected
}

//define Vertex which has a unique index within its graph and holds a piece of data
public struct Vertex<T> {
    public let index: Int
    public let data: T
}

extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable{}
extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(index): \(data)"
    }
}
    

//An Edge connects two vertices and has an optional weight
public struct Edge<T> {
    public let source: Vertex<T>
    public let destination: Vertex<T>
    public let weight: Double?
}
// Graph protocol
public protocol Graph {
    associatedtype Element
    
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>,
                         to destination: Vertex<Element>,
                         weight: Double?)
    func addUndirectedEdge(between source: Vertex<Element>,
                           and destination: Vertex<Element>,
                           weight: Double?)
    func add(_ edge: EdgeTypes, from source: Vertex<Element>,
             to destination: Vertex<Element>, weight:Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
}

//the goal is to write a function that finds the number of paths between two vertices in a graph. One solution is to perform a depth-first traversal and keep track of the visited vertices.
extension Graph where Element: Hashable {
    public func numberOfPaths(from source: Vertex<Element>,
                              to destination: Vertex<Element>) -> Int {
        var numOfPaths = 0
        var visited: Set<Vertex<Element>> = []
        paths(from: source, to: destination, visited: &visited, pathCount: &numOfPaths) //inout pass by reference
        return numOfPaths
        
    }
    func paths(from source: Vertex<Element>,
               to destination: Vertex<Element>,
               visited: inout Set<Vertex<Element>>,
               pathCount: inout Int) {
        visited.insert(source)
        if source == destination {
            pathCount += 1
        } else {
            let neighbors = edges(from: source)
            for edge in neighbors {
                if !visited.contains(edge.destination) {
                    paths(from: edge.destination, to: destination, visited: &visited, pathCount: &pathCount)
                }
            }
        }
        visited.remove(source)
    }
    
}
// use adjency list

public class AdjacencyList<T: Hashable>: Graph {
    
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    public init() {}
    
    public func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: adjacencies.count, data: data)
        adjacencies[vertex] = []
        return vertex
    }
    
    public func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        let edge = Edge(source: source,
                        destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }
    
    public func addUndirectedEdge(between source: Vertex<T>, and destination: Vertex<T>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    public func add(_ edge: EdgeTypes, from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
   
    public func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }
    
    public func weight(from source: Vertex<T>,
                       to destination: Vertex<T>) -> Double? {
        return edges(from: source)
            .first{$0.destination == destination}?
            .weight
    }
    
}

extension AdjacencyList: CustomStringConvertible {
    public var description: String {
        var result = ""
        for (vertex, edges) in adjacencies {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ]\n")
        }
        return result
    }
}

let graph = AdjacencyList<String>()
let singapore = graph.createVertex(data: "Singapore")
let tokyo = graph.createVertex(data: "Tokyo")
let hongkong = graph.createVertex(data: "Hongkong")
let detroit = graph.createVertex(data: "Detroit")
let sanFrancisco = graph.createVertex(data: "San Francisco")
let washingtonDC = graph.createVertex(data: "Washington DC")
let austinTexas = graph.createVertex(data: "Austin Texas")
let seattle = graph.createVertex(data: "Seattle")

graph.add(.undirected, from: singapore, to: hongkong, weight: 300)
graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
graph.add(.undirected, from: hongkong, to: tokyo, weight: 250)
graph.add(.undirected, from: tokyo, to: detroit, weight: 450)
graph.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
graph.add(.undirected, from: hongkong, to: sanFrancisco, weight: 600)
graph.add(.undirected, from: austinTexas, to: washingtonDC, weight: 292)
graph.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
graph.add(.undirected, from: washingtonDC, to: seattle, weight: 277)
graph.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
graph.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

//print(graph)

//find the price from Singapore to Tokyo
//print(graph.weight(from: singapore, to: tokyo))
//what are all the outgoing flights from San Francisco
//for edge in graph.edges(from: sanFrancisco) {
//    print("from: \(edge.source) to: \(edge.destination)")
//}

let graphChallenge1 = AdjacencyList<String>()
let a = graphChallenge1.createVertex(data: "A")
let b = graphChallenge1.createVertex(data: "B")
let c = graphChallenge1.createVertex(data: "C")
let d = graphChallenge1.createVertex(data: "D")
let e = graphChallenge1.createVertex(data: "E")
graphChallenge1.add(.directed, from: a, to: b, weight: nil)
graphChallenge1.add(.directed, from: a, to: c, weight: nil)
graphChallenge1.add(.directed, from: a, to: d, weight: nil)
graphChallenge1.add(.directed, from: a, to: e, weight: nil)
graphChallenge1.add(.directed, from: b, to: c, weight: nil)
graphChallenge1.add(.directed, from: b, to: d, weight: nil)
graphChallenge1.add(.directed, from: c, to: e, weight: nil)
graphChallenge1.add(.directed, from: d, to: e, weight: nil)

//print(graphChallenge1)
//print(graphChallenge1.numberOfPaths(from: a, to: e))

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



// Breadth First Search
extension Graph where Element: Hashable {
    func breadFirstSearch(from source: Vertex<Element>) -> /*[Vertex<Element>]*/ Int {
        var queue = Queue<Vertex<Element>>()
        var enqueued: Set<Vertex<Element>> = []
        var visited: [Vertex<Element>] = []
        var maxItemOnQueue = 0
        
        queue.enqueue(source)
        maxItemOnQueue = 1
        enqueued.insert(source)
        
        while let vertex = queue.dequeue() {
            visited.append(vertex)
            let neighbourEdges = edges(from: vertex)
            neighbourEdges.forEach { (edge) in
                if !enqueued.contains(edge.destination){
                    queue.enqueue(edge.destination)
                    if maxItemOnQueue < queue.count {
                        maxItemOnQueue = queue.count
                    }
                    enqueued.insert(edge.destination)
                }
            }
        }
        
        //return visited
        return maxItemOnQueue
    }
}

let bfs = AdjacencyList<String>()
let a1 = bfs.createVertex(data: "A")
let b1 = bfs.createVertex(data: "B")
let c1 = bfs.createVertex(data: "C")
let d1 = bfs.createVertex(data: "D")
let e1 = bfs.createVertex(data: "E")
let f1 = bfs.createVertex(data: "F")
let g1 = bfs.createVertex(data: "G")
let h1 = bfs.createVertex(data: "H")
let i1 = bfs.createVertex(data: "I")
let j1 = bfs.createVertex(data: "J")
bfs.add(.undirected, from: a1, to: b1, weight: nil)
bfs.add(.undirected, from: a1, to: d1, weight: nil)
bfs.add(.undirected, from: a1, to: c1, weight: nil)
bfs.add(.undirected, from: c1, to: i1, weight: nil)
bfs.add(.undirected, from: d1, to: i1, weight: nil)
bfs.add(.undirected, from: i1, to: j1, weight: nil)
bfs.add(.undirected, from: i1, to: g1, weight: nil)
bfs.add(.undirected, from: i1, to: f1, weight: nil)
bfs.add(.undirected, from: f1, to: g1, weight: nil)
bfs.add(.undirected, from: f1, to: e1, weight: nil)
bfs.add(.undirected, from: e1, to: h1, weight: nil)
bfs.breadFirstSearch(from: a1)






