import SwiftUI
import SwiftZSV

private struct Context {
    let parser: zsv_parser
}

struct ContentView: View {
    var body: some View {
        Text("Swift ZSV").onAppear {
            let parser = zsv_new(nil)!
            var context = Context(parser: parser)
            zsv_set_context(parser, &context)
            zsv_set_row_handler(parser) { _ in }
            zsv_parse_bytes(parser, UnsafePointer<UInt8>(bitPattern: 0), 0)
            zsv_finish(parser)
            zsv_delete(parser)
        }
    }
}
