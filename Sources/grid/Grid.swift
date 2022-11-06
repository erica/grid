import Foundation

/// An array-backed 2-D storage instance that can be accessed using mathematical/geometric (x, y) indexing.
public struct Grid <Element> {

    // -- Array intrinsics --
    
    /// Private backing array for the grid
    internal var _gridArray: [Element]

    /// The width and height of the grid, which is critical for allowing (x,y) addressing.
    /// Although technically the height is not needed, as the extent can be divided by
    /// the width, the sheer utility of having it readily available is worth keeping, as is
    /// the simplicity of instantiating new grids with an initial element.
    public let (width, height): (Int, Int)

    /// The grid's public backing array, a simple array of potentially modifiable elements
    public var backingArray: [Element] { _gridArray }

    // -- Subscripting --

    /// Index the backing array using zero-based x and y coordinates.
    ///
    /// -- Note: Deliberately designed to use geometric (x, y) indexing rather than
    ///     computer-based (y, x) indexing. One-based coordinates were considered
    ///     for the design but rejected. If you want to use one-based indexing, use
    ///     `CellIndex` subscripting with the `init(oneBasedX:, y:)` initializer
    public subscript(_ x: Int, _ y: Int) -> Element {
        get { _gridArray[y * width + x] }
        set { _gridArray[y * width + x] = newValue }
    }

    /// A subscript that directly indexes the backing array with an integer subscript.
    ///
    /// Rows wrap from one to the next, following the flat array layout
    public subscript(_ idx: Int) -> Element {
        get { _gridArray[idx] }
        set { _gridArray[idx] = newValue }
    }

    /// The backing array index for a grid point
    public func index(of x: Int, _ y: Int) -> Int {
        y * width + x
    }

    // -- Instantiation --

    /// Create a new `Grid` instance using the supplied initial value
    public init(width: Int, height: Int, initialValue: Element) {
        (self.width, self.height) = (width, height)
        self._gridArray = Array<Element>.init(repeating: initialValue, count: width * height)
    }

    /// Create a new `Grid` instance using the supplied backing array as its initial storage
    public init(width: Int, array: [Element]) {
        (self.width, height) = (width, array.count / width)
        self._gridArray = array
    }
}
