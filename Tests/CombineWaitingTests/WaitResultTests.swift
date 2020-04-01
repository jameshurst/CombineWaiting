import Combine
import CombineWaiting
import XCTest

class WaitResultTests: XCTestCase {
    func test_hasValues_withValuesNoValues_shouldBeFalse() throws {
        XCTAssertFalse(try WaitResult<Int, SomeError>.partial(values: []).hasValue())
        XCTAssertFalse(try WaitResult<Int, SomeError>.complete(values: []).hasValue())
    }

    func test_hasValues_withValues_shouldBeTrue() throws {
        XCTAssertTrue(try WaitResult<Int, SomeError>.partial(values: [1]).hasValue())
        XCTAssertTrue(try WaitResult<Int, SomeError>.complete(values: [1]).hasValue())
    }

    func test_hasValues_withValuesNoValues_andNeverFailure_shouldBeFalse() {
        XCTAssertFalse(WaitResult<Int, Never>.partial(values: []).hasValue())
        XCTAssertFalse(WaitResult<Int, Never>.complete(values: []).hasValue())
    }

    func test_hasValues_withValues_andNeverFailure_shouldBeTrue() {
        XCTAssertTrue(WaitResult<Int, Never>.partial(values: [1]).hasValue())
        XCTAssertTrue(WaitResult<Int, Never>.complete(values: [1]).hasValue())
    }

    func test_isEmpty_withFailure_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, SomeError>.failure(values: [1], error: .some).hasValue()
            XCTFail("Expected SomeError.some")
        } catch SomeError.some {
            // success
        } catch {
            throw error
        }
    }

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
            XCTFail("Expected SomeError.some")
        } catch SomeError.some {
            // success
        } catch {
            throw error
        }
    }

    func test_value_shouldReturnValue() throws {
        XCTAssertEqual(try WaitResult<Int, SomeError>.partial(values: [1]).value(), 1)
        XCTAssertEqual(try WaitResult<Int, SomeError>.complete(values: [1]).value(), 1)
    }

    func test_value_withFailure_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, SomeError>.failure(values: [1], error: .some).value()
            XCTFail("Expected SomeError.some")
        } catch SomeError.some {
            // success
        } catch {
            throw error
        }
    }

    func test_value_withInvalidIndex_shouldThrow() throws {
        do {
            _ = try WaitResult<Int, SomeError>.partial(values: [1]).value(at: 1)
            XCTFail("Expected WaitError.noValue")
        } catch WaitError.noValue {
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
            XCTFail(String(describing: error))
        }

        do {
            _ = try WaitResult<Int, SomeError>.complete(values: [1]).error()
            XCTFail("Expected WaitError.noFailure")
        } catch WaitError.noFailure {
            // success
        } catch {
            XCTFail(String(describing: error))
        }
    }
}
