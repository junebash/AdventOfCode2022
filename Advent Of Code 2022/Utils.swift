public struct SimpleError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String = ""

    public init(_ description: String) {
        self.description = description
    }

    public var localizedDescription: String {
        description
    }

    public var debugDescription: String {
        description
    }
}
