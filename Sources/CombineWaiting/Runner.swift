import Foundation

final class Runner {
    private let runLoop = CFRunLoopGetCurrent()
    private let mode: CFRunLoopMode = .defaultMode
    private let timeout: TimeInterval
    private var lock = NSLock()
    private var isRunning = false

    init(timeout: TimeInterval) {
        self.timeout = timeout
    }

    func run(executing work: @escaping (Runner) -> Void) {
        lock.lock()
        guard !isRunning else {
            assertionFailure("Runner is already running")
            lock.unlock()
            return
        }
        isRunning = true
        lock.unlock()

        CFRunLoopPerformBlock(runLoop, mode.rawValue) { work(self) }
        CFRunLoopWakeUp(runLoop)
        CFRunLoopRunInMode(mode, timeout, false)
    }

    func stop() {
        lock.lock()
        guard isRunning else {
            lock.unlock()
            return
        }
        isRunning = false
        lock.unlock()

        CFRunLoopPerformBlock(runLoop, mode.rawValue) {
            CFRunLoopStop(self.runLoop)
        }
        CFRunLoopWakeUp(runLoop)
    }
}
