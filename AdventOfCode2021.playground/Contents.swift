import UIKit

// MARK: - Day 1 --------------------------------------------------
print("-------------------- 🎁🎄🎅 DAY ONE 🤶🎄🎁 --------------------")

// Part One ----------------
extension Array where Element == Int {
    func countIncreases(minimumValue: Int = 0) -> Int {
        var depthIncreaseCount = 0
        var lastDepth = minimumValue - 1
        for depth in self {
            if lastDepth > -1, depth > lastDepth {
                depthIncreaseCount +=  1
            }
            lastDepth = depth
        }
        return depthIncreaseCount
    }
}

let allIncreases = depths.countIncreases()
print("1. Overall Increases: \(allIncreases)")

// Part Two ----------------
var penultimateDepth = -1
var lastDepth = -1
var threeMeasurementWindows = [Int]()

for depth in depths {
    if penultimateDepth > -1, lastDepth > -1 {
        threeMeasurementWindows.append(penultimateDepth + lastDepth + depth)
    }
    penultimateDepth = lastDepth
    lastDepth = depth
}

let significantIncreases = threeMeasurementWindows.countIncreases()
print("2. Significant Increases: \(significantIncreases)")

