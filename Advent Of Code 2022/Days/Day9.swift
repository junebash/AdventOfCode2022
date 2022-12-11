import Parsing

struct Day9: Day {
  let dayOfMonth: Int = 9

  enum Direction: String, CaseIterable {
    case left = "L"
    case right = "R"
    case up = "U"
    case down = "D"
  }

  struct Move {
    var direction: Direction
    var distance: Int

    static func parser() -> some Parser<Substring.UTF8View, Move> {
      Parse(Move.init(direction:distance:)) {
        Direction.parser()
        Whitespace(.horizontal)
        Digits()
      }
    }
  }

  struct Point: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String { "(x: \(x), y: \(y))" }

    static let zero: Point = .init(x: 0, y: 0)

    func isNeighbor(of other: Point) -> Bool {
      abs(x - other.x) <= 1 && abs(y - other.y) <= 1
    }

    mutating func move(in direction: Direction) {
      switch direction {
      case .left:  x -= 1
      case .right: x += 1
      case .up:    y -= 1
      case .down:  y += 1
      }
    }

    mutating func move(towards other: Point) {
      guard !isNeighbor(of: other) else { return }

      switch y {
      case other.y:    break
      case ..<other.y: y += 1
      default:         y -= 1
      }

      switch x {
      case other.x:    break
      case ..<other.x: x += 1
      default:         x -= 1
      }
    }
  }

  struct Board {
    private(set) var rope: [Point]

    init(knots: Int) {
      precondition(knots >= 2)
      rope = .init(repeating: .zero, count: knots)
    }

    private var visited: Set<Point> = [.zero]

    public var visitedPoints: Int { visited.count }

    mutating func commitMove(_ move: Move) {
      for _ in 1...move.distance {
        rope[0].move(in: move.direction)
        for i in 1...(rope.count - 1) {
          rope[i].move(towards: rope[i - 1])
        }
        visited.insert(rope[rope.count - 1])
      }
    }
  }

  let inputParser: some Parser<Substring.UTF8View, [Move]> = Many {
    Move.parser()
  } separator: {
    Whitespace(1, .vertical)
  }

  func solution1() async throws -> Any {
    let moves = try inputParser.parse(input)
    var board = Board(knots: 2)
    for move in moves {
      board.commitMove(move)
    }
    return board.visitedPoints
  }

  func solution2() async throws -> Any {
    let moves = try inputParser.parse(input)
    var board = Board(knots: 10)
    for move in moves {
      board.commitMove(move)
    }
    return board.visitedPoints
  }

  let input: String = """
  L 1
  R 1
  L 1
  U 1
  D 1
  U 2
  R 2
  L 1
  D 1
  U 1
  R 1
  U 2
  R 1
  L 2
  U 2
  R 1
  U 1
  L 2
  U 2
  D 1
  U 1
  D 1
  R 2
  D 2
  R 1
  U 2
  R 2
  D 2
  L 2
  R 2
  D 1
  R 2
  D 1
  L 2
  U 1
  R 1
  L 1
  U 1
  R 1
  U 1
  R 2
  D 2
  U 1
  R 2
  U 1
  D 2
  R 1
  U 2
  L 1
  D 1
  R 1
  L 1
  R 1
  D 2
  U 1
  R 1
  U 1
  D 2
  L 2
  U 2
  R 2
  U 2
  L 1
  D 2
  U 1
  R 2
  D 2
  U 2
  R 2
  U 1
  D 1
  L 2
  D 2
  L 2
  U 2
  L 2
  U 1
  D 1
  U 2
  R 1
  D 2
  L 1
  R 1
  D 2
  U 2
  R 2
  D 2
  R 2
  D 1
  L 1
  D 1
  U 2
  D 2
  R 2
  U 2
  L 1
  U 1
  L 1
  R 2
  L 2
  D 1
  L 2
  D 2
  U 1
  R 1
  L 1
  D 1
  U 1
  R 2
  D 2
  R 1
  U 1
  R 3
  D 1
  U 3
  D 3
  U 1
  L 3
  R 3
  D 1
  L 3
  D 3
  L 2
  D 3
  R 1
  U 1
  D 3
  U 3
  D 1
  L 2
  D 1
  U 1
  D 3
  R 1
  D 1
  U 1
  D 1
  R 3
  L 1
  D 2
  R 3
  D 3
  R 1
  D 3
  R 1
  D 2
  U 1
  R 3
  L 1
  R 2
  U 1
  L 3
  D 2
  U 2
  L 1
  D 2
  L 1
  R 3
  L 3
  U 2
  R 2
  L 1
  D 1
  R 2
  D 2
  R 2
  D 3
  L 3
  U 1
  D 1
  U 1
  R 1
  D 2
  R 2
  U 2
  R 1
  D 3
  L 3
  R 1
  D 2
  L 1
  D 2
  L 3
  U 2
  L 1
  U 1
  R 2
  D 1
  R 2
  D 3
  L 1
  R 1
  D 2
  U 1
  L 1
  D 2
  R 3
  D 1
  U 1
  L 2
  U 2
  L 1
  R 2
  U 2
  R 3
  U 3
  L 1
  U 2
  L 2
  U 1
  R 1
  D 2
  U 1
  L 1
  D 2
  U 3
  L 1
  D 2
  U 1
  L 2
  D 1
  R 1
  D 1
  U 4
  L 1
  U 3
  L 2
  D 2
  U 1
  R 1
  U 3
  L 3
  D 1
  U 2
  D 4
  R 1
  L 4
  D 2
  R 4
  D 2
  U 1
  D 4
  R 2
  D 3
  U 3
  R 4
  U 1
  D 4
  R 1
  D 1
  R 1
  U 4
  L 2
  D 4
  U 1
  R 3
  D 2
  U 1
  D 4
  L 3
  D 3
  L 4
  R 4
  L 4
  U 4
  L 1
  U 2
  D 1
  R 3
  D 4
  L 4
  D 1
  R 1
  U 4
  D 4
  L 2
  R 3
  D 3
  R 4
  D 4
  R 1
  L 2
  R 1
  L 2
  D 4
  L 2
  D 1
  L 1
  R 3
  D 3
  L 4
  R 1
  L 3
  U 4
  D 1
  U 3
  R 3
  U 1
  D 2
  R 4
  D 1
  U 3
  L 2
  U 4
  D 1
  U 1
  D 2
  U 3
  R 4
  L 1
  U 1
  L 1
  D 1
  L 3
  D 3
  U 4
  D 2
  U 4
  L 3
  D 4
  L 1
  U 2
  R 4
  U 4
  R 4
  L 4
  R 1
  L 2
  R 2
  U 1
  D 3
  U 4
  L 3
  R 4
  U 4
  D 2
  L 4
  R 3
  D 4
  L 5
  U 2
  R 2
  U 2
  R 2
  L 1
  R 3
  L 4
  R 1
  D 4
  L 3
  R 1
  U 2
  L 5
  R 4
  U 3
  R 1
  D 2
  R 3
  D 4
  R 5
  U 4
  R 1
  D 4
  L 3
  R 1
  D 5
  L 5
  D 4
  R 3
  U 3
  D 3
  U 1
  R 5
  D 1
  R 5
  D 1
  L 5
  U 1
  R 5
  D 2
  U 5
  L 5
  U 2
  D 3
  L 3
  D 5
  U 3
  L 3
  R 3
  D 4
  L 1
  R 5
  U 2
  R 4
  D 2
  L 2
  R 2
  D 5
  U 3
  R 5
  U 3
  L 5
  U 2
  D 4
  U 2
  L 4
  U 3
  L 2
  U 4
  R 1
  L 2
  D 2
  R 1
  D 3
  R 3
  L 2
  U 2
  L 1
  D 2
  U 1
  L 4
  U 2
  R 4
  L 1
  R 2
  U 1
  D 4
  L 3
  R 4
  D 3
  L 3
  R 1
  D 3
  L 4
  U 3
  L 5
  R 2
  D 3
  R 4
  L 2
  R 5
  D 1
  L 5
  U 1
  L 5
  U 2
  L 5
  R 4
  U 1
  D 6
  U 6
  D 5
  R 2
  L 1
  U 3
  D 5
  R 3
  U 2
  R 4
  L 1
  D 6
  L 3
  D 1
  U 3
  L 1
  U 5
  L 2
  U 5
  L 6
  D 3
  R 2
  U 5
  D 3
  R 2
  L 6
  U 4
  L 4
  D 6
  U 5
  D 2
  L 1
  U 4
  R 6
  L 4
  D 6
  U 2
  R 1
  L 1
  R 1
  D 4
  L 6
  D 4
  U 5
  R 4
  U 6
  L 1
  U 4
  L 6
  D 3
  R 2
  D 1
  L 5
  U 3
  D 2
  U 4
  L 5
  R 3
  D 1
  U 6
  L 6
  R 1
  U 6
  D 6
  L 3
  D 6
  L 4
  D 6
  R 2
  D 3
  R 5
  L 6
  D 6
  L 5
  U 4
  D 5
  R 5
  U 5
  D 6
  L 3
  U 5
  L 6
  R 4
  U 6
  L 1
  U 6
  D 6
  R 1
  L 2
  U 6
  L 6
  D 3
  U 6
  R 1
  L 3
  D 6
  U 4
  D 4
  L 2
  R 3
  D 4
  U 3
  L 6
  R 1
  U 2
  R 3
  L 4
  R 6
  U 7
  D 7
  R 6
  U 7
  D 2
  L 7
  U 7
  D 6
  L 6
  U 1
  D 7
  R 2
  L 1
  U 3
  L 1
  R 3
  D 7
  R 5
  D 4
  L 2
  U 2
  R 2
  L 2
  R 1
  D 2
  L 3
  R 3
  U 2
  D 1
  U 4
  R 7
  D 3
  R 3
  D 6
  R 5
  D 4
  R 3
  L 2
  R 7
  L 1
  U 2
  R 6
  D 2
  L 2
  R 5
  U 4
  L 4
  U 2
  R 7
  D 1
  R 6
  D 6
  R 5
  L 5
  D 6
  U 7
  D 7
  R 1
  U 5
  L 6
  U 1
  L 1
  D 4
  U 4
  D 1
  R 4
  U 5
  L 5
  R 5
  L 6
  U 2
  D 7
  U 2
  D 1
  L 4
  D 6
  R 4
  U 2
  R 4
  D 6
  U 1
  D 2
  R 6
  L 4
  U 4
  R 2
  D 2
  L 7
  D 3
  L 2
  U 3
  R 5
  U 6
  L 6
  R 1
  L 7
  R 6
  U 3
  R 4
  U 5
  R 5
  L 1
  R 6
  U 7
  L 6
  D 7
  L 5
  D 1
  R 5
  U 5
  L 6
  D 3
  R 6
  D 3
  U 8
  R 1
  U 2
  R 7
  U 1
  L 2
  D 2
  L 7
  U 1
  L 7
  R 6
  L 1
  D 2
  R 7
  D 6
  L 3
  D 5
  L 5
  D 6
  R 5
  L 4
  D 3
  U 4
  L 5
  U 1
  R 8
  L 5
  U 6
  L 2
  U 2
  R 1
  L 8
  D 5
  U 2
  D 6
  U 7
  D 6
  L 7
  U 5
  R 5
  L 1
  R 6
  L 4
  D 1
  R 6
  L 1
  D 2
  L 4
  U 8
  D 6
  L 2
  R 6
  D 4
  L 5
  D 6
  U 8
  L 7
  U 8
  L 3
  D 3
  R 7
  L 7
  D 5
  L 1
  D 8
  R 4
  L 4
  U 1
  L 6
  U 8
  R 7
  U 6
  R 7
  D 3
  U 6
  L 3
  U 2
  D 2
  L 8
  D 2
  U 5
  D 6
  L 1
  R 8
  D 1
  L 8
  U 2
  R 6
  U 8
  R 2
  D 2
  R 7
  U 2
  D 7
  U 4
  D 1
  R 8
  U 4
  R 1
  L 7
  R 2
  L 7
  R 5
  D 2
  L 4
  U 6
  D 4
  R 1
  L 7
  U 7
  L 2
  D 2
  L 3
  D 9
  U 1
  R 7
  D 2
  L 7
  U 7
  R 7
  L 9
  R 1
  U 2
  L 5
  D 7
  U 8
  L 2
  U 2
  R 7
  D 6
  R 8
  U 1
  L 2
  R 7
  D 8
  L 4
  U 4
  R 7
  U 7
  R 8
  L 3
  D 3
  R 2
  U 6
  D 1
  U 2
  L 8
  R 6
  L 6
  D 6
  L 4
  D 7
  L 8
  R 7
  D 1
  L 6
  D 9
  L 9
  D 9
  R 4
  D 8
  U 9
  D 8
  R 2
  L 2
  U 8
  R 9
  U 5
  L 3
  D 3
  U 2
  D 4
  R 6
  L 7
  U 4
  D 5
  U 2
  L 1
  U 2
  L 5
  U 2
  L 5
  U 6
  L 7
  D 1
  L 3
  U 4
  L 5
  U 7
  R 4
  U 4
  R 9
  U 5
  R 4
  L 5
  R 1
  D 9
  U 2
  L 2
  D 1
  L 2
  U 2
  R 8
  U 6
  D 5
  L 5
  U 5
  L 6
  D 2
  L 2
  D 1
  U 2
  R 7
  L 7
  R 3
  D 7
  L 6
  U 8
  R 1
  L 1
  U 3
  D 1
  L 3
  R 8
  U 10
  D 10
  U 1
  L 1
  R 1
  U 6
  L 10
  U 9
  D 7
  L 2
  R 2
  U 4
  R 9
  U 1
  L 2
  R 8
  U 5
  L 9
  U 1
  R 2
  U 7
  L 8
  D 1
  L 10
  R 5
  U 2
  R 4
  L 3
  U 9
  L 6
  R 5
  U 8
  D 2
  R 9
  L 3
  U 1
  R 2
  D 1
  R 7
  U 7
  R 3
  U 1
  D 8
  L 3
  U 2
  R 9
  U 2
  D 4
  L 9
  R 7
  D 6
  R 1
  U 2
  R 10
  D 5
  U 2
  R 3
  L 7
  R 10
  U 5
  D 1
  R 10
  L 7
  D 3
  L 2
  D 8
  U 8
  L 5
  D 8
  L 5
  D 8
  R 10
  U 1
  L 6
  D 2
  L 10
  U 7
  R 10
  U 9
  D 1
  R 1
  D 5
  R 8
  D 5
  L 4
  R 5
  D 8
  R 7
  D 9
  U 5
  D 8
  U 5
  L 1
  R 3
  D 2
  U 5
  L 3
  R 5
  L 7
  D 3
  R 2
  U 2
  D 5
  R 9
  L 5
  D 11
  U 9
  R 1
  D 5
  R 9
  L 7
  D 7
  L 4
  R 6
  L 8
  R 9
  D 6
  U 6
  D 11
  L 1
  U 4
  R 6
  D 7
  R 5
  D 7
  U 4
  L 2
  U 8
  R 10
  L 10
  D 5
  U 10
  L 1
  R 8
  D 11
  U 9
  D 7
  U 5
  L 8
  D 7
  U 1
  D 1
  L 10
  U 2
  D 9
  L 4
  R 8
  L 8
  R 8
  L 3
  D 7
  U 5
  L 7
  D 11
  R 2
  U 10
  L 9
  D 4
  L 6
  U 10
  D 10
  R 9
  L 11
  U 11
  L 1
  D 6
  R 3
  L 2
  U 7
  L 10
  U 1
  D 1
  U 8
  R 1
  U 5
  D 8
  L 6
  R 2
  U 1
  L 10
  D 8
  U 9
  R 11
  L 10
  D 2
  U 1
  D 2
  U 3
  R 8
  L 7
  U 10
  D 9
  L 7
  U 8
  R 11
  L 9
  R 9
  L 4
  U 8
  L 5
  R 8
  U 9
  D 5
  U 10
  R 1
  D 2
  U 10
  D 4
  L 8
  D 11
  L 3
  R 10
  U 11
  D 11
  U 7
  L 2
  R 8
  D 5
  U 2
  L 10
  U 6
  R 2
  D 12
  L 10
  U 12
  R 3
  D 2
  L 5
  D 9
  R 4
  U 9
  L 3
  D 5
  U 6
  R 7
  L 10
  D 8
  R 6
  D 11
  R 5
  D 11
  U 5
  R 10
  U 11
  L 12
  U 1
  D 2
  L 9
  D 9
  R 6
  U 6
  D 1
  R 8
  L 4
  D 12
  L 6
  D 8
  L 2
  D 11
  U 8
  L 11
  R 3
  L 7
  R 9
  D 1
  L 7
  R 6
  L 7
  D 10
  U 8
  D 1
  R 6
  L 5
  R 1
  U 3
  L 6
  U 5
  R 7
  D 7
  R 10
  D 10
  R 7
  D 6
  U 5
  L 6
  D 6
  L 8
  R 8
  D 5
  L 10
  D 2
  L 3
  R 4
  L 2
  R 2
  D 5
  R 4
  D 9
  L 7
  D 1
  U 2
  L 7
  U 3
  L 12
  D 7
  R 11
  L 3
  R 7
  D 6
  R 6
  L 1
  R 3
  L 2
  U 7
  L 12
  D 1
  R 11
  U 6
  L 12
  D 11
  R 1
  L 1
  D 9
  R 8
  L 5
  U 11
  D 12
  U 1
  R 1
  U 7
  D 11
  R 2
  L 1
  D 8
  L 4
  U 8
  L 10
  R 8
  L 5
  D 8
  L 2
  U 4
  R 1
  L 7
  U 12
  D 10
  L 13
  R 2
  L 5
  U 4
  R 1
  U 3
  L 6
  D 2
  L 10
  U 10
  L 12
  D 13
  U 11
  R 1
  D 7
  L 10
  D 13
  U 12
  L 3
  D 5
  L 3
  U 11
  R 11
  D 6
  U 11
  L 10
  D 3
  R 12
  D 1
  R 2
  D 12
  L 7
  U 8
  R 10
  D 13
  U 8
  D 9
  U 6
  L 2
  D 10
  U 11
  L 4
  R 12
  U 3
  D 5
  U 4
  L 7
  U 8
  D 9
  R 8
  U 4
  L 3
  R 1
  D 7
  L 12
  R 10
  D 6
  U 3
  R 2
  U 13
  D 1
  R 2
  U 13
  L 12
  D 5
  L 9
  D 1
  L 1
  R 11
  D 7
  U 13
  D 4
  R 10
  D 7
  U 2
  D 12
  L 10
  R 3
  L 1
  U 4
  R 13
  D 9
  L 10
  D 10
  R 3
  D 3
  L 4
  R 9
  D 9
  L 9
  U 10
  R 4
  U 13
  R 3
  U 9
  R 10
  D 9
  L 8
  U 3
  L 12
  D 3
  L 7
  R 7
  L 2
  U 9
  D 8
  L 5
  D 3
  R 7
  U 3
  R 2
  U 12
  D 11
  U 7
  R 10
  U 6
  D 10
  L 1
  D 6
  U 12
  L 14
  R 1
  U 5
  D 3
  U 1
  R 5
  L 10
  D 14
  U 1
  L 5
  R 1
  L 3
  D 10
  U 1
  D 3
  L 11
  D 5
  L 3
  D 1
  L 3
  U 6
  D 10
  R 8
  U 8
  D 4
  U 6
  L 12
  R 1
  D 10
  R 13
  U 10
  D 7
  R 12
  U 7
  D 13
  L 1
  R 5
  U 3
  L 13
  R 10
  U 2
  L 10
  D 6
  L 2
  D 1
  L 1
  U 11
  R 2
  L 9
  D 9
  L 9
  U 6
  D 7
  R 1
  D 13
  R 10
  U 5
  R 9
  U 9
  D 14
  R 9
  L 5
  U 12
  D 12
  U 7
  L 6
  U 4
  R 3
  U 3
  L 3
  R 11
  L 8
  R 7
  D 8
  U 14
  D 4
  R 7
  D 9
  R 11
  U 11
  R 7
  L 9
  U 4
  R 8
  D 4
  U 1
  D 6
  L 2
  D 4
  U 3
  R 9
  D 8
  U 7
  D 9
  R 12
  U 8
  D 4
  U 9
  L 4
  D 5
  L 12
  U 14
  D 7
  R 6
  D 3
  L 6
  U 5
  D 15
  U 12
  R 2
  D 7
  U 6
  D 7
  R 15
  U 11
  L 11
  D 6
  U 3
  R 15
  U 2
  R 4
  L 5
  D 5
  U 12
  D 9
  L 12
  U 5
  L 1
  D 13
  L 13
  U 9
  D 5
  L 10
  R 12
  L 9
  R 4
  L 11
  U 2
  D 9
  L 3
  R 10
  L 2
  U 5
  D 14
  U 6
  R 13
  L 12
  D 13
  R 12
  D 6
  U 12
  D 6
  L 2
  D 4
  L 14
  D 12
  R 5
  U 2
  R 15
  U 10
  R 3
  L 6
  R 12
  L 4
  D 8
  L 10
  U 8
  R 11
  U 11
  R 6
  D 4
  U 13
  R 10
  D 13
  U 1
  R 10
  U 5
  D 5
  L 12
  D 6
  U 2
  R 9
  U 9
  R 11
  D 6
  U 5
  R 10
  U 4
  D 12
  U 7
  L 4
  U 13
  R 5
  U 10
  L 13
  D 13
  R 16
  L 11
  U 15
  L 16
  R 4
  U 9
  D 15
  R 7
  L 5
  R 16
  U 3
  L 12
  D 12
  R 16
  D 16
  U 1
  R 10
  L 6
  R 2
  U 15
  D 8
  L 15
  R 9
  U 13
  R 10
  D 10
  U 16
  L 5
  D 3
  L 9
  U 2
  R 16
  L 15
  R 11
  D 3
  U 6
  D 6
  R 14
  L 16
  U 10
  R 1
  L 13
  U 13
  D 7
  L 5
  R 15
  L 14
  U 14
  L 6
  D 3
  R 15
  D 9
  R 5
  D 8
  U 11
  L 1
  U 7
  R 7
  D 9
  R 16
  D 6
  U 6
  L 4
  U 11
  L 9
  U 14
  D 16
  L 4
  U 14
  D 8
  R 9
  D 10
  L 7
  U 12
  L 12
  D 5
  R 14
  D 9
  U 1
  D 10
  U 1
  D 13
  R 3
  L 14
  R 2
  D 2
  R 16
  U 14
  D 5
  U 14
  D 4
  L 14
  R 3
  D 3
  L 15
  D 10
  L 6
  R 12
  U 3
  R 7
  L 10
  U 13
  L 4
  U 4
  L 14
  D 11
  U 8
  D 2
  U 1
  D 14
  R 17
  L 15
  R 9
  D 17
  R 1
  U 4
  D 5
  R 8
  U 1
  L 9
  R 15
  U 15
  R 9
  U 4
  R 11
  U 5
  L 3
  U 12
  R 16
  L 3
  R 13
  L 15
  R 11
  U 3
  D 1
  R 11
  D 6
  L 16
  U 16
  R 7
  L 16
  R 13
  L 15
  U 14
  L 13
  U 11
  L 8
  R 17
  U 5
  D 3
  U 16
  D 12
  R 8
  D 6
  R 3
  L 14
  R 6
  U 10
  R 6
  L 15
  D 5
  U 8
  D 1
  L 16
  U 4
  L 2
  R 7
  U 3
  L 17
  U 12
  R 4
  U 15
  D 8
  L 10
  U 4
  L 2
  R 10
  D 9
  R 2
  U 5
  R 13
  U 10
  L 7
  R 14
  D 11
  R 5
  D 11
  L 10
  U 9
  L 12
  R 2
  D 9
  U 11
  D 9
  U 4
  L 3
  U 12
  R 13
  L 7
  R 14
  L 7
  R 14
  L 6
  R 1
  D 2
  L 4
  U 16
  L 13
  U 5
  D 1
  U 10
  R 11
  U 5
  D 16
  U 15
  R 5
  D 4
  L 12
  D 3
  R 1
  L 16
  R 7
  U 18
  D 17
  U 18
  L 6
  U 1
  D 17
  L 3
  U 5
  D 15
  L 12
  U 10
  L 15
  D 15
  L 17
  R 7
  U 5
  L 5
  D 2
  U 4
  D 2
  R 6
  U 14
  D 5
  U 13
  L 12
  R 12
  U 8
  R 18
  D 11
  L 17
  D 18
  R 9
  D 8
  L 7
  U 13
  L 7
  U 7
  L 4
  D 18
  U 14
  R 17
  L 6
  D 1
  R 16
  L 8
  U 6
  R 3
  D 11
  R 9
  L 18
  R 3
  U 15
  L 2
  R 5
  U 3
  R 18
  U 3
  D 7
  L 11
  U 10
  D 13
  R 4
  D 17
  U 18
  D 18
  L 3
  D 5
  L 8
  D 2
  R 15
  U 12
  R 8
  L 8
  U 11
  L 2
  U 6
  D 11
  U 18
  R 3
  D 6
  R 12
  D 10
  R 18
  U 8
  R 5
  U 11
  R 7
  U 11
  R 16
  D 9
  R 8
  D 15
  U 15
  L 3
  U 4
  D 15
  L 17
  R 5
  L 16
  D 16
  L 11
  R 17
  L 11
  D 16
  U 10
  D 9
  U 14
  D 13
  L 5
  D 9
  R 10
  U 9
  R 19
  U 11
  L 5
  R 13
  U 5
  D 2
  L 2
  D 12
  L 13
  U 4
  R 2
  L 8
  R 8
  L 12
  U 13
  L 13
  U 14
  L 18
  U 2
  D 1
  U 19
  D 8
  R 16
  D 3
  L 5
  D 5
  L 9
  U 13
  D 2
  U 2
  R 13
  U 3
  R 7
  L 4
  R 3
  D 4
  R 7
  D 10
  R 15
  L 1
  U 14
  L 16
  R 1
  U 6
  R 8
  D 7
  L 5
  R 7
  U 10
  L 19
  R 7
  U 9
  L 3
  D 13
  L 3
  U 12
  D 15
  L 10
  R 7
  L 3
  D 12
  R 19
  U 3
  L 15
  R 14
  D 3
  R 3
  D 11
  R 4
  L 16
  U 10
  L 7
  D 14
  U 5
  D 1
  L 14
  R 5
  L 14
  D 4
  U 19
  D 4
  U 10
  R 11
  D 18
  U 19
  D 5
  U 10
  L 16
  U 4
  L 4
  R 15
  L 3
  U 14
  R 2
  D 18
  R 1
  L 16
  D 9
  R 7
  U 17
  L 19
  U 11
  L 2
  R 4
  L 15
  D 10
  L 15
  D 11
  R 8
  """
}