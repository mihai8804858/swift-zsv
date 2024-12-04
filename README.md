# SwiftZSV

Swift wrapper for [`libzsv`](https://github.com/liquidaty/zsv).

[![CI](https://github.com/mihai8804858/swift-zsv/actions/workflows/ci.yml/badge.svg)](https://github.com/mihai8804858/swift-zsv/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmihai8804858%2Fswift-zsv%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mihai8804858/swift-zsv) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmihai8804858%2Fswift-zsv%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mihai8804858/swift-zsv)

## Installation

You can add `swift-zsv` to an Xcode project by adding it to your project as a package.

> https://github.com/mihai8804858/swift-zsv

If you want to use `swift-zsv` in a [SwiftPM](https://swift.org/package-manager/) project, it's as simple as adding it to your `Package.swift`:

``` swift
dependencies: [
    .package(url: "https://github.com/mihai8804858/swift-zsv", branch: "main")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "SwiftZSV", package: "swift-zsv")
```

## Quick Start

Just import `SwiftZSV` in your project to access the underlying `zsv` C API:

```swift
import SwiftZSV

let parser = zsv_new(nil)
zsv_set_row_handler(parser) { _ in
    // handle CSV row
}
zsv_parse_bytes(parser, ...)
zsv_finish(parser)
zsv_delete(parser)
```

## Prebuilt Versions

* `zsv` - [v0.3.9-alpha](https://github.com/liquidaty/zsv/releases/tag/v0.3.9-alpha)

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
