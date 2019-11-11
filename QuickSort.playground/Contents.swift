import Foundation

func QuickSort(_ arr: [Int]) -> [Int] {
    let pivot = arr[arr.count / 2 - 1]
    let left = arr.filter{ $0 < pivot }
    let equal = arr.filter{ $0 == pivot }
    let right = arr.filter { $0 > pivot }
    return QuickSort(left) + equal + QuickSort(right)
}

//merge sort is preferable over quick sort based on stability. Merge sort is a stable sort and guarantees O(nlogn). This is not the case with quick sort, which isn't stable and can perform as bad as O(n2)
//Merge sort works better for larger data structures or data structures where elements are scattered throughout memorty. quicksort works best when elements are stored in continuous block.
