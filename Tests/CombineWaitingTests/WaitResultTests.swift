import Combine
import CombineWaiting
import XCTest

class WaitResultTests: XCTestCase {
    func test_values_shouldReturnValues() throws {
        XCTAssertEqual(try WaitResult<Int, SomeError>.partial(values: [1]).values(), [1])
        XCTAssertEqual(try WaitResult<Int, SomeError>.complete(values: [1]).values(), [1])
    }

    func test_values_withNeverFailure_shouldReturnValues() {
        XCTAssertEqual(WaitResult<Int, Never>.partial(values: [1]).values(), [1])
        XCTAssertEqual(WaitResult<Int, Never>.complete(values: [1]).values(), [1])
    }

    func test_values_withFailure_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, SomeError>.failure(values: [1], error: .some).values()
            XCTFail("Expected throw")
        } catch SomeError.some {
            // success
        } catch {
            throw error
        }
    }

    func test_values_withCount_withCorrectNumberOfValues_shouldReturnValues() throws {
        XCTAssertEqual(try WaitResult<Int, Never>.partial(values: [1, 2]).values(2), [1, 2])
    }

    func test_values_withCount_withUnexpectedNumberOfValues_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, Never>.partial(values: [1, 2, 3]).values(2)
            XCTFail("Expected throw")
        } catch let WaitError.unexpectedNumberOfValues(count) where count == 3 {
            // success
        } catch {
            throw error
        }
    }

    func test_singleValue_withOneValue_shouldReturnValue() throws {
        XCTAssertEqual(try WaitResult<Int, Never>.partial(values: [1]).singleValue(), 1)
    }

    func test_singleValue_withUnexpectedNumberOfValues_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, Never>.partial(values: [1, 2]).singleValue()
            XCTFail("Expected throw")
        } catch let WaitError.unexpectedNumberOfValues(count) where count == 2 {
            // success
        } catch {
            throw error
        }
    }

    func test_error_withFailure_shouldReturnError() throws {
        XCTAssertEqual(try WaitResult<Int, SomeError>.failure(values: [], error: .some).error(), .some)
    }

    func test_error_withSuccess_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, SomeError>.partial(values: [1]).error()
            XCTFail("Expected WaitError.noFailure")
        } catch WaitError.noFailure {
            // success
        } catch {
            throw error
        }

        do {
            _ = try WaitResult<Int, SomeError>.complete(values: [1]).error()
            XCTFail("Expected WaitError.noFailure")
        } catch WaitError.noFailure {
            // success
        } catch {
            throw error
        }
    }
}
