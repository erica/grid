import Foundation

/// An [x,y]-indexed point using `Index` coordinates.
///
/// A `CellIndex` is always zero-based, but a custom initializer is provided to
/// allow 1-based indexing.
public struct CellIndex: Hashable, CustomStringConvertible {
    var (x, y): (Int, Int)

    public init(x : Int, y: Int) {
        (self.x, self.y) = (x, y)
    }

    public var description: String { "(\(x), \(y))" }

    // -- 1-based index utility --

    public var asOneIndexed: CellIndex { CellIndex(x: x + 1, y: y + 1) }

    public init(oneBasedX x: Int, y: Int) {
        (self.x, self.y) = (x - 1, y - 1)
    }
}

extension Grid {
    /// Return the value stored at this `CellIndex`'s zero-based x and y coordinates.
    public subscript(cellIndex: CellIndex) -> Element {
        get { self[cellIndex.x, cellIndex.y] }
        set { self[cellIndex.x, cellIndex.y] = newValue }
    }

    /// The zero-based `CellIndex` grid point for a backing array zero-based index
    public func cellIndex(of index: Int) -> CellIndex {
        CellIndex(x: index % width, y: index / width)
    }

    /// The zero-based `CellIndex` indices valid for accessing this `Grid` in ascending order
    public var cellIndices: [CellIndex] {
        backingArray.indices.map({ cellIndex(of: $0) })
    }

    /// The zero-based backing array index for a zero-based `CellIndex` grid point
    public func index(of cellIndex: CellIndex) -> Index {
        cellIndex.y * width + cellIndex.x
    }
}

