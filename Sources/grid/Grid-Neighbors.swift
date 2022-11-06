import Foundation
import CustomSequences

// The neighboring cells around a grid

extension Grid {
    /// Returns the indices of the available grid cells surrounding a given point along its edges.
    ///
    /// Indices of elements falling outside the `Grid` grid are omitted.
    ///
    /// - Note: Edge neighbors do not include diagonals
    public func edgeNeighborIndices(of index: CellIndex) -> [CellIndex] {
        [CellIndex(x: index.x - 1, y: index.y),
         CellIndex(x: index.x + 1, y: index.y),
         CellIndex(x: index.x, y: index.y - 1),
         CellIndex(x: index.x, y: index.y + 1)]
            .filter({ neighbor in
                neighbor.x >= 0 && neighbor.y >= 0 && neighbor.x < width && neighbor.y < height })
    }

    /// Returns the indices of the diagonal grid cells surrounding a given point along its edges.
    ///
    /// Indices of elements falling outside the `Grid` grid are omitted.
    public func cornerNeighborIndices(of index: CellIndex) -> [CellIndex] {
        [CellIndex(x: index.x - 1, y: index.y - 1),
         CellIndex(x: index.x + 1, y: index.y + 1),
         CellIndex(x: index.x + 1, y: index.y - 1),
         CellIndex(x: index.x - 1, y: index.y + 1)]
            .filter({ neighbor in
                neighbor.x >= 0 && neighbor.y >= 0 && neighbor.x < width && neighbor.y < height })
    }

    /// Returns all the indices of the available grid cells surrounding a given point.
    ///
    /// Indices of elements falling outside the `Grid` grid are omitted.
    public func neighborIndices(of index: CellIndex) -> [CellIndex] {
        var results: [CellIndex] = []
        for xOffset in -1 ... 1 {
            for yOffset in -1 ... 1 {
                if (xOffset == 0) && (yOffset == 0) { continue }
                if (index.x + xOffset) < 0 || (index.x + xOffset) >= width { continue }
                if (index.y + yOffset) < 0 || (index.y + yOffset) >= height { continue }
                results.append(CellIndex(x: index.x + xOffset, y: index.y + yOffset))
            }
        }
        return results
    }
}
