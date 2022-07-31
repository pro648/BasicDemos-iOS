import UIKit

public class FaxMachine {
    public init() {
        
    }
}

/*
extension FaxMachine: Machine {
    public func convert(document: Document) -> PDF? {
        return nil // This is because a fax machine cannot do that
    }
    
    public func convert(document: Document) -> UIImage? {
        return nil // This is because a fax machine cannot do that
    }
    
    public func fax(document: Document) {
        Swift.print("Implementation of the fax here. This is just an example, so this implementation is not relevant")
    }
}
 */

extension FaxMachine: Fax {
    public func fax(document: Document) {
        Swift.print("Implementation of the fax here. This is just an example, so this implementation is not relevant")
    }
}
