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


// MARK: - Day 3 --------------------------------------------------
print("\n-------------------- 🎁🎄🎅 DAY THREE 🤶🎄🎁 --------------------")

extension Array where Element == String {
    struct BinaryDigitRatio {
        let zeroes: Int
        let ones: Int

        var mostCommon: Int {
            zeroes > ones ? 0 : 1
        }

        var leastCommon: Int {
            zeroes > ones ? 1 : 0
        }
    }

    func binaryDigitCount(forColumn column: Int) -> BinaryDigitRatio {
        guard column >= 0, column < count else {
            return BinaryDigitRatio(zeroes: 0, ones: 0)
        }
        var zeroes = 0
        var ones = 0
        for row in self {
            let index = row.index(row.startIndex, offsetBy: column)
            let digit = row[index]
            if digit == "0" {
                zeroes += 1
            }
            if digit == "1" {
                ones += 1
            }
        }
        return BinaryDigitRatio(zeroes: zeroes, ones: ones)
    }

    func binaryDigitCounts() -> [BinaryDigitRatio] {
        guard let row = first else {
            return []
        }
        return (0..<row.count).map(binaryDigitCount(forColumn:))
    }
}

let ratios = AoCPuzzleData.bitBuffers.binaryDigitCounts()

extension Array where Element == Int {
    func integerFromBinaryDigits() -> Int {
        reversed().reduce(into: (value: 0, multiplier: 1)) { partialResult, digit in
            partialResult.value += digit * partialResult.multiplier
            partialResult.multiplier *= 2
        }.value
    }
}

let gamma = ratios.map(\.mostCommon).integerFromBinaryDigits()
let epsilon = ratios.map(\.leastCommon).integerFromBinaryDigits()

print("1. Submarine power consumption: Gamma (\(gamma)) * Epsilon (\(epsilon)) == \(gamma * epsilon)")
