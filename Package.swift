// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MMMLog",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
			name: "MMMLog",
			targets: [
				"MMMLogObjC",
				"MMMLogSwift"
			]
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
			name: "MMMLogSwift",
			dependencies: ["MMMLogObjC"],
			path: "MMMLog/Swift"
		),
    ]
)

