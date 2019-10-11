import CMustache
import Foundation

public enum MustacheError: Error, CustomStringConvertible {
    case system
    case unexpectedEnd
    case emptyTag
    case tagTooLong
    case badSeparators
    case tooDeep
    case closing
    case badUnescapeTag
    case invalidITF
    case itemNotFound
    case partialNotFound

    public var reason: String {
        switch self {
        case .system: return "system"
        case .unexpectedEnd: return "unexpected end"
        case .emptyTag: return "empty tag"
        case .tagTooLong: return "tag too long"
        case .badSeparators: return "bad separators"
        case .tooDeep: return "too deep"
        case .closing: return "closing"
        case .badUnescapeTag: return "bad unescape tag"
        case .invalidITF: return "invalid itf"
        case .itemNotFound: return "item not found"
        case .partialNotFound: return "partial not found"
        }
    }

    public var description: String {
        return "Mustache error: \(self.reason)"
    }

    init?(status: Int32) {
        switch status {
        case MUSTACH_ERROR_UNEXPECTED_END:
            self = .unexpectedEnd
        case MUSTACH_ERROR_EMPTY_TAG:
            self = .emptyTag
        case MUSTACH_ERROR_TAG_TOO_LONG:
            self = .tagTooLong
        case MUSTACH_ERROR_BAD_SEPARATORS:
            self = .badSeparators
        case MUSTACH_ERROR_TOO_DEEP:
            self = .tooDeep
        case MUSTACH_ERROR_CLOSING:
            self = .closing
        case MUSTACH_ERROR_BAD_UNESCAPE_TAG:
            self = .badUnescapeTag
        case MUSTACH_ERROR_INVALID_ITF:
            self = .invalidITF
        case MUSTACH_ERROR_ITEM_NOT_FOUND:
            self = .itemNotFound
        case MUSTACH_ERROR_PARTIAL_NOT_FOUND:
            self = .partialNotFound
        default:
            return nil
        }
    }
}
