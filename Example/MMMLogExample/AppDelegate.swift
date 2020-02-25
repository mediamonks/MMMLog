//
// MMMLog.
// Copyright (C) 2020 MediaMonks. All rights reserved.
//

import MMMLog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	private var _window: UIWindow?
	private var _mainViewController: ViewController?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Can begin using it without any extra setup, it'll be just like NSLog() with some extra formatting.
		MMMLogTraceMethod(self)

		let useOSLog = false

		// Or can override output and redirect it to different places...
		MMMLogOverrideOutput { (level, context, message) in

			// ...like Apple's unified logging system or less noisy version of NSLog() for Xcode console logs.
			if useOSLog {
				// Using Apple's unified logging system makes it easier to see traces in the Console app,
				// which is handy when debugging things outside Xcode.
				// Note that messages sent there show up in the Xcode console too.
				MMMLogOutputToOSLog(level, context, message)
			} else {
				// Not using console-only output together with the above which shows up in the console as well.
				#if DEBUG
				MMMLogOutputToConsole(level, context, message)
				#endif
			}

			// In addition you can redirect them to Crashlytics/Instabug/etc.

			/*!
			let formattedMessage = MMMLogFormat(level, context, message)

			// Crashlytics.
        	withVaList([formattedMessage]) { CLSLogv("%@", $0) }

			// Instabug.
			switch level {
			case .trace:
				IBGLog.log(formattedMessage)
			case .info:
				IBGLog.logInfo(formattedMessage)
			case .error:
				IBGLog.logError(formattedMessage)
			}
			*/
		}

		let window = UIWindow()
		_window = window

		let mainViewController = ViewController()
		_mainViewController = mainViewController
		window.rootViewController = mainViewController

		window.makeKeyAndVisible()

		MMMLogTrace(self, "Initialized")

		let url = URL(string: "https://mediamonks.com/")!
		MMMLogInfo(self, "Base URL: \(url)")

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		MMMLogInfo(self, "The app is becoming inactive")
	}
}

