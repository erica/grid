import Foundation
import CustomSequences

// Extentions to conform the `Grid` type to `Collection` and `Sequence`,
// allowing `Grid` to inherit the behaviors defined by the protocols.

extension Grid: Collection {
    /// The collection's starting index.
    public var startIndex: Int { backingArray.startIndex }
    /// The collection's end index.
    public var endIndex: Int { backingArray.endIndex }
    /// Returns an index following the one supplied.
    public func index(after i: Int) -> Int { backingArray.index(after: i) }
    /// The indices valid for accessing this `Grid` in ascending order
    public var indices: Range<Int> { backingArray.indices }
}

extension Grid: Sequence {
    public typealias Iterator = Array<Element>.Iterator

    /// Return an iterator suitable for traversing the elements of this `Grid` collection
    public func makeIterator() -> Iterator {
        return backingArray.makeIterator()
    }
}
