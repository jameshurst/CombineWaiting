/// The result of a publisher wait operation.
public enum WaitResult<Value, Failure: Error> {
    /// The publisher did not complete.
    case partial(values: [Value])
    /// The publisher completed successfully.
    case complete(values: [Value])
    /// The publisher completed with an error.
    case failure(values: [Value], error: Failure)
}

extension WaitResult: Equatable where Value: Equatable, Failure: Equatable {}

public extension WaitResult {
    /// Returns the values produced by the publisher.
    /// - Throws:
    ///   - Any error produced by the publisher.
    /// - Returns: An array of values produced by the publisher.
    func values() throws -> [Value] {
        switch self {
        case let .partial(values), let .complete(values):
            return values
        case let .failure(_, error):
            throw error
        }
    }

    /// Ensures that the publisher produced the given number of values and returns those values.
    /// - Parameter count: The number of expected values.
    /// - Throws:
    ///   - Any error produced by the publisher.
    ///   - `WaitResultError.unexpectedNumberOfValues` if the publisher produced an unexpected number of values.
    /// - Returns: An array of values produced by the publisher.
    func values(_ count: Int) throws -> [Value] {
        let values = try self.values()
        guard values.count == count else { throw WaitResultError.unexpectedNumberOfValues(values.count) }
        return values
    }

    /// Ensures that the publisher produced a single value and returns that value.
    /// - Throws:
    ///   - Any error produced by the publisher.
    ///   - `WaitResultError.unexpectedNumberOfValues` if the publisher produced an unexpected number of values.
    /// - Returns: The single value produced by the publisher.
    func singleValue() throws -> Value {
        try values(1)[0]
    }

    /// Returns the error produced by the publisher.
    /// - Throws:
    ///   - `WaitResultError.noFailure` if the publisher did not complete with an error.
    /// - Returns: The error produced by the publisher.
    func error() throws -> Failure {
        switch self {
        case let .failure(_, error):
            return error
        case .partial, .complete:
            throw WaitResultError.noFailure
        }
    }
}

public extension WaitResult where Failure == Never {
    /// Returns the values produced by the publisher.
    /// - Returns: An array of values produced by the publisher.
    func values() -> [Value] {
        switch self {
        case let .partial(values), let .complete(values):
            return values
        }
    }
}
