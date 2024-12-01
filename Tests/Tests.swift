import Testing
import Foundation
@testable import SwiftZSV

private struct Context {
    let parser: zsv_parser
}

private struct Failure: Error {
    let message: String
}

@Suite
struct Tests {
    @Test
    func parse_10() throws {
        try parse(name: "10.csv")
    }

    @Test
    func parse_100() throws {
        try parse(name: "100.csv")
    }

    @Test
    func parse_1_000() throws {
        try parse(name: "1000.csv")
    }

    @Test
    func parse_10_000() throws {
        try parse(name: "10000.csv")
    }

    @Test
    func parse_100_000() throws {
        try parse(name: "100000.csv")
    }

    @Test
    func parse_1_000_000() throws {
        try parse(name: "1000000.csv")
    }

    // MARK: - Private

    private func parse(name: String) throws {
        let bufferSize = 4096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        let fileURL = try #require(Bundle.module.resourceURL?.appendingPathComponent("Resources/\(name)"))
        let fileStream = try #require(InputStream(fileAtPath: fileURL.path))
        fileStream.open()
        defer { fileStream.close() }
        let parser = try #require(zsv_new(nil))
        var context = Context(parser: parser)
        zsv_set_context(parser, &context)
        zsv_set_row_handler(parser) { ctx in
            guard let ctx else { return }
            let context = ctx.load(as: Context.self)
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
                if let error = fileStream.streamError {
                    throw error
                } else {
                    throw Failure(message: "File stream reading failed with \(read)")
                }
            } else if read == 0 {
                break
            }
            zsv_parse_bytes(parser, buffer, read)
        }
        zsv_finish(parser)
        zsv_delete(parser)
    }
}
