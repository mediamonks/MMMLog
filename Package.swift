// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MMMLog",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
			name: "MMMLog",
			targets: ["MMMLog"]
		)
    ],
    dependencies: [],
    targets: [
        .target(
			name: "MMMLogObjC",
			dependencies: [],
			path: "MMMLog/ObjC"
		),
        .target(
			name: "MMMLog",
			dependencies: ["MMMLogObjC"],
			path: "MMMLog/Swift"
		),
    ]
)

