//Merge sort
func mergeSort(_ arr: [Int]) -> [Int] {
    guard arr.count > 1 else {
        return arr
    }
    let mid = arr.count / 2
    let left = mergeSort(Array(arr[0..<mid]))
    let right = mergeSort(Array(arr[mid...]))
    return merge(left, right)
}

func merge(_ left: [Int], _ right: [Int]) -> [Int]{
    var result: [Int] = []
    var leftIndex = 0
    var rightIndex = 0
   
    while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]
        if leftElement < rightElement {
            result.append(leftElement)
            leftIndex += 1
        } else if leftElement > rightElement {
            result.append(rightElement)
            rightIndex += 1
        } else {
            result.append(leftElement)
            leftIndex += 1
            result.append(rightElement)
            rightIndex += 1
        }
    }
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }
    return result
}

print(mergeSort([2, 1, 4, 7, 3, 9, 5, 8]))
