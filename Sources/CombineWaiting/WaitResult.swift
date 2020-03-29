/// The result of a wait operation.
public enum WaitResult<Value, Failure: Error> {
    /// The publisher emitted a sequence of values without a completion. This may be an empty array if the wait
    /// timed out before the publisher emitted any values.
    case partial(values: [Value])
    /// The publisher completed successfully after emitting some number of values.
    case complete(values: [Value])
    /// The publisher completed with a failure after emitting some number of values.
    case failure(values: [Value], error: Failure)
}

extension WaitResult: Equatable where Value: Equatable, Failure: Equatable {}

public extension WaitResult {
    /// Returns whether this result contains any values.
    /// - Throws:
    ///     - The contained error if this result is a failure.
    /// - Returns: Whether this result contains any values.
    func hasValue() throws -> Bool {
        try !values().isEmpty
    }

    /// Returns the values contained in this result.
    /// - Throws:
    ///     - The contained error if this result is a failure.
    /// - Returns: The array of values.
    func values() throws -> [Value] {
        switch self {
        case let .partial(values), let .complete(values):
            return values
        case let .failure(_, error):
            throw error
        }
    }

    /// Returns the value at the given index.
    /// - Parameter index: The index of the value to retrieve.
    /// - Throws:
    ///     - `WaitError.noValue` if there is no value at the given index.
    /// - Returns: The value at the given index.
    func value(at index: Int = 0) throws -> Value {
        let values = try self.values()
        guard index < values.count else { throw WaitError.noValue }
        return values[index]
    }
}

public extension WaitResult where Failure == Never {
    /// Returns whether this result contains any values.
    /// - Returns: Whether this result contains any values.
    func hasValue() -> Bool {
        !values().isEmpty
    }

    /// Returns the values contained in this result.
    /// - Returns: The array of values.
    func values() -> [Value] {
        switch self {
        case let .partial(values), let .complete(values):
            return values
        }
    }
}
