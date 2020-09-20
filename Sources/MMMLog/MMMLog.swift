//
// MMMLog. Part of MMMTemple.
// Copyright (C) 2016-2020 MediaMonks. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
import MMMLogObjC

@_exported import MMMLogObjC

#endif

// Swift shim for MMMLog() and friends.

/// It's handy to be able to compare levels when filtering.
extension MMMLogLevel: Comparable {
	public static func < (lhs: MMMLogLevel, rhs: MMMLogLevel) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

/// Adopting this allows objects to customize a reference to them in the logs generated via `MMMLog*()` methods.
public protocol MMMLogSource {
	var logContext: String { get }
}

extension NSObject: MMMLogSource {
	// Let's keep using ObjC style log source names for ObjC-style objects.
	@objc open var logContext: String {
		return __MMMLogContextFromObject(self)
	}
}

/// Swift version of `MMMLogContextFromObject()` supporting Swift objects, too.
public func MMMLogContext(fromObject obj: Any) -> String {

	if let stringSource = obj as? String {

		// Using strings directly as the name of the log source, however preprocess them a bit if they appear to be file names.

		if stringSource.hasSuffix(".swift") || stringSource.hasSuffix(".m") {
			return URL(fileURLWithPath: stringSource).deletingPathExtension().lastPathComponent
		} else {
			return stringSource
		}

	} else if let mmmLogSource = obj as? MMMLogSource {

		// OK, something that is able to provide a meaningful name of the source.
		return mmmLogSource.logContext

	} else if type(of: obj) is AnyClass {

		// Something of a reference type, let's use type name with some bits derived from the reference to distinguish the instances.

		// TODO: demangle heavily nested types.
		let typeName = String(reflecting: type(of: obj))
		let instanceName = String(ObjectIdentifier(obj as AnyObject).hashValue & 0xFFF, radix: 16, uppercase: false)
		return "\(typeName)#\(instanceName)"

	} else  {

		// A value-type, assuming that's something that can look good as a string.
		return String(describing: obj)
	}
}

/// Swift version of `MMM_LOG_TRACE()` macro, though is not a subject of Release/Debug filtering.
public func MMMLogTrace(_ source: Any, _ message: String) {
	__MMMLog(.trace, MMMLogContext(fromObject: source), message)
}

/// Swift version of `MMM_LOG_INFO()` macro.
public func MMMLogInfo(_ source: Any, _ message: String) {
	__MMMLog(.info, MMMLogContext(fromObject: source), message)
}

/// Swift version of `MMM_LOG_ERROR()` macro.
public func MMMLogError(_ source: Any, _ message: String) {
	__MMMLog(.error, MMMLogContext(fromObject: source), message)
}

/// Prints the name of the current function, Swift version of `MMM_LOG_TRACE_METHOD()` macro.
public func MMMLogTraceMethod(_ source: Any, _ function: StaticString = #function) {
	MMMLogTrace(source, "Entering \(function)")
}
