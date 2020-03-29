import Combine
import Foundation
import XCTest

public extension Publisher {
    /// Waits for this publisher to complete within the given timeout.
    /// - Parameter timeout: The maximum amount of time to wait for values.
    /// - Returns: The values emitted by this publisher and the status of this publisher.
    func wait(timeout: TimeInterval = 0, executing work: @escaping () -> Void = {}) -> WaitResult<Output, Failure> {
        var values = [Output]()
        var completion: Subscribers.Completion<Failure>?
        var cancellable: AnyCancellable?

        let runner = Runner(timeout: timeout)
        runner.run { runner in
            cancellable = self.sink(receiveCompletion: {
                completion = $0
                runner.stop()
            }, receiveValue: {
                values.append($0)
            })
            work()
        }

        cancellable?.cancel()

        switch completion {
        case .none:
            return .partial(values: values)
        case .finished:
            return .complete(values: values)
        case let .failure(error):
            return .failure(values: values, error: error)
        }
    }
}
