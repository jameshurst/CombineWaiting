/// Errors that can occur during wait result operations.
public enum WaitError: Error {
    /// There was no value at the given index.
    case noValue
    /// A failure was expected but a successful result was found instead.
    case noFailure
}
