[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?color=ff69b4)](https://github.com/manuelCarlos/RateLimiters/blob/master/LICENSE)

# RateLimiters

## Swift implementation of Throttling and Debounce actors.

### This package contains two user-facing modules:

  - `Throttler` - is a Swift actor that allows the clients to submit work that will only be executed at most once during a given window of time.
  
  - `Debouncer` - is a Swift actor that allows clients to submit work that will only be executed if/when no submissions are done during a specified time interval.

### Throttler Usage:

```swift

import Throttler

let throttler = Throttler(duration: .seconds(2), latest: false, clock: .suspending)
  
func some(operation: @escaping () async -> Void) async {
    // The operations submitted here will be throttled by 2 secs.
    await throttler.submit(operation: operation)
}
 
```

### Debouncer Usage:

```swift

import Debouncer

let debouncer = Debouncer(duration: .seconds(2), clock: .suspending)
  
func some(operation: @escaping () async -> Void) async {
    // The operations submitted here will be debounced by 2 secs.
    await debouncer.submit(operation: operation)
}
 
```

### Installation

#### Adding any of the `RateLimiters` modules as a Dependency using SPM.

To use these objects in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```
.package(url: "https://github.com/manuelCarlos/RateLimiters.git")
```

##### To include only `Throttler` as a dependency for your executable target:

```
.target(name: "<target>", dependencies: [
        .product(name: "Throttler", package: "RateLimiters")
]),
```


##### To include only `Debouncer` as a dependency for your executable target:

```
.target(name: "<target>", dependencies: [
        .product(name: "Debouncer", package: "RateLimiters")
]),
```
