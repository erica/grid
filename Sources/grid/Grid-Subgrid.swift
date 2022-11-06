import Foundation
import CustomSequences

extension Grid {
    /// Iterate in a grid from (startX, startY) to (width - 1, height - 1) wrapping
    /// back to startX at the end of each row. The iteration continues until the
    /// max position is reached.
    ///
    /// For example, printing out the values of a `Grid` dropping the first column,
    /// and adding space prefixes for values of a single digit:
    ///
    ///    ```
    ///    let width = 4
    ///    let grid = Grid(width: width, array: Array(1 ... 12))
    ///    grid.forEach(from: CellIndex(x: 1, y: 0)) { x, _, value in
    ///        if value < 10 { print(" ", terminator: "")}
    ///        print("\(value) ", terminator: "")
    ///        if x == grid.width - 1 { print() }
    ///    }
    ///    ```
    ///
    /// - Parameters:
    ///   - startX: the zero-indexed starting position along the x axis (columns) of the grid.
    ///   - startY: the zero-indexed starting position along the y axis (rows) of the grid.
    ///   - action: a closure to apply at each point.
    ///     - cellIndex: the current zero-indexed cell position
    ///     - value: the current value at `self[cellIndex.x, cellIndex.y]`
    ///
    /// - Warning: No bounds checks are made for index correctness.
    public func forEach(from index: CellIndex, _ action: (_ cellIndex: CellIndex, _ value: Element) -> Void) {
        for (y, x) in CartesianSequence(index.y ..< height, index.x ..< width) {
            action(CellIndex(x: x, y: y), self[x, y])
        }
    }

    /// Iterate in a grid from (startPoint.x, startPoint.y) to (endPoint.x, endPoint.y) wrapping
    /// back to startIndex.x at the end of each row. The iteration continues until
    /// endPoint is reached.
    ///
    /// - Parameters:
    ///   - startPoint: a zero-indexed point in the `Grid`
    ///   - endPoint: a zero-indexed point that is at or to the right and at or below `startPoint`
    ///   - action: a closure to apply at each point.
    ///     - cellIndex: the current zero-indexed cell position
    ///     - value: the current value at `self[cellIndex.x, cellIndex.y]`
    ///
    /// - Warning: No bounds checks are made for index correctness, positivity, order between start and end
    public func forEach(from startPoint: CellIndex,
                        to endPoint: CellIndex,
                        _ action: (_ cellIndex: CellIndex, _ value: Element) -> Void) {
        for (y, x) in CartesianSequence(startPoint.y ... endPoint.y, startPoint.x ... endPoint.x) {
            action(CellIndex(x: x, y: y), self[x, y])
        }
    }

    public func transforming<Derived>(_ action: (_ index: Index, _ value: Element) -> Derived) -> Grid<Derived> {
        var array: [Derived] = []
        for index in indices {
            array.append(action(index, self[index]))
        }
        return Grid<Derived>(width: width, array: array)
    }

    /// Copy the values in the source `grid` from (x, y) to a new `Grid` instance.
    ///
    /// - Parameter start: The bounding and inclusive top left point in the grid.
    /// - Parameter end: The bounding and inclusive bottom right point in the grid. Defaults to final point in the grid.
    ///
    /// - Returns: A new grid with the values within the bounding points.
    public func subGridFrom(_ start: CellIndex, to end: CellIndex = CellIndex(x: .max, y: .max)) -> Grid {
        precondition(start.x <= end.x && start.y <= end.y, "Start point in a subgrid cannot exceed the end point.")
        let end = CellIndex(x: Swift.min(end.x, width - 1), y: Swift.min(end.y, height - 1))
        var values: [Element] = []
        forEach(from: start, to: end) {_, value in values.append(value) }
        return Grid(width: 1 + end.x - start.x, array: values)
    }


    /// Return a new grid of zero-based row `index`, extracting a single row subgrid
    public func row(_ index: Int) -> Grid {
        subGridFrom(CellIndex(x: 0, y: index), to: CellIndex(x: width - 1, y: index))
    }

    /// Return a new grid of  zero-based column `index`, extracting a single column subgrid
    public func column(_ index: Int) -> Grid {
        subGridFrom(CellIndex(x: index, y: 0), to: CellIndex(x: index, y: height - 1))
    }

    /// Returns indices in a subgrid in row by row order
    public func indicesFrom(_ start: CellIndex, to end: CellIndex = CellIndex(x: .max, y: .max)) -> [CellIndex] {

        var adjustedEnd = end
        if adjustedEnd.x == .max || adjustedEnd.y == .max {
            adjustedEnd = CellIndex(x: width, y: height)
        }

        var indices: [CellIndex] = []
        for (x, y) in CartesianSequence(start.x ..< adjustedEnd.x, start.y ..< adjustedEnd.y) {
            indices.append(CellIndex(x: x, y: y))
        }
        return indices
    }

    /// Copy the values from the source `grid` to `self`'s storage.
    ///
    /// If the extent of `grid` exceeds the available space, the values are ignored outside
    /// of `self`'s bounds.
    ///
    /// - Parameter grid: the source `Grid`
    /// - Parameter x: the target x coordinate in `self`
    /// - Parameter y: the target y coordinate in `self`
    ///
    public mutating func copy(_ grid: Grid, to index: CellIndex) {
        guard index.x >= 0, index.y >= 0, index.x < width, index.y < height else { return }
        for xIndex in index.x ..< index.x + grid.width {
            guard xIndex < width else { continue }
            for yIndex in index.y ..< index.y + grid.height {
                guard yIndex < height else { continue }
                self[xIndex, yIndex] = grid[xIndex - index.x, yIndex - index.y]
            }
        }
    }
}
