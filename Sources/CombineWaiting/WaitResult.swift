/// The result of a publisher wait operation.
public enum WaitResult<Value, Failure: Error> {
    /// The publisher emitted a sequence of values without a completion. This may be an empty array if the wait
    /// timed out before the publisher emitted any values.
    case partial(values: [Value])
    /// The publisher completed successfully after emitting some values.
    case complete(values: [Value])
    /// The publisher completed with a failure after emitting some values.
    case failure(values: [Value], error: Failure)
}

extension WaitResult: Equatable where Value: Equatable, Failure: Equatable {}

public extension WaitResult {
    /// Returns the values emitted by the publisher.
    /// - Throws:
    ///   - The the error emitted by the publisher if it completed with a failure.
    /// - Returns: An array containing the values emitted by the publisher.
    func values() throws -> [Value] {
        switch self {
        case let .partial(values), let .complete(values):
            return values
        case let .failure(_, error):
            throw error
        }
    }

    /// Returns exactly the given number of values or throws an error if the publisher did not emit exactly the given
    /// number of values.
    /// - Parameter count: The number of values to return.
    /// - Throws:
    ///   - `WaitError.unexpectedNumberOfValues` if the publisher did not emit exactly the given number of values.
    /// - Returns: An array containing exactly the given number of values.
    func values(_ count: Int) throws -> [Value] {
        let values = try self.values()
        guard values.count == count else { throw WaitError.unexpectedNumberOfValues(values.count) }
        return values
    }

    /// Returns the emitted value or throws an error if the publisher did not emit exactly one value.
    /// - Throws:
    ///   - The the error emitted by the publisher if it completed with a failure.
    ///   - `WaitError.unexpectedNumberOfValues` if the publisher did not emit exactly one value.
    /// - Returns: The single value emitted by the publisher.
    func singleValue() throws -> Value {
        try values(1)[0]
    }

    /// Returns the error emitted by the publisher if it completed with a failure.
    /// - Throws:
    ///   - `WaitError.noFailure` if the publisher did not complete with a failure.
    /// - Returns: The error emitted by the publisher.
    func error() throws -> Failure {
        switch self {
        case let .failure(_, error):
            return error
        case .partial, .complete:
            throw WaitError.noFailure
        }
    }
}

public extension WaitResult where Failure == Never {
    /// Returns the values emitted by the publisher.
    /// - Returns: An array containing the values emitted by the publisher.
    func values() -> [Value] {
        switch self {
        case let .partial(values), let .complete(values):
            return values
        }
    }
}
