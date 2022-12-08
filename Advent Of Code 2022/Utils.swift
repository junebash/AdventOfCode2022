import Parsing

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

extension Sequence {
  public func count(where isContained: (Element) -> Bool) -> Int {
    var count = 0
    for element in self where isContained(element) {
      count += 1
    }
    return count
  }
}

extension Optional {
  struct UnwrapError: Error {}

  public func orThrow() throws -> Wrapped {
    guard let value = self else { throw UnwrapError() }
    return value
  }
}

enum Either<A, B> {
  case a(A)
  case b(B)
}

extension Either: IteratorProtocol where A: IteratorProtocol, B: IteratorProtocol, A.Element == B.Element {
  typealias Element = A.Element

  mutating func next() -> Element? {
    switch self {
    case .a(var a):
      let value = a.next()
      self = .a(a)
      return value
    case .b(var b):
      let value = b.next()
      self = .b(b)
      return value
    }
  }
}

extension Either: Sequence where A: Sequence, B: Sequence, A.Element == B.Element {
  func makeIterator() -> Either<A.Iterator, B.Iterator> {
    switch self {
    case .a(let a): return .a(a.makeIterator())
    case .b(let b): return .b(b.makeIterator())
    }
  }
}

struct PrefixUpToNewLineOrEnd: Parser {
  func parse(_ input: inout Substring) -> Substring {
    let output = input.prefix(while: { $0 != "\n" })
    input.removeFirst(output.count)
    return output
  }
}
