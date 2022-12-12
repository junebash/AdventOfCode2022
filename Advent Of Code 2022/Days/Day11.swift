import Parsing
import DequeModule

struct Day11: Day {
  let dayOfMonth: Int = 11

  enum Operator: String, CaseIterable {
    case plus = "+"
    case times = "*"
  }

  enum Operand: Equatable {
    case old
    case value(Int)

    func value(from old: Int) -> Int {
      switch self {
      case .value(let value): return value
      case .old: return old
      }
    }

    static func parser() -> some Parser<Substring.UTF8View, Operand> {
      OneOf {
        "old".utf8.map { Operand.old }
        Digits().map { (i: Int) -> Operand in .value(Int(i)) }
      }
    }
  }

  struct Operation {
    var first: Operand
    var op: Operator
    var second: Operand

    func worryLevel(from old: Int) -> Int {
      switch op {
      case .plus:
        return first.value(from: old) + second.value(from: old)
      case .times:
        return first.value(from: old) * second.value(from: old)
      }
    }

    static func parser() -> some Parser<Substring.UTF8View, Operation> {
      Parse(Operation.init(first:op:second:)) {
        "Operation: new = ".utf8
        Operand.parser()
        Whitespace(.horizontal)
        Operator.parser()
        Whitespace(.horizontal)
        Operand.parser()
      }
    }
  }

  struct Test {
    var divisibleBy: Int

    func passes(for value: Int) -> Bool {
      value.isMultiple(of: divisibleBy)
    }

    static func parser() -> some Parser<Substring.UTF8View, Test> {
      Parse(Test.init(divisibleBy:)) {
        "Test: divisible by ".utf8
        Digits().map { (i: Int) -> Int in Int(i) }
      }
    }
  }

  struct Next {
    var ifTrue: Int
    var ifFalse: Int

    func monkeyIndex(for testResult: Bool) -> Int {
      testResult ? ifTrue : ifFalse
    }

    static func parser() -> some Parser<Substring.UTF8View, Next> {
      Parse(Next.init(ifTrue:ifFalse:)) {
        Whitespace(.horizontal)
        "If true: throw to monkey ".utf8
        Int.parser()
        Whitespace(1, .vertical)
        Whitespace(.horizontal)
        "If false: throw to monkey ".utf8
        Int.parser()
      }
    }
  }

  enum WorryManager {
    case automatic
    case custom(Int)
  }

  struct Monkey {
    let index: Int
    var items: Deque<Int>
    let operation: Operation
    let test: Test
    let next: Next
    var totalInspections: Int = 0

    init(index: Int, items: Deque<Int>, operation: Operation, test: Test, next: Next) {
      self.index = index
      self.items = items
      self.operation = operation
      self.test = test
      self.next = next
    }

    func next(forStartingItem item: Int, worryManager: WorryManager) -> (worryLevel: Int, monkeyIndex: Int) {
      let opResult = operation.worryLevel(from: item)
      let newWorryLevel: Int
      switch worryManager {
      case .automatic:
        newWorryLevel = opResult / 3
      case .custom(let divisor):
        newWorryLevel = opResult % divisor
      }
      let testResult = test.passes(for: newWorryLevel)
      return (newWorryLevel, next.monkeyIndex(for: testResult))
    }

    static func parser() -> some Parser<Substring.UTF8View, Monkey> {
      Parse(Monkey.init(index:items:operation:test:next:)) {
        "Monkey ".utf8
        Int.parser()
        ":".utf8
        Whitespace(1, .vertical)
        "Starting items: ".utf8
        Many {
          Int.parser().map(Int.init(_:))
        } separator: {
          ",".utf8
          Whitespace(.horizontal)
        }.map(Deque.init)
        Whitespace(1, .vertical)
        Operation.parser()
        Whitespace(1, .vertical)
        Test.parser()
        Whitespace(1, .vertical)
        Next.parser()
      }
    }
  }

  struct KeepAway {
    var monkeys: [Monkey]

    var monkeyBusiness: Int {
      monkeys.lazy
        .map(\.totalInspections)
        .max(count: 2)
        .reduce(1, *)
    }

    subscript(monkey monkeyIndex: Int, item itemIndex: Int) -> Int {
      _read { yield self.monkeys[monkeyIndex].items[itemIndex] }
      _modify { yield &self.monkeys[monkeyIndex].items[itemIndex] }
    }

    static func parser() -> some Parser<Substring.UTF8View, KeepAway> {
      Many {
        Monkey.parser()
      } separator: {
        Whitespace(2..., .vertical)
      }.map(KeepAway.init)
    }

    mutating func runTurn(forMonkey monkeyIndex: Int, worryManager: WorryManager) {
      var monkey = monkeys[monkeyIndex]
      defer { monkeys[monkeyIndex] = monkey }
      while let item = monkey.items.popFirst() {
        monkey.totalInspections += 1
        let (worryLevel, nextMonkeyIndex) = monkey.next(
          forStartingItem: item,
          worryManager: worryManager
        )
        monkeys[nextMonkeyIndex].items.append(worryLevel)
      }
    }

    mutating func runRound(worryManager: WorryManager) {
      for i in monkeys.indices {
        runTurn(forMonkey: i, worryManager: worryManager)
      }
    }
  }

  func solution1() async throws -> Any {
    var set = try KeepAway.parser().parse(input)
    for _ in 1...20 {
      set.runRound(worryManager: .automatic)
    }
    return set.monkeyBusiness
  }

  func solution2() async throws -> Any {
    var set = try KeepAway.parser().parse(input)
    let manageComponent = set.monkeys.lazy.map(\.test.divisibleBy).reduce(1, *)
    for _ in 1...10_000 {
      set.runRound(worryManager: .custom(manageComponent))
    }
    return set.monkeyBusiness
  }

  let input: String = """
  Monkey 0:
  Starting items: 91, 58, 52, 69, 95, 54
  Operation: new = old * 13
  Test: divisible by 7
    If true: throw to monkey 1
    If false: throw to monkey 5

  Monkey 1:
  Starting items: 80, 80, 97, 84
  Operation: new = old * old
  Test: divisible by 3
    If true: throw to monkey 3
    If false: throw to monkey 5

  Monkey 2:
  Starting items: 86, 92, 71
  Operation: new = old + 7
  Test: divisible by 2
    If true: throw to monkey 0
    If false: throw to monkey 4

  Monkey 3:
  Starting items: 96, 90, 99, 76, 79, 85, 98, 61
  Operation: new = old + 4
  Test: divisible by 11
    If true: throw to monkey 7
    If false: throw to monkey 6

  Monkey 4:
  Starting items: 60, 83, 68, 64, 73
  Operation: new = old * 19
  Test: divisible by 17
    If true: throw to monkey 1
    If false: throw to monkey 0

  Monkey 5:
  Starting items: 96, 52, 52, 94, 76, 51, 57
  Operation: new = old + 3
  Test: divisible by 5
    If true: throw to monkey 7
    If false: throw to monkey 3

  Monkey 6:
  Starting items: 75
  Operation: new = old + 5
  Test: divisible by 13
    If true: throw to monkey 4
    If false: throw to monkey 2

  Monkey 7:
  Starting items: 83, 75
  Operation: new = old + 1
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 6
  """
}
