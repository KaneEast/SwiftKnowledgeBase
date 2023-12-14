import Foundation

let input = [[1,2], [2,3], [3,4]]

func solution(_ intervals: [[Int]]) -> [[Int]] {
  var resultArray = [[Int]]()
  
  var iteratingIndex = 0
  
  for (index, value) in intervals.enumerated() {
    if index < iteratingIndex {
      continue
    }
    var currentRange = intervals[iteratingIndex]
    
    let v1 = intervals[iteratingIndex].first ?? 0
    let v2 = intervals[iteratingIndex].last ?? 0
    let v3 = intervals[iteratingIndex+1].first ?? 0
    let v4 = intervals[iteratingIndex+1].last ?? 0
    // [v1, v2], [v3, v4]
    if v2 >= v3 {
      currentRange = [v1, v4]
      iteratingIndex += 2
    } else {
      print(1)
      // append to result
      resultArray.append(currentRange)
      iteratingIndex += 1
    }
    if iteratingIndex >= intervals.count - 1 {
      break
    }
    
  }
  return resultArray
}

print(solution(input))
