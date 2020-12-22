import Foundation

public func example(of description: String, action: () -> Void) {
    print("--- Example of: \(description)")
    action()
    print()
}
