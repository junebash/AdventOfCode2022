import Parsing
import CustomDump

struct Day5: Day {
  let dayOfMonth: Int = 5

  struct Stacks {
    enum Failure: Error {
      case noRows
      case rowCountDoesNotMatch(rows: [[Character?]])
      case badInstruction(Instruction, Stacks)
    }

    var rawValue: [[Character]]

    var topsOfEachStack: String {
      String(rawValue.compactMap(\.last))
    }

    init(_ rawValue: [[Character]]) {
      self.rawValue = rawValue
    }

    init(rows: [[Character?]]) throws {
      let rows = rows.dropLast()
      guard let stackCount = rows.first?.count else { throw Failure.noRows }

      var stacks: [[Character]] = Array(repeating: [], count: stackCount)

      for row in rows.reversed() {
        guard row.count == stackCount else { throw Failure.rowCountDoesNotMatch(rows: Array(rows)) }
        for (i, character) in row.enumerated() {
          if let character {
            stacks[i].append(character)
          }
        }
      }
      self.rawValue = stacks
    }

    mutating func execute(_ instruction: Instruction) throws {
      try assertInstructionIsValid(instruction)

      var count = instruction.move
      while count > 0 {
        let char = rawValue[instruction.from - 1].removeLast()
        rawValue[instruction.to - 1].append(char)
        count -= 1
      }
    }

    mutating func execute2(_ instruction: Instruction) throws {
      try assertInstructionIsValid(instruction)

      let toMove = rawValue[instruction.from - 1].suffix(instruction.move)
      rawValue[instruction.from - 1].removeLast(instruction.move)
      rawValue[instruction.to - 1].append(contentsOf: toMove)
    }

    private func assertInstructionIsValid(_ instruction: Instruction) throws {
      guard
        instruction.from <= rawValue.endIndex,
        instruction.to <= rawValue.endIndex,
        rawValue[instruction.from - 1].count >= instruction.move
      else {
        throw Failure.badInstruction(instruction, self)
      }
    }
  }

  struct Instruction {
    let move: Int
    let from: Int
    let to: Int
  }

  private func parseStacksAndInstructions() throws -> (stacks: Stacks, instructions: [Instruction]) {
    let charParser = OneOf {
      Parse(Character?.some) {
        "["
        First()
        "]"
      }

      Whitespace(3, .horizontal)
        .map { _ in Character?.none }
    }

    let rowParser = Many {
      charParser
    } separator: {
      Whitespace(1, .horizontal)
    }

    let rowsParser = Parse {
      Many {
        rowParser
      } separator: {
        Whitespace(1, .vertical)
      }

      Skip {
        Many {
          Digits()
        } separator: {
          Whitespace(.horizontal)
        }
      }
    }

    let instructionsParser = Many {
      Parse(Instruction.init) {
        "move "
        Digits()
        " from "
        Digits()
        " to "
        Digits()
      }
    } separator: {
      Whitespace(1, .vertical)
    }

    let inputParser = Parse {
      rowsParser
      Whitespace(.vertical)
      instructionsParser
    }

    let (rows, instructions) = try inputParser.parse(input)
    let stacks = try Stacks(rows: rows)
    return (stacks, instructions)
  }

  func solution1() async throws -> Any {
    let result = try parseStacksAndInstructions()
    var stacks = result.stacks

    for instruction in result.instructions {
      try stacks.execute(instruction)
    }

    return stacks.topsOfEachStack
  }

  func solution2() async throws -> Any {
    let result = try parseStacksAndInstructions()
    var stacks = result.stacks

    for instruction in result.instructions {
      try stacks.execute2(instruction)
    }

    return stacks.topsOfEachStack
  }

