import Parsing
import DequeModule

final class Day10: Day {
  let dayOfMonth: Int = 10

  enum Instruction: CustomStringConvertible, Equatable {
    case noop
    case add(Int)

    var description: String {
      switch self {
      case .noop: return "noop"
      case .add(let x): return "add(\(x))"
      }
    }

    var opLength: Int {
      switch self {
      case .noop: return 1
      case .add: return 2
      }
    }

    static func parser() -> some Parser<Substring.UTF8View, Instruction> {
      OneOf {
        "noop".utf8.map { Instruction.noop }

        Parse(Instruction.add) {
          "addx ".utf8
          Int.parser()
        }
      }
    }
  }

  struct Program {
    struct State {
      var register: Int = 1
      var currentCycle: Int = 1
      var runningAdd: Int? = nil

      var pixelPosition: Int {
        (currentCycle - 1) / 40
      }

      var spritePosition: ClosedRange<Int> {
        (register - 1)...(register + 1)
      }

      var signalStrength: Int { register * currentCycle }

      var willDrawPixel: Bool {
        spritePosition.contains(pixelPosition)
      }
    }

    private(set) var currentState: State = State()
    private(set) var remainingInstructions: Deque<Instruction>
    private(set) var previousCycles: [State] = []
    private(set) var buffer: String = "\n"

    init<Instructions: Sequence<Instruction>>(instructions: Instructions) {
      self.remainingInstructions = .init(instructions)
    }

    var isComplete: Bool {
      currentState.runningAdd == nil && remainingInstructions.isEmpty
    }

    mutating func runCycle() {
      guard !isComplete else { return }

      previousCycles.append(currentState)

      drawCurrentStateToBuffer()

      currentState.currentCycle += 1

      if let add = currentState.runningAdd {
        currentState.register += add
        currentState.runningAdd = nil
      } else if let nextInstruction = remainingInstructions.popFirst() {
        guard case .add(let add) = nextInstruction else { return }
        currentState.runningAdd = add
      }
    }

    mutating func runAllInstructions() {
      while !isComplete {
        runCycle()
      }
    }

    private mutating func drawCurrentStateToBuffer() {
      buffer.append(currentState.willDrawPixel ? "#" : ".")
      if currentState.currentCycle.isMultiple(of: 40) {
        buffer.append("\n")
      }
    }
  }

  var instructionsParser: some Parser<Substring.UTF8View, [Instruction]> {
    Many {
      Instruction.parser()
    } separator: {
      Whitespace(1, .vertical)
    }
  }

  struct Program2 {
    var cycle: Int = 1
    var register: Int = 1
    var executing: Instruction?
    var remainingInstructions: Deque<Instruction>
    var buffer: String = ""
    var debugOutput: String = ""

    init(instructions: some Sequence<Instruction>) {
      remainingInstructions = .init(instructions)
    }

    var pixelPosition: Int {
      (cycle - 1) % 40
    }

    var spritePosition: ClosedRange<Int> {
      (register - 1)...(register + 1)
    }

    var isComplete: Bool {
      executing == nil && remainingInstructions.isEmpty
    }

    mutating func performInstruction() {
      guard !isComplete else { return }

      let toFinish = getInstructionToFinish()

      print("During cycle \(cycle)  : CRT draws in position \(pixelPosition)")
      buffer.append(spritePosition.contains(pixelPosition) ? "#" : ".")
      let lastRow = buffer.split(separator: "\n").last!
      print("Current CRT row  : \(lastRow)")
      if cycle.isMultiple(of: 40) {
        buffer.append("\n")
      }

      switch toFinish {
      case .add(let x):
        register += x
        print("End of cycle \(cycle)  : finish executing add \(x) (register is now \(register))")
        var spritePositionDisplay = "Sprite position  : "
        for i in 0...40 {
          if spritePosition.contains(i) {
            spritePositionDisplay.append("#")
          } else {
            spritePositionDisplay.append(".")
          }
        }
        print(spritePositionDisplay)
      case .noop:
        print("End of cycle \(cycle)  : finish executing noop")
      default:
        break
      }


      cycle += 1
      print("\n")
    }

    mutating func runAllInstructions() {
      while !isComplete {
        performInstruction()
      }
    }

    private mutating func getInstructionToFinish() -> Instruction? {
      if let executing {
        self.executing = nil
        return executing
      }
      guard let next = remainingInstructions.popFirst() else { return nil }
      print("start cycle \(cycle)   : begin executing \(next)")

      switch next {
      case .add:
        executing = next
        return nil
      case .noop:
        return next
      }
    }

    private mutating func print(_ text: String) {
      Swift.print(text, to: &self.debugOutput)
    }
  }

