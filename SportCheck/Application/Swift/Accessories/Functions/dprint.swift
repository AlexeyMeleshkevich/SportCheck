import Foundation

#if DEBUG

public func dprint(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
    let theFileName = (file as NSString).lastPathComponent
    let info = "\n🔥 File: \(theFileName), Function: \(function), Line: \(line) 🔥"
    print(info)
    for item in items {
        print(item, separator: separator, terminator: separator)
    }
    print(terminator, separator: "", terminator: "")
}

#else

public func dprint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
}

#endif
