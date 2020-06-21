/// Errors that can occur during wait result operations.
public enum WaitError: Error {
    /// A failure was expected but a successful result was found instead.
    case noFailure
    /// An unexpected number of values was received.
    case unexpectedNumberOfValues(Int)
}
