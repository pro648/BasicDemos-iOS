import UIKit

public class UltraMachine {
    public init() {
        
    }
}

/*
extension UltraMachine: Machine {
    public func convert(document: Document) -> PDF? {
        return PDF(document: document)
    }
    
    public func convert(document: Document) -> UIImage? {
        // Here we could create an UIImage object with represents an image
        // with the name and the content of the document. But to make it simpler we won't
        return UIImage()
    }
    
    public func fax(document: Document) {
        print("Implementation of the ultra machine here. This is just an example, so this implementation is not relevant")
    }
}
 */

extension UltraMachine: DocumentConverter, Fax {
    public func convert(document: Document) -> PDF {
        return PDF(document: document)
    }

    public func convert(document: Document) -> UIImage {
        // Here we could create an UIImage object with represents an image
        // with the name and the content of the document. But to make it simpler we won't
        return UIImage()
    }

    public func fax(document: Document) {
        print("Implementation of the ultra machine here. This is just an example, so this implementation is not relevant")
    }
}
