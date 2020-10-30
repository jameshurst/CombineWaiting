/// Errors that can occur during wait result operations.
public enum WaitResultError: Error {
    /// A failure was expected but a partial or complete result was found instead.
    case noFailure
    /// An unexpected number of values was produced.
    case unexpectedNumberOfValues(Int)
}
