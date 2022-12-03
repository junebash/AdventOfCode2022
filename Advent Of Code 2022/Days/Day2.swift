import Parsing

struct Day2: Day {
    let dayOfMonth: Int = 2

    enum Play: Character, CaseIterable {
        case rock = "A", paper = "B", scissors = "C"

        init?(yourPlay: Character) {
            switch yourPlay {
            case "X": self = .rock
            case "Y": self = .paper
            case "Z": self = .scissors
            default: return nil
            }
        }

        var yourPlay: Character? {
            switch self {
            case .rock: return "X"
            case .paper: return "Y"
            case .scissors: return "Z"
            }
        }

        var score: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }

        func beats(_ other: Self) -> Bool {
            switch (self, other) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper): return true
            default: return false
            }
        }

        func yourPlay(forOutcome outcome: Outcome) -> Play {
            switch (self, outcome) {
            case (.paper, .draw), (.rock, .win), (.scissors, .lose):
                return .paper
            case (.rock, .draw), (.scissors, .win), (.paper, .lose):
                return .rock
            case (.scissors, .draw), (.paper, .win), (.rock, .lose):
                return .scissors
            }
        }
    }

    enum Outcome: Character, CaseIterable {
        case win = "Z", draw = "Y", lose = "X"

        var score: Int {
            switch self {
            case .win: return 6
            case .draw: return 3
            case .lose: return 0
            }
        }
    }

    struct UTF8ToCharacter: Conversion {
        struct Failure: Error {}

        func apply(_ input: UTF8.CodeUnit) throws -> Character {
            Character(UnicodeScalar(input))
        }

        func unapply(_ output: Character) throws -> UTF8.CodeUnit {
            guard output.utf8.count == 1 else { throw Failure() }
            return output.utf8.first!
        }
    }

    func solution1() async throws -> Any {
        struct Round: Equatable {
            var opponent: Play
            var you: Play

            var outcome: Outcome {
                if opponent == you {
                    return .draw
                } else if you.beats(opponent) {
                    return .win
                } else {
                    return .lose
                }
            }

            var totalScore: Int {
                you.score + outcome.score
            }
        }

        let roundParser = Parse(.memberwise(Round.init(opponent:you:))) {
            First<Substring.UTF8View>()
                .map(UTF8ToCharacter().map(.representing(Play.self)))
            Whitespace(.horizontal)
            First()
                .map(UTF8ToCharacter().map(.convert(
                    apply: Play.init(yourPlay:),
                    unapply: \.yourPlay
                )))
        }

        let tournamentParser = Many {
            roundParser
        } separator: {
            Whitespace(.vertical)
        }

        let tournament = try tournamentParser.parse(input)
        let score = tournament.lazy.map(\.totalScore).reduce(0, +)
        return score
    }

    func solution2() async throws -> Any {
        struct Round {
            var opponent: Play
            var outcome: Outcome

            var you: Play {
                opponent.yourPlay(forOutcome: outcome)
            }

            var totalScore: Int {
                you.score + outcome.score
            }
        }

        let roundParser = Parse(.memberwise(Round.init(opponent:outcome:))) {
            First<Substring.UTF8View>()
                .map(UTF8ToCharacter().map(.representing(Play.self)))
            Whitespace(.horizontal)
            First()
                .map(UTF8ToCharacter().map(.representing(Outcome.self)))
        }

        let tournamentParser = Many {
            roundParser
        } separator: {
            Whitespace(.vertical)
        }

        let tournament = try tournamentParser.parse(input)
        let score = tournament.lazy.map(\.totalScore).reduce(0, +)
        return score
    }

    let input: String = """
    C X
    C X
    C X
    A Z
    C X
    C Z
    C X
    B Y
    C X
    C X
    C X
    B Y
    C X
    B Z
    C Z
    C X
    C X
    C Z
    C Z
    B Y
    C Z
    C X
    B Z
    C X
    C X
    C X
    B Y
    C Z
    B Z
    C X
    B Y
    C Z
    A Y
    C X
    B Y
    A Y
    C X
    C Y
    C X
    C Z
    C X
    C X
    A Y
    C X
    C X
    B Y
    B Y
    C X
    C X
    B Y
    C Z
    B Y
    B Y
    C X
    C X
    C Y
    B X
    C X
    C X
    B X
    C Y
    B X
    B Y
    C X
    C Z
    B Y
    B Y
    B Y
    B X
    C Z
    C X
    B Y
    C X
    A Y
    C Z
    A Y
    C Z
    C X
    C Z
    B Y
    B X
    C X
    B Z
    C X
    C Y
    C X
    C X
    C Z
    C Z
    C Z
    B Z
    C Y
    B Y
    B Y
    B Y
    C X
    B Y
    C Z
    C X
    C X
    C X
    B Y
    C Z
    C X
    C X
    C X
    C X
    C X
    B Z
    C X
    A Y
    B X
    C X
    C X
    C X
    A Y
    B Z
    C X
    C Z
    C X
    A Y
    C X
    B Y
    C Z
    C X
    C Z
    B Z
    B Y
    B Y
    C Z
    B Y
    B Y
    B X
    B Y
    B Y
    C X
    C Z
    C X
    C X
    C X
    C X
    C X
    C X
    C X
    C X
    C Z
    C Y
    B Y
    B Y
    C Z
    A X
    C X
    C Z
    B Z
    B Y
    C Z
    C X
    C X
    B Z
    B Z
    C X
    C X
    C X
    B X
    A Y
    B X
    C X
    C Z
    C X
    C Z
    B Y
    C X
    B Y
    A Y
    A Y
    A Y
    B Y
    C X
    C Y
    B Y
    A Y
    C Z
    A X
    C X
    C Z
    C X
    C X
    C X
    C Z
    C X
    B X
    A X
    C Z
    C X
    C X
    C Y
    C X
    C Z
    B Y
    C X
    C X
    C X
    C Z
    C X
    B X
    C X
    B Y
    B X
    C Y
    C X
    C X
    C Y
    C X
    C X
    C X
    C X
    B Y
    C X
    B X
    B Y
    C Y
    C X
    C X
    B X
    C X
    C X
    B Y
    A Y
    C Z
    C X
    B Y
    C X
    C X
    C Z
    C X
    C X
    A Z
    C X
    C Y
    A Z
    C Z
    C Z
    B Y
    C X
    B Y
    C X
    C X
    C X
    B Y
    B Z
    C X
    C X
    C X
    B X
    B Y
    C X
    A Y
    B X
    B X
    B Y
    B Z
    C X
    B X
    C Z
    C X
    B Y
    C X
    A X
    C Y
    A Z
    C X
    A Z
    B Z
    C X
    B X
    B Y
    A Y
    B X
    C X
    B Y
    B X
    C Z
    B Y
    B X
    A X
    C Z
    B Y
    C X
    C X
    C X
    A Y
    B Y
    C X
    B Y
    C Z
    C X
    C Z
    B Z
    B X
    A Y
    C X
    B Y
    C X
    C X
    C X
    B Y
    B Y
    B Z
    B Y
    C Z
    C X
    C Z
    C X
    C Z
    C X
    C X
    A Y
    C Z
    B Y
    A Y
    B Z
    C X
    C X
    C X
    C X
    B Y
    C X
    C X
    C X
    C X
    A Y
    C X
    C X
    C X
    C Z
    C X
    B Y
    C X
    C X
    C Z
    C X
    C X
    C X
    B Y
    B Z
    B Y
    C X
    C X
    C X
    B Y
    C X
    B Y
    C X
    C X
    C Z
    C Y
    C Z
    C Z
    C X
    C X
    C Z
    A Y
    C Z
    C X
    B Z
    C X
    C Z
    C X
    C X
    B Y
    B Z
    B Z
    A Y
    B Z
    C Z
    C X
    C Y
    B Y
    A Y
    C X
    A Y
    A Z
    B Z
    A Y
    C X
    C Z
    A Y
    B Y
    B Y
    C X
    C Z
    B Y
    C X
    C X
    B Y
    C X
    C Z
    B Y
    B X
    C Z
    C X
    C Y
    C X
    C X
    C X
    C Y
    C X
    B Z
    C Y
    B Y
    B Y
    C X
    A Y
    C X
    A Z
    A Y
    B X
    C X
    B Y
    C X
    B Y
    B Y
    C Z
    C Z
    A Y
    C X
    A Y
    C Z
    C X
    C Z
    C X
    B Y
    B X
    C X
    B X
    C X
    C X
    B Y
    C X
    C X
    C X
    C Z
    C Z
    B Y
    C Y
    C X
    C X
    B Y
    C X
    C Z
    C X
    C Z
    C X
    C Y
    C X
    C Y
    C Z
    C X
    B Y
    C X
    B X
    B Y
    C Z
    B Y
    B Z
    B Z
    C X
    A X
    C X
    C Z
    C Y
    C X
    B X
    C Y
    A Y
    C Y
    C X
    B Y
    B Y
    C X
    C Z
    B X
    A Y
    C X
    C X
    C X
    B Y
    B Y
    B Z
    C Z
    C Z
    B X
    C X
    B Z
    C X
    B Y
    B Y
    C Z
    C X
    C Z
    C X
    C X
    C X
    C Z
    C Z
    C Z
    C X
    B Y
    C X
    C X
    B Y
    C X
    C X
    C X
    A Y
    C Z
    B Z
    B Z
    C Z
    C X
    C Y
    C X
    A Y
    C X
    C X
    C Z
    C X
    B Y
    B Y
    C X
    C Z
    C Y
    B X
    B Y
    A Y
    B Y
    C X
    C X
    C Z
    B Y
    C X
    C Y
    C Y
    A Z
    B Y
    C X
    B X
    A Y
    B Y
    B Y
    C Z
    A X
    C X
    A Y
    C Z
    C Z
    B X
    A Y
    C Y
    B Y
    C X
    A Y
    B Y
    C X
    C X
    A Y
    B Y
    C Z
    C X
    C Z
    A X
    A Z
    C X
    C Z
    C X
    C Y
    C X
    B Y
    C Z
    C X
    B Y
    C Z
    C X
    B Z
    B X
    C X
    C X
    B X
    C X
    C Z
    C X
    C X
    C X
    C Y
    B X
    C X
    C X
    B Y
    B Y
    C X
    B Y
    C X
    C Z
    C X
    B Y
    B Y
    B Y
    C Z
    C X
    A Z
    A Y
    C X
    C Z
    C Z
    A Z
    B Y
    A Z
    C Z
    B Z
    B Y
    C X
    B Y
    C X
    B Y
    A Y
    C X
    C X
    C X
    C X
    B Y
    A Z
    B X
    C X
    C X
    C X
    C Z
    B Y
    C X
    B Y
    B Y
    B Y
    C X
    C Y
    B Z
    C X
    B Y
    B X
    C X
    C X
    B Y
    C X
    B X
    C X
    C X
    A Z
    C X
    A Z
    C X
    C X
    C Z
    C X
    B Y
    C Z
    B Y
    C X
    B Y
    C Z
    B X
    C X
    A Y
    C Y
    C X
    C X
    B Y
    B Y
    C X
    C Z
    C Z
    C Z
    C X
    C X
    B Z
    B Z
    A Z
    B Y
    B Y
    B Y
    A X
    C X
    B X
    B X
    C X
    C X
    C X
    C X
    B X
    B X
    B Y
    B Y
    B Y
    B X
    C X
    C Z
    B Y
    B Y
    A Y
    A Y
    C X
    C X
    C X
    B X
    C Z
    C X
    C X
    B Y
    C X
    C X
    C X
    C X
    B X
    B X
    A Y
    B Z
    C Z
    B Z
    A X
    C X
    B X
    C X
    B Z
    C Z
    B X
    B Y
    C Z
    C Y
    C X
    C X
    C Z
    C X
    C X
    C X
    C Z
    C X
    B Y
    C X
    C X
    C X
    A Z
    C Z
    C X
    C X
    C X
    C Y
    A Y
    C Z
    B X
    B X
    C X
    C X
    C Z
    A Y
    C Z
    C X
    B Y
    B Y
    B Z
    B Y
    C X
    B X
    C X
    C X
    B Y
    C Y
    C Z
    C X
    C Z
    B Y
    C Y
    B Y
    B X
    C Y
    B X
    C X
    C X
    B Z
    C Y
    B Y
    B Y
    B Z
    C Y
    B X
    B Y
    C Z
    A Y
    B Y
    B Y
    A Z
    C X
    C Z
    B Z
    C X
    C X
    B Y
    C X
    C X
    B X
    C X
    C Z
    C Z
    B Y
    B X
    B Z
    B Z
    B X
    C X
    C X
    C X
    C X
    B Y
    A Y
    B X
    C X
    C X
    C X
    B Y
    C Z
    B X
    C Y
    C Z
    B Z
    C X
    C X
    B Y
    C Z
    B Y
    C X
    C X
    B Y
    B X
    C X
    C X
    C X
    C X
    B Y
    A Y
    C Y
    C X
    C X
    B Y
    B X
    B Y
    C X
    C X
    C Z
    C X
    C Z
    A Y
    C X
    C Z
    B Y
    C Z
    B X
    A X
    C X
    C Z
    C Y
    B Y
    C X
    C Z
    C Z
    B X
    C X
    C X
    C Z
    C X
    A Y
    B Y
    C X
    C X
    C X
    C X
    C X
    C X
    B X
    B X
    C Z
    B Y
    C X
    C X
    A Z
    C X
    C Z
    B Y
    C Z
    C Y
    C X
    C Y
    C X
    C X
    C Z
    B Y
    B Y
    B Z
    B Y
    C Z
    C X
    C Z
    B Y
    C Z
    C X
    C X
    C X
    C Y
    C X
    C X
    B X
    C X
    B Y
    B X
    B X
    B Y
    B Y
    B Z
    C Z
    A Y
    B X
    B Y
    C Z
    C Y
    C X
    C X
    C Z
    A Y
    C X
    C Z
    C X
    B X
    B Z
    C Z
    B Y
    C X
    C X
    C Z
    B X
    B Y
    C Z
    B Z
    B Z
    C X
    C X
    C X
    B Y
    C X
    C Z
    C X
    C X
    B Y
    C X
    B Y
    B Y
    C X
    C X
    C X
    B Y
    B Z
    C X
    C X
    B X
    B Y
    C X
    C Y
    B Y
    A Y
    C X
    C X
    C X
    C Y
    C X
    C Z
    A Y
    B X
    C Z
    C X
    C X
    C X
    B Y
    B Y
    C Z
    C Z
    C Y
    C Z
    C X
    B Y
    B Y
    C X
    B Y
    C X
    B Y
    C X
    C X
    C X
    C X
    C Z
    B Y
    B Z
    C X
    C X
    B Y
    C X
    B Y
    C X
    B Y
    C Y
    B Y
    C X
    B Y
    C X
    B Y
    C X
    B Z
    C X
    B X
    B X
    B Y
    B X
    B Z
    C X
    B Y
    C X
    B Z
    B Y
    C X
    C Y
    C Z
    A Z
    C X
    C X
    B Y
    A X
    C X
    B Z
    C Z
    B X
    C X
    C X
    B Y
    B Z
    A Z
    A Z
    C X
    C X
    C X
    C X
    A Y
    B Y
    B Y
    C X
    B Z
    C Z
    C X
    C X
    B Z
    C Z
    B Y
    C Z
    C Y
    C Z
    B Y
    C Z
    B Z
    B Y
    C X
    C Z
    C X
    C X
    C Y
    C X
    B X
    A X
    B X
    C X
    C Z
    C Z
    C Z
    B Y
    B X
    C X
    B Y
    C X
    C X
    C X
    A Y
    C Z
    A Y
    C X
    C X
    C X
    B Z
    C X
    C Z
    C X
    B Y
    B Y
    B X
    C X
    C Z
    C Z
    A Z
    B Y
    C Y
    B Y
    C Z
    C X
    A Z
    C X
    B X
    B Z
    C X
    B Y
    C Y
    C X
    B X
    C Z
    C Z
    C Z
    C X
    C X
    C X
    A Y
    C Z
    B X
    B X
    B Y
    B X
    A Y
    C X
    B Y
    C X
    C X
    C X
    B X
    A X
    B Y
    C X
    C Z
    B X
    A X
    C X
    B Y
    C X
    C Z
    A X
    C X
    B Z
    C X
    C Z
    C Z
    B Z
    C Z
    C X
    B Y
    C X
    B Y
    C Y
    B Y
    C Y
    B Y
    C X
    B X
    C Y
    C X
    C X
    B Y
    C Y
    A Z
    C X
    C X
    C X
    C X
    B Y
    B Y
    C X
    C Z
    C X
    C X
    C X
    B Y
    B Y
    B Y
    C X
    B Y
    B X
    C Y
    B Y
    C X
    C X
    B Y
    C X
    C Y
    C X
    B Y
    C X
    B Y
    C Z
    C X
    C X
    C Z
    C Z
    B Z
    C Z
    C X
    C X
    C Z
    C Z
    B X
    C Y
    C Y
    C X
    C X
    B Z
    C Z
    B Y
    B Y
    C Z
    C X
    C X
    B Y
    C X
    C X
    C Z
    C X
    C Z
    A Z
    B Y
    C Z
    C X
    A X
    A Z
    B Y
    B Y
    B Y
    B Y
    C Z
    B X
    C X
    B Y
    B Y
    C X
    B Y
    B Y
    C Z
    C X
    B Y
    C Y
    C X
    C Z
    C X
    A Y
    C X
    C X
    C Z
    A X
    B Y
    B Y
    B Z
    B Y
    C Z
    C X
    C X
    B Y
    C X
    C Z
    C Z
    C X
    B X
    C Z
    C Z
    B Y
    B Y
    C X
    B Y
    B X
    C X
    A Y
    B Y
    B Y
    C X
    C Z
    B X
    C X
    C Z
    A Z
    B Y
    C X
    C Z
    C X
    C X
    C X
    B Y
    B X
    B Y
    B X
    C X
    C X
    C Z
    C X
    C X
    C X
    C X
    B Y
    C X
    B Y
    C Z
    B X
    C Z
    C X
    B Z
    C X
    A Y
    C X
    C X
    C X
    C X
    C X
    C X
    B Y
    C X
    C X
    B Y
    C Z
    C Z
    B X
    C X
    A X
    C X
    C X
    B X
    C Z
    B Y
    B X
    C X
    C X
    B Y
    C Z
    C Y
    B Y
    C Y
    B X
    C X
    B Y
    C X
    C Z
    C Z
    B Y
    B Y
    A Z
    B X
    C X
    C X
    C Z
    C X
    C X
    B X
    C Z
    A Y
    C Z
    C X
    C Z
    C X
    C Z
    C Z
    A Z
    A Y
    A Y
    C Z
    C X
    A X
    C X
    B Y
    B Y
    C X
    C Z
    B X
    B Z
    C X
    C Z
    B Y
    C Z
    B Y
    C Z
    B Z
    B Y
    C X
    C X
    B Y
    C X
    C X
    C Z
    B X
    C Z
    C Z
    B Y
    A Z
    C X
    B Y
    C X
    C Z
    C X
    C X
    B Y
    C Z
    A Z
    C X
    C X
    B X
    C X
    C X
    B Z
    B Y
    B Y
    B X
    C Y
    C X
    B Y
    B Y
    C X
    C X
    C X
    A Z
    C Z
    A Y
    C X
    B Y
    B Y
    C X
    C Z
    C X
    C X
    B X
    B Y
    C Z
    B Z
    C Y
    C X
    C X
    B Z
    B X
    C Z
    C X
    C X
    C X
    C X
    C X
    C X
    C X
    C X
    B Y
    C Y
    C X
    B Y
    B Y
    B Y
    C X
    C X
    B X
    C Y
    B Y
    C X
    B Z
    C X
    C X
    B Z
    C Z
    B X
    B Z
    C Z
    B Z
    C X
    B Y
    C X
    C Y
    A Y
    B X
    B Y
    B Z
    C X
    B Z
    A Y
    C Z
    C Z
    C Y
    B Y
    B Y
    B Z
    C X
    C X
    A Y
    C Z
    C X
    C X
    C X
    C Z
    C X
    C X
    C X
    C X
    A Y
    C X
    C Z
    C Z
    C X
    B Z
    C X
    C X
    A Y
    B Z
    C Y
    A X
    C X
    C X
    C Z
    C X
    C X
    C X
    A Y
    A Y
    C Z
    B Z
    B X
    C X
    C X
    C X
    A Z
    B Y
    C Z
    C Z
    C X
    C X
    C Z
    C X
    B Y
    B X
    C Z
    C X
    B Y
    B Z
    C X
    C X
    B Y
    C Z
    C Z
    C X
    B Y
    C X
    C X
    B Y
    A Z
    B X
    C X
    C X
    C X
    B Y
    C X
    C Z
    B Y
    B X
    C Z
    B Y
    B X
    C X
    C X
    A Y
    C Z
    C X
    C X
    C Z
    B Z
    B Y
    B Y
    B Z
    C X
    A Y
    B X
    C X
    C X
    B Y
    C X
    C Z
    B Y
    C X
    C X
    C X
    C Y
    B Y
    B X
    B Y
    C X
    C X
    C Z
    C Z
    A Y
    C X
    C Y
    B Y
    B Y
    B X
    C X
    C X
    B X
    C X
    C X
    C X
    B X
    C X
    C Z
    C X
    A X
    B Y
    C Z
    B Y
    C Z
    C X
    C Z
    C X
    B Y
    C X
    B X
    A X
    A Z
    C X
    C Z
    C X
    C X
    B Y
    B X
    B X
    B Y
    B Z
    C Z
    C X
    C Z
    B X
    C X
    B Y
    B X
    B Y
    B Y
    C Y
    C X
    B X
    B Y
    C X
    C Z
    C X
    B Y
    C X
    C X
    B Y
    C X
    C X
    C Z
    C X
    B Z
    A X
    C X
    C X
    B X
    C Y
    C X
    B Y
    C X
    C X
    A Y
    A X
    C X
    B Z
    C X
    A X
    C X
    C Y
    C X
    C X
    C X
    C Y
    C X
    C X
    B Z
    C X
    C X
    B X
    B X
    C X
    C X
    B Z
    C X
    A Y
    B X
    B Y
    C X
    C X
    B X
    B Y
    C Z
    B X
    B Y
    C X
    C X
    C X
    C Z
    C X
    C X
    C X
    A Y
    A Z
    C Z
    A Y
    B Y
    B Y
    C Y
    C X
    C Y
    C X
    B Y
    C X
    C Z
    A Y
    B X
    C Z
    B Z
    C Z
    A Z
    A X
    B Y
    B Y
    C X
    C Y
    B Y
    B Y
    B Y
    C Y
    C X
    B Y
    B Y
    C X
    C X
    B Y
    C X
    B Y
    B Y
    C Y
    C Y
    A Y
    B Y
    B Y
    C X
    B X
    B X
    C X
    B Y
    A X
    C Z
    C Z
    C X
    A X
    B Y
    C Y
    B Y
    C Z
    C Z
    B Y
    B X
    B Y
    B X
    B X
    C Y
    C Y
    B Z
    B Y
    C X
    C X
    C Y
    C X
    C X
    C X
    C Z
    B Y
    B Y
    C X
    C X
    C Z
    B Y
    A Y
    B Y
    B Y
    B X
    C X
    C Z
    C X
    C Z
    C X
    B Z
    C Z
    C X
    B Y
    A Y
    C X
    A Y
    B Y
    C Y
    A X
    C X
    B Z
    C X
    B Y
    A Z
    C X
    C Z
    C Z
    C X
    A Y
    C Z
    C X
    C X
    B Y
    C Z
    B Z
    B Y
    B Y
    C Z
    A Y
    C X
    B X
    C Z
    C X
    B Y
    A Y
    B Y
    B Y
    C X
    C Y
    B Z
    B Y
    B X
    C Z
    C X
    C X
    B Y
    A Y
    B Y
    C X
    C X
    B Y
    B Y
    C X
    C Z
    C X
    B Y
    C X
    B Y
    B Y
    C X
    C Z
    A Z
    B X
    C Z
    B X
    C X
    C Z
    B Y
    B Z
    C X
    B Y
    C Z
    C X
    C X
    C X
    B Z
    C X
    C Z
    C X
    C X
    B Y
    B Y
    C X
    A X
    A X
    C X
    C X
    B X
    C X
    C Z
    B Y
    C Z
    C Z
    C X
    A Y
    A Z
    C X
    C X
    B Y
    B Y
    B Y
    C Z
    B Y
    C X
    C X
    C X
    B X
    B Y
    B X
    B Y
    A Y
    C X
    B X
    C X
    C Y
    C Z
    C Y
    C Z
    C X
    A Y
    C X
    B Y
    C Z
    C Z
    C X
    B Y
    B Y
    B Y
    C X
    A X
    C X
    B X
    C Y
    C X
    B Y
    C Z
    C X
    C Z
    C Z
    C Z
    A Y
    B Y
    B Y
    C X
    A Y
    C Y
    B Y
    C X
    B Z
    B Y
    C X
    B Y
    C Z
    B Y
    C Z
    C X
    B Z
    C Z
    C Z
    B X
    C X
    C Y
    B X
    B Y
    C X
    A X
    B Y
    C Z
    B Y
    C X
    C X
    B X
    C X
    B Y
    C X
    B Y
    C Z
    C Z
    C X
    C X
    A Y
    B Y
    C Y
    B Y
    B Y
    B Y
    C X
    C Y
    A X
    A Y
    C X
    C X
    B X
    B Y
    C X
    C Z
    C X
    B Y
    C X
    C Y
    B Z
    B X
    C X
    A Y
    C X
    C Y
    C Z
    B X
    C X
    C Z
    C Y
    C X
    C Z
    C X
    C Z
    B Y
    B Z
    C X
    A Y
    C X
    C X
    B X
    B Y
    C X
    C X
    B Y
    C X
    B Z
    C X
    C X
    C X
    B Z
    A Y
    B X
    B Y
    B Y
    B Y
    B Y
    C X
    C Z
    B Z
    C Z
    C X
    B Y
    C X
    B Y
    A Y
    C Y
    B X
    B Z
    C X
    C X
    C X
    A Y
    B X
    B Z
    C X
    C Z
    B Y
    C Z
    C X
    B Y
    B Z
    C Y
    C Y
    C X
    C X
    B Z
    B Y
    A Y
    C Z
    B Y
    B Y
    A Z
    C X
    B Y
    A Y
    C X
    C Z
    B Y
    C X
    A Z
    C X
    B Z
    B Y
    C Z
    B Y
    C X
    B X
    B Y
    C X
    B Y
    C X
    C Y
    B Y
    B X
    C X
    C Y
    C X
    B Y
    C Y
    C X
    C X
    B Y
    B Y
    B X
    C X
    B X
    A Y
    C X
    B Y
    C Y
    C Z
    C X
    B Z
    B X
    C X
    C X
    C Z
    C Z
    B Y
    C X
    C X
    B Y
    C X
    C X
    A Y
    C Z
    C X
    A X
    B Y
    C X
    C X
    C X
    C Z
    B Y
    C X
    B Y
    B Z
    C X
    C X
    B Y
    A Z
    C X
    C X
    C X
    A Y
    B Y
    C X
    C Y
    C Z
    A X
    C X
    C X
    B X
    B Y
    C X
    B Y
    B X
    B X
    C X
    C Z
    B Y
    B Y
    C Z
    B Y
    A Y
    C X
    B Y
    C X
    C Z
    C X
    C Z
    A Y
    C X
    B Z
    C Z
    B Z
    C Z
    C X
    B Y
    A Z
    C X
    C Z
    B Y
    B Y
    C X
    C Z
    A X
    B X
    B Y
    C X
    C X
    B Z
    C X
    C X
    C Z
    A Y
    C X
    A X
    C X
    C X
    B X
    C Z
    B Y
    B Y
    C Z
    B Y
    B Y
    C X
    C X
    B Z
    B Y
    B Y
    C X
    A X
    C X
    B Y
    C X
    B Y
    C Z
    A Z
    C X
    C Z
    C Y
    B Y
    C X
    C Z
    C Z
    B Y
    B Z
    B X
    C Z
    C Z
    B Z
    B Z
    B Y
    C X
    B Y
    B Y
    B X
    B Y
    C X
    C Z
    C Z
    B Y
    B Y
    B Z
    C X
    C Z
    C Z
    C Z
    C X
    C X
    B Y
    C X
    B Y
    B Y
    C Y
    C X
    B Y
    C X
    C X
    C X
    C Z
    A Z
    C X
    A X
    A Y
    B Y
    C X
    B Y
    B Y
    C Y
    C X
    C X
    C X
    B Y
    C X
    A Y
    B Y
    C Z
    C Z
    C X
    A Y
    C X
    B Y
    C X
    C Z
    C Z
    C Y
    B Y
    C X
    B Y
    B Y
    C Y
    C X
    B X
    C Z
    C X
    C X
    C X
    B Y
    B Z
    C Z
    C X
    C Z
    B Y
    A Z
    C X
    C Z
    B Z
    A Z
    B Y
    B Y
    C X
    C Z
    C X
    C X
    C X
    C X
    C Z
    C X
    B Y
    C Y
    B Y
    C X
    C Z
    B Z
    B X
    C Y
    C X
    B Y
    C X
    B X
    C X
    C X
    C Z
    C X
    B Y
    C X
    C Z
    C Z
    B X
    C X
    B Y
    C X
    B Y
    B X
    C X
    A Y
    C X
    C X
    C Z
    B Y
    C X
    B Z
    C X
    C X
    C X
    C X
    B Z
    C X
    B Y
    C X
    B X
    C Z
    C X
    B Y
    C X
    C X
    C X
    A Y
    B Z
    C Z
    A Z
    C X
    B X
    C Z
    C Y
    B Z
    C X
    B Y
    B Z
    C X
    C Z
    B X
    C X
    C Z
    C X
    B Y
    B X
    B Y
    B Y
    C Y
    C Y
    C Y
    C X
    B Y
    B Y
    C X
    C X
    C Y
    B Y
    C X
    C X
    C Z
    C X
    B X
    C X
    C Y
    C X
    C X
    C X
    C Z
    C Z
    C Y
    C Z
    C Z
    B X
    C X
    C X
    B Y
    C X
    C X
    C Z
    B Y
    C X
    C X
    C X
    A Y
    A X
    C Z
    C Z
    C X
    C X
    B X
    B Y
    C X
    C Y
    B Y
    B Y
    C X
    C Z
    C X
    C Z
    B X
    C X
    C X
    B Y
    B Y
    B Y
    C X
    C X
    C X
    C Z
    C X
    C X
    B Z
    C X
    C Y
    C X
    A Y
    C X
    C X
    B X
    C X
    C X
    B Z
    C X
    C X
    C Z
    C Z
    C X
    C Y
    C X
    C X
    C X
    C X
    B Y
    C X
    C Y
    C Z
    C X
    C X
    C X
    C X
    B Y
    B X
    C X
    C X
    C Y
    C X
    B Y
    C X
    C X
    C Z
    C Z
    C X
    """
}