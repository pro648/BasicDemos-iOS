import UIKit

public class NewIphone {
    public init() {
        
    }
}

/*
extension NewIphone: Machine {
    public func convert(document: Document) -> PDF? {
        return PDF(document: document)
    }
    
    public func convert(document: Document) -> UIImage? {
        // Here we could create an UIImage object with represents an image
        // with the name and the content of the document. But to make it simpler we won't
        return UIImage()
    }
    
    public func fax(document: Document) {}
}
 */


extension NewIphone: DocumentConverter {
    public func convert(document: Document) -> PDF {
        return PDF(document: document)
    }
    
    public func convert(document: Document) -> UIImage {
        // Here we could create an UIImage object with represents an image
        // with the name and the content of the document. But to make it simpler we won't
        return UIImage()
    }
}
