import CMustache

public struct MustacheRenderer {
    public init() { }

    public func render(template: String, data: [String: MustacheData]) throws -> String {
        var result: UnsafeMutablePointer<Int8>?
        var size = 0

        var context = MustacheContext(data: data)
        var itf = context.itf

        let status = mustach_mem(template, 0, &itf, &context, 0, &result, &size)
        guard status == MUSTACH_OK else {
            throw MustacheError(status: status)!
        }
        let buffer = UnsafeBufferPointer(
            start: UnsafeRawPointer(result!).assumingMemoryBound(to: UInt8.self),
            count: size
        )
        return String(decoding: buffer, as: UTF8.self)
    }
}
