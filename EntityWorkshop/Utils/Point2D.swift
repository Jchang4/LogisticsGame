//
//  Point2D.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/30/24.
//

import Foundation

struct Point2D: Identifiable, Hashable {
    let id: String
    let row: Int
    let col: Int

    init(row: Int, col: Int) {
        self.id = "\(row), \(col)"
        self.row = row
        self.col = col
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.row)
        hasher.combine(self.col)
    }

    static func ==(lhs: Point2D, rhs: Point2D) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    static func getRandomPoints(boardSize: Int, numPoints: Int, excludedPoints: Set<Point2D> = Set()) throws -> [Point2D] {
        let totalNumTiles = Int(Double(boardSize) * Double(boardSize))
        guard numPoints <= totalNumTiles - excludedPoints.count else { throw NSError(domain: "Cannot get more points than tiles.", code: 42) }

        let allPoints: Set<Point2D> = Set(Point2D.getAllPoints(boardSize)).subtracting(excludedPoints)

        return Array(allPoints.shuffled()[0 ..< numPoints])
    }

    static func getAllPoints(_ boardSize: Int) -> [Point2D] {
        var allPoints: [Point2D] = []
        for row in 0 ..< boardSize {
            for col in 0 ..< boardSize {
                allPoints.append(Point2D(row: row, col: col))
            }
        }
        return allPoints
    }

    static func getNeighbors(for point: Point2D, boardSize: Int) -> [Point2D] {
        let directions = [
            Point2D(row: 0, col: 1),
            Point2D(row: 0, col: -1),
            Point2D(row: 1, col: 0),
            Point2D(row: -1, col: 0)
        ]

        return directions.map { Point2D(row: point.row + $0.row, col: point.col + $0.col) }
            .filter { $0.row >= 0 && $0.row < boardSize && $0.col >= 0 && $0.col < boardSize }
    }
}
