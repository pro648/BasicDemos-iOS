import Foundation

public class PDF {
    public var document: Document
    
    public init(document: Document) {
        self.document = document
    }
    
    public func create() -> Data {
        // Creates the PDF with PDFKit. Not important to the example
        return Data()
    }
}
