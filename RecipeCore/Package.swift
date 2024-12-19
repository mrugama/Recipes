// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RecipeCore",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RecipeUI", targets: ["RecipeUI"]
        ),
        .library(
            name: "RecipeDomain", targets: ["RecipeDomain"]
        ),
        .library(
            name: "RecipeRestAPI", targets: ["RecipeRestAPI"]
        ),
        .library(
            name: "Networking", targets: ["Networking"]
        ),
        .library(
            name: "Storage", targets: ["Storage"]
        ),
    ],
    targets: [
        .target(
            name: "Networking",
            path: "Sources/Foundation/Networking"
        ),
        .target(
            name: "Storage",
            path: "Sources/Foundation/Storage"
        ),
        .target(
            name: "RecipeRestAPI",
            dependencies: ["Networking", "Storage"],
            path: "Sources/RecipeFeature/RecipeRestAPI"
        ),
        .target(
            name: "RecipeDomain",
            dependencies: ["RecipeRestAPI"],
            path: "Sources/RecipeFeature/RecipeDomain"
        ),
        .target(
            name: "RecipeUI",
            dependencies: ["RecipeDomain", "RecipeRestAPI"],
            path: "Sources/RecipeFeature/RecipeUI"
        ),
        .testTarget(
            name: "StorageTests",
            dependencies: ["Storage"]
        ),
        .testTarget(
            name: "RecipeRestAPITests",
            dependencies: ["RecipeRestAPI"]
        ),
    ]
)
