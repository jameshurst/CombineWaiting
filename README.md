# CombineWaiting

Synchronously wait for Combine publishers.

*This library is only meant to be used for testing purposes.*

## Usage

```swift
let publisher = ... // AnyPublisher<Success, Failure>
XCTAssertEqual(publisher.wait(timeout: 1).values(), expected)
```

You can wait for any `Publisher` using the `wait` function.

This function accepts a timeout and and an optional work closure to execute post-subscription. The work closure may be used to cause expected values to be produced.

The result of the wait operation is a `WaitResult`.

* `WaitResult.partial(values)` 
  * The publisher did not complete.
* `WaitResult.complete(values)`
  *  The publisher completed successfully.
* `WaitResult.failure(values, error)` 
  * The publisher completed with an error.

You can use the following functions to easily access a result's values.

* `values()` 
  * Ensures that the publisher did not complete with an error
  * Returns the produced values
* `values(n)`
  * Ensures that the publisher did not complete with an error
  * Ensures that the publisher produced `n` values
  * Returns the produced values
* `singleValue()` 
  * Ensures that the publisher did not complete with an error
  * Ensures that the publisher produced a single value
  * Returns the produced value
* `error()`
  *  Ensures that publisher completed with an error
  *  Returns the produced error

## Installation

### Xcode 11+

* Select **File** > **Swift Packages** > **Add Package Dependency...**
* Enter the package repository URL: `https://github.com/jameshurst/CombineWaiting.git`
* Confirm the version and let Xcode resolve the package
* Add `CombineWaiting` to your test target

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
