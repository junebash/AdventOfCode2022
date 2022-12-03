func printResults<D: Day>(_ day: D) async {
    func printResult(_ number: Int, op: (D) -> () async throws -> Any) async {
        print("Solution \(number): ", terminator: "")
        do {
            let result = try await op(day)()
            print(result)
        } catch {
            print("ERROR:", error)
        }
    }

    await printResult(1, op: D.solution1)
    await printResult(2, op: D.solution2)
}

let days: [any Day] = [
    Day1(),
    Day2(),
    Day3()
]

for day in days {
    print("🎄 Day \(day.dayOfMonth) 🎄")
    await printResults(day)
    print("\n-----------------------------\n")
}
