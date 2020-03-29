import Combine
import CombineWaiting
import XCTest

class WaiterTests: XCTestCase {
    func test_wait_shouldTimeOut() {
        let subject = PassthroughSubject<Int, Never>()
        let start = Date()
        _ = subject.wait(timeout: 1)
        XCTAssertLessThanOrEqual(start.timeIntervalSinceNow, -1)
    }

    func test_wait_shouldExecuteOnce() {
        let subject = PassthroughSubject<Int, Never>()
        var count = 0
        async {
            subject.send(1)
            subject.send(2)
            subject.send(completion: .finished)
        }
        _ = subject.wait(timeout: 1, executing: { count += 1 })
        XCTAssertEqual(count, 1)
    }

    func test_wait_withPartial() {
        let subject = PassthroughSubject<Int, SomeError>()
        async {
            subject.send(1)
            subject.send(2)
        }
        let result = subject.wait(timeout: 1)
        XCTAssertEqual(result, .partial(values: [1, 2]))
    }

    func test_wait_withComplete() {
        let subject = PassthroughSubject<Int, SomeError>()
        async {
            subject.send(1)
            subject.send(2)
            subject.send(completion: .finished)
        }
        let result = subject.wait(timeout: 1)
        XCTAssertEqual(result, .complete(values: [1, 2]))
    }

    func test_wait_withFirst() {
        let subject = PassthroughSubject<Int, SomeError>()
        async {
            subject.send(1)
            subject.send(2)
            subject.send(completion: .finished)
        }
        let result = subject.first().wait(timeout: 1)
        XCTAssertEqual(result, .complete(values: [1]))
    }

    func test_wait_recursive() {
        let subject1 = PassthroughSubject<Int, Never>()
        let subject2 = PassthroughSubject<Int, Never>()
        let cancellable = subject2.map { $0 + 1 }.subscribe(subject1)
        let result = subject1.wait {
            async {
                subject2.send(1)
                subject2.send(2)
                subject2.send(completion: .finished)
            }
            _ = subject2.wait()
        }
        cancellable.cancel()
        XCTAssertEqual(result, .complete(values: [2, 3]))
    }

    func test_wait_withFailure() {
        let subject = PassthroughSubject<Int, SomeError>()
        async {
            subject.send(1)
            subject.send(2)
            subject.send(completion: .failure(.some))
        }
        let result = subject.wait(timeout: 1)
        XCTAssertEqual(result, .failure(values: [1, 2], error: .some))
    }
}

private func async(_ work: @escaping () -> Void) {
    DispatchQueue.main.async(execute: work)
}
