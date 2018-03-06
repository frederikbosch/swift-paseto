// swift-tools-version:4.0
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
    products: [
        .library(name: "Paseto", targets: ["Paseto"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jedisct1/swift-sodium.git", .revision("dc62e765f5110a1bfb16a692e18180ba1ee9ae9f")),
    ],
    targets: [
        .target(name: "Paseto", dependencies: ["Sodium"]),
        .testTarget(name: "PasetoTests", dependencies: ["Paseto"]),
    ]
)
