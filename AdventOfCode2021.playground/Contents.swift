import UIKit
import Foundation

// MARK: - Day 1 --------------------------------------------------
print("---------- 🎁🎄🎅 DAY ONE 🤶🎄🎁 ----------")

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
print("\n---------- 🎁🎄🎅 DAY TWO 🤶🎄🎁 ----------")

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
print("\n--------- 🎁🎄🎅 DAY THREE 🤶🎄🎁 ---------")

// Part One ----------------
struct BitRatio {
    let zeroes: Int
    let ones: Int

    var mostCommon: Int {
        zeroes > ones ? 0 : 1
    }

    var leastCommon: Int {
        zeroes < ones ? 0 : 1
    }
}

extension Array where Element == [Int] {
    func binaryDigitCount(forColumn column: Int) -> BitRatio {
        guard column >= 0, column < count else {
            return BitRatio(zeroes: 0, ones: 0)
        }
        var zeroes = 0
        var ones = 0
        for row in self {
            let digit = row[column]
            if digit == 0 {
                zeroes += 1
            }
            if digit == 1 {
                ones += 1
            }
        }
        return BitRatio(zeroes: zeroes, ones: ones)
    }

    func binaryDigitCounts() -> [BitRatio] {
        let width = first?.count ?? 0
        return (0..<width).map(binaryDigitCount(forColumn:))
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

print("1. Power consumption: Gamma (\(gamma)) * Epsilon (\(epsilon)) == \(gamma * epsilon)")

// Part Two ----------------
extension Array where Element == [Int] {
    func filterBitBuffers(bitRatios: [BitRatio], shouldKeepBuffer: (Int, BitRatio) -> Bool) -> [[Int]] {
        guard let width = first?.count, width == bitRatios.count else {
            return []
        }

        var output = self
        for column in 0..<width {  // iterating left to right through the columns
            let ratioForColumn = bitRatios[column]
            output = output.filter { bitBuffer in // iterating top to bottom through the rows
                let bit = bitBuffer[column]
                let shouldKeep = shouldKeepBuffer(bit, ratioForColumn)
//                print("Column: \(column), Bit: \(bit), Zero count: \(ratioForColumn.zeroes), One count: \(ratioForColumn.ones), Should Keep: \(shouldKeep)")
                return shouldKeep
            }
//            print("Remaining items: \(output.count)")
            if output.count == 1 {
                break
            }
        }

//        print("Oxygen rating buffers: \(output) -- First, in decimal: \(output.first!.integerFromBinaryDigits())")
        return output
    }
}

enum LifeSupportError: String, Error, CustomStringConvertible {
    case couldntFindOxygenRating = "!--- Couldn't find the oxygen rating. ---!"
    case couldntFindScrubberRating = "!--- Couldn't find the CO2 scrubber rating. ---!"
    var description: String { return rawValue }
}

let filteredOxygenBuffers = AoCPuzzleData.bitBuffers.filterBitBuffers(bitRatios: ratios) { bit, ratio -> Bool in
    if ratio.zeroes == ratio.ones {
        print("Zero count: \(ratio.zeroes), One count: \(ratio.ones)")
    }
    return (ratio.zeroes == ratio.ones) ? (bit == 1) : (bit == ratio.mostCommon)
}
guard filteredOxygenBuffers.count == 1,
      let oxygenRating = filteredOxygenBuffers.first?.integerFromBinaryDigits() else {
          print("Remaining Oxygen Buffers: \(filteredOxygenBuffers)")
          throw LifeSupportError.couldntFindOxygenRating
}

let filteredScrubberBuffers = AoCPuzzleData.bitBuffers.filterBitBuffers(bitRatios: ratios) { bit, ratio -> Bool in
    if ratio.zeroes == ratio.ones {
        print("Zero count: \(ratio.zeroes), One count: \(ratio.ones)")
    }
    return (ratio.zeroes == ratio.ones) ? (bit == 0) : (bit == ratio.leastCommon)
}
guard filteredScrubberBuffers.count == 1,
      let c02ScrubberRating = filteredScrubberBuffers.first?.integerFromBinaryDigits() else {
    throw LifeSupportError.couldntFindScrubberRating
}

print("2. Life support rating: Oxygen Generator Rating (\(oxygenRating)) * C02 Scrubber Rating (\(c02ScrubberRating)) == \(oxygenRating * c02ScrubberRating)")
