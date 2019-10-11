import CMustache

struct MustacheContext {
    var stack: [MustacheData]
    var index: Int

    var data: MustacheData {
        guard let current = self.stack.last else {
            fatalError("stack popped too many times")
        }
        return current
    }

    init(data: [String: MustacheData]) {
        self.stack = [.dictionary(data)]
        self.index = 0
    }

    func put(name: String) -> String {
        switch self.data {
        case .array(let array):
            guard case .dictionary(let data) = array[self.index] else {
                return ""
            }
            guard let value = data[name] else {
                return ""
            }
            switch value {
            case .string(let string):
                return string
            case .dictionary, .array:
                return ""
            }
        case .dictionary(let data):
            guard let value = data[name] else {
                return ""
            }
            switch value {
            case .string(let string):
                return string
            case .dictionary, .array:
                return ""
            }
        case .string:
            return ""
        }
    }

    mutating func next() -> Bool {
        switch self.data {
        case .array(let array):
            if self.index + 1 < array.count {
                index += 1
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }

    mutating func enter(name: String) -> Bool {
        guard case .dictionary(let data) = self.data else {
            return false
        }

        if let value = data[name] {
            switch value {
            case .dictionary, .array:
                self.stack.append(value)
                return true
            case .string(let string):
                return !["false", "0"].contains(string.lowercased())
            }
        } else {
            return false
        }
    }

    mutating func leave() {
        _ = self.stack.popLast()
        self.index = 0
    }

    var itf: mustach_itf {
        mustach_itf(
            start: nil,
            put: { closure, name, escape, file in
                guard let name = name.flatMap(String.init(cString:)) else {
                    return MUSTACH_ERROR_SYSTEM
                }
                guard let context = closure?.assumingMemoryBound(to: MustacheContext.self).pointee else {
                    return MUSTACH_ERROR_SYSTEM
                }
                fputs(context.put(name: name), file)
                return MUSTACH_OK
            },
            enter: { closure, name in
                guard let name = name.flatMap(String.init(cString:)) else {
                    return MUSTACH_ERROR_SYSTEM
                }
                guard let context = closure?.assumingMemoryBound(to: MustacheContext.self) else {
                    return MUSTACH_ERROR_SYSTEM
                }
                return context.pointee.enter(name: name) ? 1 : 0
            },
            next: { closure in
                guard let context = closure?.assumingMemoryBound(to: MustacheContext.self) else {
                    return MUSTACH_ERROR_SYSTEM
                }
                return context.pointee.next() ? 1 : 0
            },
            leave: { closure in
                guard let context = closure?.assumingMemoryBound(to: MustacheContext.self) else {
                    return MUSTACH_ERROR_SYSTEM
                }
                context.pointee.leave()
                return MUSTACH_OK
            },
            partial: nil,
            emit: nil,
            get: nil,
            stop: nil
        )
    }
}
