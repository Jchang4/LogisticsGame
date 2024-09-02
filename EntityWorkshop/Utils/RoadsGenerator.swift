//
//  RoadsGenerator.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import Foundation

class RoadGenerator {
    static func getRoadPoints(warehousePoints: [Point2D], buildingPoints: [Point2D]) throws -> Set<Point2D> {
        var roadPoints: Set<Point2D> = Set()

        // Connect warehouse to all buildings
        let excludedPoints = Set(buildingPoints)
        for warehousePoint in warehousePoints {
            for buildingPoint in buildingPoints {
                let pathPoints = RoadGenerator.getPath(
                    from: warehousePoint,
                    to: buildingPoint,
                    boardSize: GlobalGameState.shared.boardSize,
                    excludedPoints: excludedPoints,
                    existingRoadPoints: roadPoints
                )
                guard pathPoints.count > 0 else {
                    throw NSError(domain: "The building placements prevent a road from connecting all points. Map is bad.", code: 42)
                }
                roadPoints.formUnion(pathPoints)
                // NOTE: must subtract within loop to prevent using this tile
                // for other paths
                roadPoints.subtract([buildingPoint])
            }
        }

        return roadPoints
    }

    static func getPath(
        from: Point2D,
        to: Point2D,
        boardSize: Int,
        excludedPoints: Set<Point2D>,
        existingRoadPoints: Set<Point2D>
    ) -> [Point2D] {
        return PathfindingHelpers.bfs(
            boardSize: boardSize,
            from: from,
            to: to,
            excludedPoints: excludedPoints,
            preferredPoints: existingRoadPoints
        )
    }
}

class PathfindingHelpers {
    static func bfs(
        boardSize: Int,
        from startPoint: Point2D,
        to endPoint: Point2D,
        excludedPoints: Set<Point2D>,
        preferredPoints: Set<Point2D>
    ) -> [Point2D] {
        // Tuple of: curr_point, path
        var queue: [(Point2D, [Point2D])] = [(startPoint, [startPoint])]
        var visited: Set<Point2D> = [startPoint]

        while !queue.isEmpty {
            let (currentPoint, path) = queue.removeFirst()

            // If we reached the end, return the path
            if currentPoint == endPoint {
                return path
            }

            // Explore neighbors
            let neighbors = Point2D.getNeighbors(for: currentPoint, boardSize: boardSize)
                .filter { $0 == startPoint || $0 == endPoint || !excludedPoints.contains($0) }
                .sorted { pointA, _ in
                    preferredPoints.contains(pointA)
                }

            for neighbor in neighbors {
                if !visited.contains(neighbor) {
                    visited.insert(neighbor)
                    var newPath = path
                    newPath.append(neighbor)
                    queue.append((neighbor, newPath))
                }
            }
        }

        return []
    }
}
