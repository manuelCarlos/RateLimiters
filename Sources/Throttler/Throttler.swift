//
//  Throttler.swift
//  Throttler
//

import Foundation
import Combine

/// struct either throttling or debouncing successive works with provided options.
@available(iOS 13.0, *)
public enum Throttler {

    private typealias Identifier = String
    private typealias Work = () -> Void
    private typealias Subject = PassthroughSubject<Work, Never>
    private typealias Bag = Set<AnyCancellable>

    private static var subjects: [Identifier: Subject] = [:]
    private static var bags: [Identifier: Bag] = [:]

    /// Execute work in the specified time interval.
    ///
    /// - Parameters:
    ///   - id: the identifier to group works to throttle. `Stream` must have an equivalent identifier for each work to throttle.
    ///   - delay: The time interval at which to delay executing the work, expressed in `DispatchQueue.SchedulerTimeType.Stride`.
    ///   - shouldRunImmediately: A boolean type where `true` will run the first work immediately regardless of the delay.
    ///   - shouldRunLatest: A Boolean value that indicates whether to publish the most recent element. If `false`, the publisher emits the first element received during the interval.
    ///   - queue: a queue to execute the work on. The default is `DispatchQueue.main`.
    ///   - work: an escaping closure with the work to execute.
    public static func throttle(id identifier: String,
                                delay: DispatchQueue.SchedulerTimeType.Stride = .seconds(1),
                                shouldRunImmediately: Bool = true,
                                shouldRunLatest: Bool = true,
                                queue: DispatchQueue = DispatchQueue.main,
                                execute work: @escaping () -> Void) {
        let isFirstRun = subjects[identifier] == nil
        if shouldRunImmediately && isFirstRun {
            work()
        }

        if let subject = subjects[identifier] {
            subject.send(work)
        } else {
            subjects[identifier] = PassthroughSubject<Work, Never>()
            bags[identifier] = Bag()

            subjects[identifier]!
                .throttle(for: delay, scheduler: queue, latest: shouldRunLatest)
                .sink(receiveValue: { $0() })
                .store(in: &bags[identifier]!)
        }
    }

}
