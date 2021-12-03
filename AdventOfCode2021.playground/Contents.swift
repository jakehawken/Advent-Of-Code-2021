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

let allIncreases = AoCPuzzleData.depths.countIncreases()
print("1. Overall Increases: \(allIncreases)")

// Part Two ----------------
var penultimateDepth = -1
var lastDepth = -1
var threeMeasurementWindows = [Int]()

for depth in AoCPuzzleData.depths {
    if penultimateDepth > -1, lastDepth > -1 {
        threeMeasurementWindows.append(penultimateDepth + lastDepth + depth)
    }
    penultimateDepth = lastDepth
    lastDepth = depth
}

let significantIncreases = threeMeasurementWindows.countIncreases()
print("2. Significant Increases: \(significantIncreases)")


// MARK: - Day 2 --------------------------------------------------
print("\n-------------------- 🎁🎄🎅 DAY TWO 🤶🎄🎁 --------------------")

let forward = "forward"
let down = "down"
let up = "up"

var xPos = 0
var yPos = 0
var aim = 0

for instruction in AoCPuzzleData.submarineInstructions {
    let splitValue = instruction.split(separator: " ")
    guard splitValue.count == 2,
          let direction = splitValue.first,
          let distance = Int(splitValue[1]) else {
        continue
    }
    if direction == forward {
        xPos += distance
        yPos += aim * distance
    }
    if direction == down {
//        yPos += distance // Calculation for part 1
        aim += distance
    }
    if direction == up {
//        yPos -= distance // Calculation for part 1
        aim -= distance
    }
}

print("Horizonal position (\(xPos)) * Vertical Depth (\(yPos)) == \(xPos * yPos)")
