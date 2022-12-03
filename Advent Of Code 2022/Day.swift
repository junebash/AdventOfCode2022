public protocol Day {
    var dayOfMonth: Int { get }
    var input: String { get }

    func solution1() async throws -> Any
    func solution2() async throws -> Any
}

struct Unimplemented: Error {}

extension Day {
    func solution1() async throws -> Any {
        throw Unimplemented()
    }
    func solution2() async throws -> Any {
        throw Unimplemented()
    }
}
