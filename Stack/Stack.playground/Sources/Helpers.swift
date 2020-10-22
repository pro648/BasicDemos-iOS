import Foundation

public func example(of description: String, action: () -> ()) {
    print("--- Example of \(description)")
    action()
    print()
}
