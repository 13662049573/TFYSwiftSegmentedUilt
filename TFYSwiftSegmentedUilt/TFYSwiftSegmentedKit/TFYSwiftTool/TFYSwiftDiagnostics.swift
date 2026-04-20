//
//  TFYSwiftDiagnostics.swift
//  TFYSwiftSegmentedKit
//
//  Minimal os_signpost wrapper + debug logging switch used across the library.
//  Release builds are no-op unless `isSignpostEnabled` is explicitly toggled on.
//

import Foundation
import os

/// 性能打点入口。默认关闭，开发者可在 debug 时启用以在 Instruments 中观察：
/// ```swift
/// TFYSwiftDiagnostics.shared.isSignpostEnabled = true
/// TFYSwiftDiagnostics.shared.isVerboseLoggingEnabled = true
/// ```
public final class TFYSwiftDiagnostics: @unchecked Sendable {

    public static let shared = TFYSwiftDiagnostics()

    /// 是否启用 `os_signpost`。发行构建默认 false。
    public var isSignpostEnabled: Bool = false

    /// 是否启用 OSLog 详细日志。发行构建默认 false。
    public var isVerboseLoggingEnabled: Bool = false

    /// 子系统标识，方便在 Instruments / Console.app 中过滤。
    public let subsystem: String

    public let category: String

    public let log: OSLog
    public let signpostLog: OSLog

    public init(subsystem: String = "com.tfy.segmentedkit",
                category: String = "SegmentedKit") {
        self.subsystem = subsystem
        self.category = category
        self.log = OSLog(subsystem: subsystem, category: category)
        self.signpostLog = OSLog(subsystem: subsystem, category: .pointsOfInterest)
    }

    @inlinable
    public func verbose(_ message: @autoclosure () -> String,
                        function: StaticString = #function) {
        guard isVerboseLoggingEnabled else { return }
        os_log("%{public}@ | %{public}@", log: log, type: .debug, String(describing: function), message())
    }

    /// 发起一个 signpost interval，返回 `OSSignpostID`，用于后续 `.end` 配对。
    public func beginSignpost(name: StaticString, message: String = "") -> OSSignpostID {
        guard isSignpostEnabled else { return .invalid }
        let id = OSSignpostID(log: signpostLog)
        if message.isEmpty {
            os_signpost(.begin, log: signpostLog, name: name, signpostID: id)
        } else {
            os_signpost(.begin, log: signpostLog, name: name, signpostID: id, "%{public}@", message)
        }
        return id
    }

    public func endSignpost(name: StaticString, id: OSSignpostID, message: String = "") {
        guard isSignpostEnabled, id != .invalid else { return }
        if message.isEmpty {
            os_signpost(.end, log: signpostLog, name: name, signpostID: id)
        } else {
            os_signpost(.end, log: signpostLog, name: name, signpostID: id, "%{public}@", message)
        }
    }

    public func event(name: StaticString, message: String = "") {
        guard isSignpostEnabled else { return }
        if message.isEmpty {
            os_signpost(.event, log: signpostLog, name: name)
        } else {
            os_signpost(.event, log: signpostLog, name: name, "%{public}@", message)
        }
    }
}
