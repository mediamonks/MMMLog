//
// MMMLog.
// Copyright (C) 2020 MediaMonks. All rights reserved.
//

import MMMLog
import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		MMMLogTraceMethod(self) // Sometimes we just want to quickly trace a certain method call.
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		MMMLogTraceMethod(self)
		super.viewWillAppear(animated)
	}
}

