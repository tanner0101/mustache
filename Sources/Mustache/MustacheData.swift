public enum MustacheData: CustomStringConvertible {
    case string(String)
    case dictionary([String: MustacheData])
    case array([MustacheData])

    public var description: String {
        switch self {
        case .array(let array):
            return array.description
        case .dictionary(let dictionary):
            return dictionary.description
        case .string(let string):
            return string
        }
    }
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
