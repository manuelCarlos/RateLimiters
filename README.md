[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?color=ff69b4)](https://github.com/manuelCarlos/RateLimiters/blob/master/LICENSE)

![Static Badge](https://img.shields.io/badge/iOS-_v16.0_-blue)
![Static Badge](https://img.shields.io/badge/macOS-_v13.0_-red)
![Static Badge](https://img.shields.io/badge/watchOS-_v9.0_-green)
![Static Badge](https://img.shields.io/badge/tvOS-_v16.0_-pink)


# RateLimiters

## Swift implementation of Debouncing and Throttling actors.

### This package contains two user-facing modules:

  - `Debouncer` - allows submitting work that will only be executed if/when no other submissions occur during a specified time interval.

  - `Throttler` - allows submitting work that will only be executed at most once during a given time window.

### Debouncer Usage:

```swift

import Debouncer

let debouncer = Debouncer(duration: .seconds(2), clock: .suspending)
  
func some(operation: @escaping () async -> Void) async {
    // The operations submitted here will be debounced by 2 secs.
    await debouncer.submit(operation: operation)
}
 
```


### Throttler Usage:

```swift

import Throttler

let throttler = Throttler(duration: .seconds(2), latest: false, clock: .suspending)
  
func some(operation: @escaping () async -> Void) async {
    // The operations submitted here will be throttled by 2 secs.
    await throttler.submit(operation: operation)
}
 
```

### Installation 

#### - Using SPM:

Add the following line to the dependencies in your `Package.swift` file:

```
.package(url: "https://github.com/manuelCarlos/RateLimiters.git")
```
#### More specifically:

##### To include only `Debouncer`:

```
.target(name: "<target>", dependencies: [
        .product(name: "Debouncer", package: "RateLimiters")
]),
```
##### To include only `Throttler`:

```
  .target(name: "<target>", dependencies: [
        .product(name: "Throttler", package: "RateLimiters")
  ]),
```