  let input: String = """
    [V]     [B]                     [C]
    [C]     [N] [G]         [W]     [P]
    [W]     [C] [Q] [S]     [C]     [M]
    [L]     [W] [B] [Z]     [F] [S] [V]
    [R]     [G] [H] [F] [P] [V] [M] [T]
    [M] [L] [R] [D] [L] [N] [P] [D] [W]
    [F] [Q] [S] [C] [G] [G] [Z] [P] [N]
    [Q] [D] [P] [L] [V] [D] [D] [C] [Z]
    1   2   3   4   5   6   7   8   9

    move 1 from 9 to 2
    move 4 from 6 to 1
    move 4 from 2 to 6
    move 5 from 8 to 7
    move 4 from 9 to 2
    move 1 from 5 to 8
    move 1 from 3 to 1
    move 2 from 3 to 1
    move 1 from 4 to 2
    move 11 from 7 to 2
    move 5 from 5 to 1
    move 1 from 6 to 8
    move 1 from 7 to 6
    move 3 from 6 to 7
    move 1 from 3 to 2
    move 1 from 6 to 8
    move 11 from 2 to 1
    move 1 from 9 to 8
    move 1 from 3 to 7
    move 4 from 7 to 9
    move 3 from 3 to 7
    move 4 from 8 to 2
    move 3 from 7 to 6
    move 2 from 6 to 3
    move 5 from 4 to 1
    move 1 from 6 to 5
    move 26 from 1 to 7
    move 1 from 4 to 6
    move 22 from 7 to 5
    move 4 from 9 to 1
    move 3 from 7 to 3
    move 1 from 6 to 3
    move 6 from 1 to 7
    move 2 from 7 to 5
    move 8 from 1 to 9
    move 4 from 3 to 4
    move 10 from 2 to 7
    move 6 from 7 to 4
    move 2 from 9 to 5
    move 1 from 5 to 1
    move 8 from 4 to 1
    move 2 from 5 to 9
    move 1 from 3 to 6
    move 1 from 9 to 1
    move 1 from 3 to 6
    move 2 from 5 to 2
    move 1 from 4 to 2
    move 1 from 2 to 3
    move 7 from 1 to 4
    move 9 from 7 to 4
    move 1 from 3 to 4
    move 2 from 2 to 4
    move 5 from 9 to 6
    move 1 from 4 to 5
    move 2 from 9 to 3
    move 1 from 1 to 6
    move 2 from 6 to 1
    move 2 from 6 to 5
    move 2 from 9 to 7
    move 1 from 3 to 9
    move 1 from 9 to 5
    move 2 from 7 to 3
    move 1 from 1 to 7
    move 7 from 4 to 5
    move 2 from 1 to 2
    move 3 from 3 to 8
    move 3 from 8 to 9
    move 31 from 5 to 8
    move 1 from 7 to 1
    move 1 from 2 to 1
    move 1 from 1 to 5
    move 1 from 5 to 6
    move 2 from 5 to 7
    move 10 from 4 to 9
    move 5 from 6 to 2
    move 3 from 2 to 6
    move 2 from 7 to 8
    move 1 from 6 to 3
    move 1 from 4 to 1
    move 1 from 3 to 6
    move 1 from 4 to 2
    move 2 from 1 to 2
    move 1 from 8 to 7
    move 10 from 8 to 2
    move 13 from 2 to 9
    move 1 from 1 to 5
    move 18 from 8 to 2
    move 21 from 9 to 6
    move 1 from 7 to 8
    move 2 from 9 to 7
    move 1 from 2 to 3
    move 1 from 7 to 8
    move 9 from 2 to 4
    move 1 from 7 to 8
    move 3 from 9 to 1
    move 1 from 8 to 1
    move 6 from 2 to 3
    move 5 from 4 to 7
    move 1 from 5 to 8
    move 2 from 4 to 3
    move 5 from 7 to 3
    move 2 from 2 to 7
    move 15 from 6 to 1
    move 12 from 1 to 2
    move 6 from 2 to 9
    move 4 from 9 to 5
    move 4 from 5 to 6
    move 14 from 3 to 9
    move 1 from 6 to 7
    move 1 from 7 to 2
    move 1 from 7 to 8
    move 9 from 2 to 6
    move 1 from 1 to 6
    move 2 from 9 to 8
    move 4 from 9 to 7
    move 1 from 1 to 5
    move 8 from 8 to 3
    move 1 from 5 to 4
    move 2 from 1 to 2
    move 3 from 1 to 4
    move 9 from 6 to 2
    move 1 from 7 to 4
    move 1 from 8 to 2
    move 1 from 6 to 4
    move 4 from 7 to 8
    move 12 from 6 to 8
    move 3 from 2 to 1
    move 6 from 8 to 7
    move 5 from 3 to 6
    move 3 from 3 to 6
    move 3 from 1 to 3
    move 8 from 2 to 9
    move 2 from 4 to 5
    move 2 from 7 to 2
    move 10 from 8 to 5
    move 3 from 3 to 2
    move 10 from 5 to 3
    move 1 from 4 to 3
    move 1 from 2 to 1
    move 1 from 1 to 7
    move 14 from 9 to 6
    move 5 from 2 to 4
    move 15 from 6 to 5
    move 3 from 9 to 3
    move 1 from 8 to 6
    move 1 from 3 to 8
    move 7 from 3 to 8
    move 16 from 5 to 1
    move 2 from 7 to 1
    move 1 from 5 to 9
    move 2 from 9 to 3
    move 15 from 1 to 5
    move 3 from 8 to 2
    move 3 from 3 to 1
    move 3 from 7 to 3
    move 8 from 4 to 6
    move 5 from 1 to 6
    move 9 from 5 to 7
    move 2 from 8 to 3
    move 2 from 2 to 7
    move 1 from 1 to 4
    move 2 from 5 to 8
    move 4 from 3 to 1
    move 4 from 8 to 1
    move 1 from 8 to 6
    move 9 from 7 to 6
    move 2 from 7 to 5
    move 3 from 1 to 8
    move 1 from 4 to 8
    move 1 from 2 to 4
    move 12 from 6 to 2
    move 3 from 8 to 6
    move 1 from 4 to 7
    move 2 from 6 to 8
    move 5 from 5 to 9
    move 13 from 2 to 9
    move 2 from 4 to 7
    move 13 from 9 to 5
    move 2 from 6 to 5
    move 1 from 3 to 9
    move 6 from 9 to 4
    move 5 from 1 to 3
    move 1 from 7 to 9
    move 15 from 5 to 8
    move 2 from 4 to 7
    move 2 from 4 to 6
    move 1 from 4 to 6
    move 1 from 5 to 7
    move 18 from 6 to 2
    move 2 from 7 to 3
    move 3 from 6 to 7
    move 3 from 2 to 8
    move 5 from 7 to 3
    move 1 from 9 to 6
    move 2 from 3 to 8
    move 11 from 3 to 2
    move 2 from 2 to 9
    move 1 from 6 to 2
    move 1 from 7 to 5
    move 1 from 5 to 9
    move 9 from 8 to 4
    move 1 from 4 to 6
    move 2 from 3 to 1
    move 2 from 1 to 5
    move 12 from 8 to 3
    move 1 from 8 to 2
    move 14 from 3 to 4
    move 1 from 6 to 4
    move 1 from 5 to 4
    move 20 from 2 to 7
    move 2 from 9 to 5
    move 1 from 5 to 3
    move 1 from 9 to 2
    move 1 from 2 to 8
    move 2 from 2 to 3
    move 5 from 4 to 5
    move 6 from 5 to 7
    move 2 from 8 to 2
    move 3 from 3 to 9
    move 5 from 4 to 5
    move 2 from 9 to 7
    move 2 from 2 to 3
    move 1 from 9 to 3
    move 22 from 7 to 3
    move 4 from 7 to 4
    move 24 from 3 to 6
    move 4 from 2 to 6
    move 18 from 6 to 9
    move 15 from 4 to 6
    move 8 from 6 to 3
    move 6 from 6 to 1
    move 7 from 9 to 6
    move 2 from 7 to 4
    move 8 from 3 to 9
    move 14 from 6 to 3
    move 2 from 3 to 9
    move 1 from 9 to 6
    move 13 from 9 to 1
    move 3 from 4 to 5
    move 1 from 9 to 6
    move 5 from 1 to 8
    move 3 from 3 to 9
    move 2 from 1 to 5
    move 8 from 5 to 8
    move 10 from 3 to 5
    move 3 from 4 to 6
    move 6 from 1 to 9
    move 4 from 5 to 3
    move 5 from 8 to 2
    move 6 from 6 to 3
    move 7 from 3 to 6
    move 1 from 3 to 4
    move 5 from 8 to 7
    move 5 from 2 to 6
    move 2 from 7 to 3
    move 3 from 7 to 3
    move 1 from 4 to 9
    move 9 from 6 to 9
    move 2 from 6 to 2
    move 1 from 8 to 2
    move 2 from 8 to 7
    move 5 from 1 to 5
    move 1 from 1 to 4
    move 13 from 5 to 7
    move 5 from 3 to 7
    move 1 from 5 to 6
    move 1 from 4 to 6
    move 3 from 2 to 8
    move 1 from 3 to 5
    move 1 from 3 to 8
    move 14 from 7 to 4
    move 1 from 5 to 6
    move 7 from 6 to 9
    move 6 from 7 to 9
    move 2 from 8 to 9
    move 2 from 8 to 1
    move 31 from 9 to 1
    move 13 from 4 to 2
    move 1 from 4 to 3
    move 10 from 2 to 7
    move 1 from 3 to 4
    move 1 from 2 to 7
    move 3 from 7 to 8
    move 1 from 4 to 1
    move 3 from 8 to 5
    move 32 from 1 to 5
    move 3 from 9 to 7
    move 4 from 9 to 6
    move 2 from 2 to 7
    move 2 from 1 to 7
    move 1 from 6 to 1
    move 1 from 9 to 4
    move 3 from 6 to 4
    move 1 from 1 to 8
    move 15 from 5 to 1
    move 1 from 8 to 4
    move 9 from 5 to 7
    move 1 from 9 to 8
    move 1 from 8 to 1
    move 10 from 1 to 9
    move 1 from 4 to 2
    move 2 from 9 to 5
    move 4 from 9 to 6
    move 1 from 2 to 7
    move 3 from 4 to 2
    move 1 from 1 to 5
    move 5 from 1 to 5
    move 1 from 4 to 9
    move 3 from 6 to 7
    move 23 from 7 to 6
    move 1 from 2 to 4
    move 1 from 2 to 5
    move 9 from 5 to 4
    move 1 from 2 to 5
    move 9 from 5 to 6
    move 1 from 9 to 7
    move 1 from 9 to 3
    move 3 from 9 to 4
    move 14 from 6 to 3
    move 5 from 7 to 4
    move 1 from 7 to 5
    move 1 from 5 to 9
    move 2 from 5 to 6
    move 16 from 6 to 2
    move 2 from 6 to 1
    move 7 from 4 to 8
    move 2 from 1 to 2
    move 4 from 3 to 5
    move 5 from 4 to 7
    move 2 from 6 to 7
    move 4 from 4 to 1
    move 4 from 8 to 9
    move 1 from 4 to 5
    move 1 from 6 to 8
    move 1 from 4 to 9
    move 4 from 1 to 7
    move 1 from 9 to 4
    move 2 from 2 to 7
    move 7 from 3 to 9
    move 15 from 2 to 3
    move 4 from 8 to 6
    move 1 from 4 to 7
    move 2 from 9 to 7
    move 1 from 6 to 8
    move 2 from 7 to 2
    move 5 from 7 to 2
    move 1 from 5 to 2
    move 6 from 2 to 9
    move 3 from 7 to 1
    move 3 from 1 to 2
    move 3 from 7 to 1
    move 2 from 2 to 9
    move 2 from 6 to 9
    move 1 from 8 to 3
    move 19 from 3 to 9
    move 1 from 6 to 3
    move 3 from 7 to 4
    move 1 from 2 to 5
    move 2 from 1 to 9
    move 2 from 2 to 3
    move 33 from 9 to 7
    move 1 from 1 to 7
    move 3 from 3 to 7
    move 1 from 3 to 2
    move 1 from 5 to 8
    move 4 from 9 to 7
    move 1 from 5 to 2
    move 2 from 4 to 9
    move 4 from 9 to 7
    move 3 from 2 to 1
    move 1 from 4 to 3
    move 1 from 9 to 7
    move 1 from 8 to 3
    move 7 from 7 to 3
    move 3 from 1 to 9
    move 4 from 9 to 7
    move 4 from 5 to 8
    move 3 from 3 to 4
    move 3 from 4 to 5
    move 3 from 3 to 6
    move 2 from 6 to 5
    move 38 from 7 to 5
    move 40 from 5 to 3
    move 4 from 8 to 9
    move 1 from 6 to 9
    move 1 from 5 to 1
    move 3 from 7 to 6
    move 1 from 7 to 5
    move 38 from 3 to 8
    move 1 from 1 to 9
    move 3 from 9 to 6
    move 5 from 3 to 9
    move 4 from 8 to 6
    move 1 from 7 to 1
    move 3 from 5 to 9
    move 1 from 1 to 2
    move 10 from 8 to 3
    move 5 from 8 to 1
    move 3 from 1 to 2
    move 9 from 6 to 7
    move 9 from 3 to 5
    move 1 from 7 to 6
    move 1 from 3 to 8
    move 1 from 7 to 9
    move 1 from 1 to 5
    move 1 from 1 to 3
    move 1 from 9 to 2
    move 4 from 2 to 3
    move 1 from 2 to 4
    move 9 from 8 to 1
    move 2 from 9 to 5
    move 2 from 1 to 2
    move 2 from 3 to 4
    move 6 from 8 to 6
    move 10 from 5 to 3
    move 7 from 3 to 2
    move 2 from 1 to 2
    move 5 from 1 to 7
    move 7 from 9 to 6
    move 7 from 6 to 5
    move 1 from 4 to 3
    move 7 from 7 to 4
    move 5 from 3 to 9
    move 7 from 2 to 6
    move 4 from 7 to 8
    move 5 from 8 to 9
    move 1 from 2 to 6
    move 1 from 3 to 5
    move 2 from 2 to 8
    move 8 from 4 to 6
    move 7 from 9 to 7
    move 4 from 7 to 9
    move 7 from 9 to 3
    move 8 from 3 to 1
    move 6 from 5 to 9
    move 8 from 1 to 8
    move 13 from 8 to 4
    move 3 from 9 to 6
    move 1 from 8 to 6
    move 1 from 7 to 3
    move 2 from 4 to 1
    move 5 from 9 to 1
    move 1 from 3 to 7
    move 15 from 6 to 1
    move 1 from 7 to 9
    move 10 from 4 to 7
    move 11 from 7 to 5
    move 17 from 1 to 6
    move 1 from 9 to 3
    move 6 from 6 to 1
    move 3 from 5 to 3
    move 2 from 4 to 5
    move 2 from 7 to 8
    move 12 from 5 to 3
    move 13 from 6 to 9
    move 2 from 8 to 2
    move 2 from 5 to 1
    move 16 from 3 to 8
    move 3 from 2 to 3
    move 2 from 3 to 7
    move 2 from 7 to 9
    move 1 from 3 to 7
    move 4 from 8 to 4
    move 2 from 4 to 8
    move 5 from 1 to 5
    move 2 from 4 to 7
    move 6 from 6 to 8
    move 2 from 8 to 5
    move 2 from 1 to 4
    move 5 from 8 to 7
    move 5 from 6 to 3
    move 6 from 9 to 8
    move 2 from 9 to 2
    move 1 from 1 to 7
    move 4 from 5 to 3
    move 2 from 2 to 3
    move 1 from 4 to 9
    move 10 from 3 to 6
    move 1 from 3 to 7
    move 10 from 7 to 2
    move 2 from 5 to 3
    move 1 from 4 to 2
    move 2 from 6 to 8
    move 3 from 6 to 5
    move 1 from 6 to 1
    move 7 from 2 to 3
    move 6 from 8 to 7
    move 4 from 6 to 3
    move 14 from 8 to 6
    move 11 from 6 to 8
    move 1 from 1 to 4
    move 6 from 7 to 2
    move 3 from 5 to 8
    move 4 from 1 to 7
    move 1 from 2 to 8
    move 1 from 2 to 6
    move 1 from 3 to 4
    move 1 from 5 to 6
    move 7 from 8 to 6
    move 9 from 3 to 2
    move 1 from 8 to 5
    """
}
