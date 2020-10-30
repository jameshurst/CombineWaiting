# CombineWaiting

Synchronously wait for Combine publishers to emit values in tests.

## Usage

```swift
import Combine
import CombineWaiting

let publisher = // AnyPublisher<Success, Failure>
XCTAssertEqual(publisher.wait(), expected)
```

## Waiting for Publishers

You can wait for any `Publisher` to emit values using the `wait` function.
This function accepts a timeout and and an optional work function to execute post-subscription. The work function may be used to cause expected values to be emitted.

The wait function returns a `WaitResult` that contains one of the following:
* `.partial(values)` - The publisher produced some values, but did not complete.
* `.complete(values)` - The publisher produced some values and completed.
* `.failure(values, error)` - The publisher produced some values and completed with a failure.

A `WaitResult` has some useful functions to query the contained values such as:
* `hasValues()` - Returns whether the result contains any values.
* `values()` - Returns the values contained in the result.
* `value(at:)` - Returns the value at the given index.
* `error()` - Returns the error if the result was a failure.

## Installation

### Xcode 11+

* Select **File** > **Swift Packages** > **Add Package Dependency...**
* Enter the package repository URL: `https://github.com/jameshurst/CombineWaiting.git`
* Confirm the version and let Xcode resolve the package
* Add `CombineWaiting` to your test target

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