  func solution1() async throws -> Any {
    let instructions = try instructionsParser.parse(input)
    var program = Program(instructions: instructions)
    program.runAllInstructions()
    let cyclesToCheck: Set<Int> = [20, 60, 100, 140, 180, 220]
    return program.previousCycles.lazy
      .filter { cyclesToCheck.contains($0.currentCycle) }
      .map(\.signalStrength)
      .reduce(0, +)
  }

  func solution2() async throws -> Any {
    let instructions = try instructionsParser.parse(input)
    var program = Program2(instructions: instructions)
    program.runAllInstructions()
    return "\n" + program.buffer
  }

//  /// test input
//  let input: String = """
//  addx 15
//  addx -11
//  addx 6
//  addx -3
//  addx 5
//  addx -1
//  addx -8
//  addx 13
//  addx 4
//  noop
//  addx -1
//  addx 5
//  addx -1
//  addx 5
//  addx -1
//  addx 5
//  addx -1
//  addx 5
//  addx -1
//  addx -35
//  addx 1
//  addx 24
//  addx -19
//  addx 1
//  addx 16
//  addx -11
//  noop
//  noop
//  addx 21
//  addx -15
//  noop
//  noop
//  addx -3
//  addx 9
//  addx 1
//  addx -3
//  addx 8
//  addx 1
//  addx 5
//  noop
//  noop
//  noop
//  noop
//  noop
//  addx -36
//  noop
//  addx 1
//  addx 7
//  noop
//  noop
//  noop
//  addx 2
//  addx 6
//  noop
//  noop
//  noop
//  noop
//  noop
//  addx 1
//  noop
//  noop
//  addx 7
//  addx 1
//  noop
//  addx -13
//  addx 13
//  addx 7
//  noop
//  addx 1
//  addx -33
//  noop
//  noop
//  noop
//  addx 2
//  noop
//  noop
//  noop
//  addx 8
//  noop
//  addx -1
//  addx 2
//  addx 1
//  noop
//  addx 17
//  addx -9
//  addx 1
//  addx 1
//  addx -3
//  addx 11
//  noop
//  noop
//  addx 1
//  noop
//  addx 1
//  noop
//  noop
//  addx -13
//  addx -19
//  addx 1
//  addx 3
//  addx 26
//  addx -30
//  addx 12
//  addx -1
//  addx 3
//  addx 1
//  noop
//  noop
//  noop
//  addx -9
//  addx 18
//  addx 1
//  addx 2
//  noop
//  noop
//  addx 9
//  noop
//  noop
//  noop
//  addx -1
//  addx 2
//  addx -37
//  addx 1
//  addx 3
//  noop
//  addx 15
//  addx -21
//  addx 22
//  addx -6
//  addx 1
//  noop
//  addx 2
//  addx 1
//  noop
//  addx -10
//  noop
//  noop
//  addx 20
//  addx 1
//  addx 2
//  addx 2
//  addx -6
//  addx -11
//  noop
//  noop
//  noop
//  """
  /// actual input
  let input: String = """
  addx 1
  addx 4
  noop
  noop
  noop
  addx 5
  addx 3
  noop
  addx 2
  noop
  noop
  noop
  noop
  addx 3
  addx 5
  addx 2
  addx 1
  noop
  addx 5
  addx -1
  addx 5
  noop
  addx 3
  noop
  addx -40
  noop
  addx 38
  addx -31
  addx 3
  noop
  addx 2
  addx -7
  addx 8
  addx 2
  addx 5
  addx 2
  addx 3
  addx -2
  noop
  noop
  noop
  addx 5
  addx 2
  noop
  addx 3
  addx 2
  noop
  addx 3
  addx -36
  noop
  noop
  addx 5
  noop
  noop
  addx 8
  addx -5
  addx 5
  addx 2
  addx -15
  addx 16
  addx 4
  noop
  addx 1
  noop
  noop
  addx 4
  addx 5
  addx -30
  addx 35
  addx -1
  addx 2
  addx -36
  addx 5
  noop
  noop
  addx -2
  addx 5
  addx 2
  addx 3
  noop
  addx 2
  noop
  noop
  addx 5
  noop
  addx 14
  addx -13
  addx 5
  addx -14
  addx 18
  addx 3
  addx 2
  addx -2
  addx 5
  addx -40
  noop
  addx 32
  addx -25
  addx 3
  noop
  addx 2
  addx 3
  addx -2
  addx 2
  addx 2
  noop
  addx 3
  addx 5
  addx 2
  addx 9
  addx -36
  addx 30
  addx 5
  addx 2
  addx -25
  addx 26
  addx -38
  addx 10
  addx -3
  noop
  noop
  addx 22
  addx -16
  addx -1
  addx 5
  addx 3
  noop
  addx 2
  addx -20
  addx 21
  addx 3
  addx 2
  addx -24
  addx 28
  noop
  addx 5
  addx 3
  noop
  addx -24
  noop
  """
}
