//
//  Throttler.swift
//  Throttler
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public actor Throttler {

    private var firstTask: Task<Void, Error>?
    private var latestTask: Task<Void, Error>?

    private let duration: Double
    private let latest: Bool

    /// Create a `Throttler` instance with the given parameters.
    /// - Parameters:
    ///   - duration: the duration in seconds used to throttle the work.
    ///   - latest: when `true`, the last work submitted will be executed, otherwise only the first
    ///   task is executed.
    public init(duration: Double, latest: Bool) {
        self.duration = duration
        self.latest = latest
    }

    /// Submit work to be executed.
    /// - Parameter operation: a closure containing the work to be executed.
    public func submit(operation: @escaping () async -> Void) {
        throttle(operation: operation)
    }

    // MARK: - Private

    private func throttle(operation: @escaping () async -> Void) {
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
            try? await sleep()
            firstTask = nil
        }

        Task {
            await operation()
        }
    }

    private func sleep() async throws {
        try await Task.sleep(until: .now + .seconds(duration), clock: .suspending)
    }

}
