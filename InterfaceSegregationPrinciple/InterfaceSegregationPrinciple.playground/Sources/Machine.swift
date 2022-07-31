import UIKit

public protocol Machine {
    func convert(document: Document) -> PDF?
    func convert(document: Document) -> UIImage?
    func fax(document: Document)
}

public protocol DocumentConverter {
    func convert(document: Document) -> PDF
    func convert(document: Document) -> UIImage
}

public protocol Fax {
    func fax(document: Document)
}
