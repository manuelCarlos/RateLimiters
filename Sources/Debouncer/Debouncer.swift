//
//  Debouncer.swift
//  Debouncer
//

public actor Debouncer {

    private let duration: Double
    private var task: Task<Void, Error>?

    /// Create a `Debouncer` instance with the given parameter.
    /// - Parameter duration: the time interval in seconds used to debounce the work.
    public init(duration: Double) {
        self.duration = duration
    }

    public func submit(operation: @escaping () async -> Void) {
        debounce(operation: operation)
    }

    // MARK: - Private

    private func debounce(operation: @escaping () async -> Void) {
        task?.cancel()

        task = Task {
            try await Task.sleep(until: .now + .seconds(duration), clock: .suspending)
            await operation()
            task = nil
        }
    }

}
