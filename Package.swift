// swift-tools-version:5.9
//
//  Package.swift
//  Paseto
//
//  Created by Aidan Woods on 04/03/2018.
//  Copyright © 2017 Aidan Woods. All rights reserved.
//


import PackageDescription

let package = Package(
    name: "Paseto",
    platforms: [
        // Same baseline as CryptoSwift
        // Increased iOS, tvOS and watchOS because of ISO8601DateFormatter
        .macOS(.v14), .iOS(.v15), .tvOS(.v12), .watchOS(.v4)
    ],
    products: [
        .library(name: "Paseto", targets: ["Paseto"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/jedisct1/swift-sodium.git",
            .upToNextMajor(from: "0.10.0")
        ),
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift.git",
            .upToNextMajor(from: "1.4.2")
        ),
        .package(
            url: "https://github.com/aidantwoods/TypedJSON.git",
            .upToNextMinor(from: "0.1.2")
        )
    ],
    targets: [
        .target(
            name: "Paseto",
            dependencies: [
                .product(name: "Clibsodium", package: "Sodium"),
                .product(name: "Sodium", package: "Sodium"),
                "CryptoSwift",
                "TypedJSON"
            ]
        ),
        .testTarget(
            name: "PasetoTests",
            dependencies: ["Paseto"],
            resources: [
                .copy("TestVectors")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
