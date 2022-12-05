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
