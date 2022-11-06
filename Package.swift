// swift-tools-version:5.5

import PackageDescription

let package = Package(
    // This name is normally synonymous with a hosted git repo
    name: "grid",

    // The executables or libraries produced by this project
    products: [
        // This is the call name of the library that is produced.
        // You don't import that name. You import the names of the
        // module targets included within the library.
        .library(name: "grid",

            // The targets named here are the modules listed in the targets section
            targets: ["Grid"]),
    ],

    dependencies: [
	.package(url: "https://github.com/erica/customsequences", from: "1.0.0"),
    ],

    targets: [
        // Create module targets

        .target(
            // This is the module name. It is used by the product section targets
            // and by any test target
            name: "Grid",
            dependencies: ["customsequences"],
            path: "Sources/" // Omit or override if needed
        ),

        // Test target omitted here
        //.testTarget(name: "gridTests", dependencies: ["grid"]),
    ],

    swiftLanguageVersions: [ .v5 ]
)
