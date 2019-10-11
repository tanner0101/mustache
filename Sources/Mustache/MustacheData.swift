public enum MustacheData {
    case string(String)
    case dictionary([String: MustacheData])
    case array([MustacheData])
}

extension MustacheData: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, MustacheData)...) {
        self = .dictionary(.init(uniqueKeysWithValues: elements))
    }
}

extension MustacheData: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: MustacheData...) {
        self = .array(elements)
    }
}

extension MustacheData: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}
