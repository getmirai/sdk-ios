// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Mirai",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Mirai",
            targets: ["Mirai"]
        )
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "Mirai",
            url: "https://artifacts.getmirai.co/sdk-ios/releases/0.1.zip",
            checksum: "b38c6b133f2495305a93fee2916fdac705ebd16f5dd62df3f74d620313a2286c"
        )
    ]
)
