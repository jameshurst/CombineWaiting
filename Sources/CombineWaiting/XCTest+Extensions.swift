import XCTest

/// Asserts that the result is partial or complete and contains the given values.
public func XCTAssertEqual<T, E: Error>(
    _ result: WaitResult<T, E>,
    _ values: [T],
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
) where T: Equatable {
    switch result {
    case let .partial(inner), let .complete(inner):
        XCTAssertEqual(values, inner, message, file: file, line: line)
    case let .failure(_, error):
        XCTFail("Unexpected failure (\(String(describing: error)))", file: file, line: line)
    }
}

/// Asserts that the result is partial or complete and contains a single value.
public func XCTAssertEqual<T, E: Error>(
    _ result: WaitResult<T, E>,
    _ value: T,
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
) where T: Equatable {
    switch result {
    case let .partial(values), let .complete(values):
        if values.isEmpty {
            XCTFail("(\(String(describing: result))) does not contain any values", file: file, line: line)
        } else if values.count > 1 {
            XCTFail("(\(String(describing: result))) contains more than one value", file: file, line: line)
        } else {
            XCTAssertEqual(value, values[0], message, file: file, line: line)
        }
    case .failure:
        XCTFail("Unexpected failure (\(String(describing: result)))", file: file, line: line)
    }
}

/// Asserts that the result is a failure and contains the given error.
public func XCTAssertEqual<T, E: Error>(
    _ result: WaitResult<T, E>,
    _ error: E,
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
) where E: Equatable {
    switch result {
    case let .failure(_, inner):
        XCTAssertEqual(error, inner, message, file: file, line: line)
    case .partial, .complete:
        XCTFail("Expected failure and instead found (\(String(describing: result)))", file: file, line: line)
    }
}

/// Asserts that the result is partial or complete and contains a single `true` value.
public func XCTAssertTrue<E: Error>(
    _ result: WaitResult<Bool, E>,
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
) {
    switch result {
    case let .partial(values), let .complete(values):
        if values.isEmpty {
            XCTFail("(\(String(describing: result))) does not contain any values", file: file, line: line)
        } else if values.count > 1 {
            XCTFail("(\(String(describing: result))) contains more than one value", file: file, line: line)
        } else {
            XCTAssertTrue(values[0], message, file: file, line: line)
        }
    case .failure:
        XCTFail("Unexpected failure (\(String(describing: result)))", file: file, line: line)
    }
}

/// Asserts that the result is partial or complete and contains a single `false` value.
public func XCTAssertFalse<E: Error>(
    _ result: WaitResult<Bool, E>,
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
) {
    switch result {
    case let .partial(values), let .complete(values):
        if values.isEmpty {
            XCTFail("(\(String(describing: result))) does not contain any values", file: file, line: line)
        } else if values.count > 1 {
            XCTFail("(\(String(describing: result))) contains more than one value", file: file, line: line)
        } else {
            XCTAssertFalse(values[0], message, file: file, line: line)
        }
    case .failure:
        XCTFail("Unexpected failure (\(String(describing: result)))", file: file, line: line)
    }
}
