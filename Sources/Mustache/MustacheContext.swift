import CMustache

struct MustacheContext {
    var stack: [MustacheData]
    var index: Int

    init(data: [String: MustacheData]) {
        self.stack = [.dictionary(data)]
        self.index = 0
    }

    func put(name: String) -> String {
        guard let data = self.get(name: name) else {
            return ""
        }
        switch data {
        case .array, .dictionary:
            return ""
        case .string(let string):
            return string
        }
    }

    func get(name: String) -> MustacheData? {
        var stack = self.stack
        while let context = stack.popLast() {
            if let value = self.get(name: name, data: context) {
                return value
            }
        }
        return nil
    }

    func get(name: String, data: MustacheData) -> MustacheData? {
        var current: MustacheData = data

        var it = name.split(separator: ".").makeIterator()
        while let path = it.next() {
            guard case .dictionary(let data) = current else {
                return nil
            }
            guard let value = data[String(path)] else {
                return nil
            }
            current = value
        }

        return current
    }

    mutating func next() -> Bool {
        guard let data = self.stack.last else {
            fatalError("stack popped too far")
        }
        switch data {
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
        guard let data = self.get(name: name) else {
            return false
        }
        switch data {
        case .dictionary, .array:
            self.stack.append(data)
            return true
        case .string(let string):
            if !["false", "0"].contains(string.lowercased()) {
                self.stack.append(data)
                return true
            } else {
                return false
            }
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
                guard let file = file else {
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
