import XCTest
import Foundation
@testable import SwiftZSV

private final class Context {
    let parser: zsv_parser

    init(parser: zsv_parser) {
        self.parser = parser
    }
}

private struct Failure: Error {
    let message: String
}

final class ParseTests: XCTestCase {
    func test_10() throws {
        try parse(name: "10.csv", delimiter: 0x09)
    }

    func test_100() throws {
        try parse(name: "100.csv", delimiter: 0x09)
    }

    func test_1_000() throws {
        try parse(name: "1000.csv", delimiter: 0x09)
    }

    func test_parse_10_000() throws {
        try parse(name: "10000.csv", delimiter: 0x2C)
    }

    func test_parse_100_000() throws {
        try parse(name: "100000.csv", delimiter: 0x2C)
    }

    func test_parse_500_000() throws {
        try parse(name: "500000.csv", delimiter: 0x2C)
    }

    // MARK: - Private

    private func parse(name: String, delimiter: CChar) throws {
        let bufferSize = 4096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        let fileURL = try XCTUnwrap(Bundle.module.resourceURL?.appendingPathComponent(name))
        let fileStream = try XCTUnwrap(InputStream(fileAtPath: fileURL.path))
        fileStream.open()
        defer { fileStream.close() }
        var options = zsv_opts()
        options.delimiter = delimiter
        let parser = try XCTUnwrap(zsv_new(&options))
        defer { zsv_delete(parser) }
        let context = Context(parser: parser)
        let contextRef = Unmanaged.passUnretained(context).toOpaque()
        zsv_set_context(parser, contextRef)
        zsv_set_row_handler(parser) { contextRef in
            guard let contextRef else { return }
            let context = Unmanaged<Context>.fromOpaque(contextRef).takeUnretainedValue()
            let cellCount = zsv_cell_count(context.parser)
            for cellIndex in 0..<cellCount {
                let cell = zsv_get_cell(context.parser, cellIndex)
                let cellData = Data(bytes: cell.str, count: cell.len)
                _ = String(bytes: cellData, encoding: .utf8)
            }
        }
        while fileStream.hasBytesAvailable {
            let read = fileStream.read(buffer, maxLength: bufferSize)
            if read < 0 {
                zsv_abort(parser)
                if let error = fileStream.streamError {
                    throw error
                } else {
                    throw Failure(message: "File stream reading failed with \(read)")
                }
            } else if read == 0 {
                zsv_finish(parser)
                break
            } else {
                zsv_parse_bytes(parser, buffer, read)
            }
        }
    }
}
