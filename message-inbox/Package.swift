// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MessageCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "MessageCore", targets: ["MessageCore"])],
    targets: [
        .target(name: "MessageCore", path: "Sources/MessageCore"),
        .testTarget(name: "MessageCoreTests", dependencies: ["MessageCore"], path: "Tests/MessageCoreTests")
    ],
    swiftLanguageModes: [.v6]
)
