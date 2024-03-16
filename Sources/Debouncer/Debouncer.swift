//
//  Debouncer.swift
//  Debouncer
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public actor Debouncer <C: Clock> {

    private var task: Task<Void, any Error>?
    private let duration: C.Instant.Duration
    private let tolerance: C.Instant.Duration?
    private let clock: C

    /// Create a `Debouncer` instance with the given parameters.
    /// - Parameters:
    ///   - duration: The duration of time interval used to debounce the work.
    ///   - tolerance: Optional tolerance to be applied to the given quiescence period. Default is `nil`.
    ///   - clock: The clock that measures the duration of the time interval.
    public init(duration: C.Instant.Duration, tolerance: C.Instant.Duration? = nil, clock: C) {
        self.duration = duration
        self.tolerance = tolerance
        self.clock = clock
    }

    /// Submits work to be executed.
    /// If a given quiescence duration has elapsed where no work as been submitted, then the last submitted operation is executed.
    ///
    /// - Parameter operation: An escaping closure with the work to be executed.
    public func submit(operation: @escaping @Sendable () async -> Void) {
        debounce(operation)
    }

    // MARK: - Private

    private func debounce(_ operation: @escaping @Sendable () async -> Void) {
        task?.cancel()

        task = Task {
            try await Task.sleep(until: clock.now.advanced(by: duration), tolerance: tolerance, clock: clock)
            await operation()
            task = nil
        }
    }

}
