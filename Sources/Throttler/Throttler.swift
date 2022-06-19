//
//  Throttler.swift
//  Throttler
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public actor Throttler <C: Clock> {

    private var firstTask: Task<Void, Error>?
    private var latestTask: Task<Void, Error>?

    private let duration: C.Instant.Duration
    private let latest: Bool
    private let tolerance: C.Instant.Duration?
    private let clock: C

    /// Create a `Throttler` instance with the given parameters.
    /// - Parameters:
    ///   - duration: the duration in time used to throttle the work.
    ///   - latest: when `true`, the last work submitted will be executed, otherwise only the first task is executed.
    ///   - tolerance: optional tolerance to be applied to the given duration. Default is `nil`.
    ///   - clock: a clock that measures the duration of the time interval.
    public init(duration: C.Instant.Duration, latest: Bool, tolerance: C.Instant.Duration? = nil, clock: C) {
        self.duration = duration
        self.latest = latest
        self.tolerance = tolerance
        self.clock = clock
    }

    /// Submit work to be executed.
    /// - Parameter operation: a closure containing the work to be executed.
    public func submit(operation: @escaping () async -> Void) {
        throttle(operation)
    }

    // MARK: - Private

    private func throttle(_ operation: @escaping () async -> Void) {
        guard firstTask == nil else {

            if latest {
                latestTask?.cancel()

                latestTask = Task {
                    try await sleep()
                    await operation()
                    latestTask = nil
                }
            }
            return
        }

        if latest {
            latestTask?.cancel()
        }

        firstTask = Task {
            try await sleep()
            firstTask = nil
        }

        Task {
            await operation()
        }
    }

    private func sleep() async throws {
        try await Task.sleep(until: clock.now.advanced(by: duration), tolerance: tolerance, clock: clock)
    }

}
