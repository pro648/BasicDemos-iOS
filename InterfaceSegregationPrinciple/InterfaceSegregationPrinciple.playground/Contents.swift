
// 详细介绍：https://github.com/pro648/tips/blob/master/sources/%E6%8E%A5%E5%8F%A3%E9%9A%94%E7%A6%BB%E5%8E%9F%E5%88%99.md

import UIKit

/*
let document = Document(name: "Document Name", content: "Document Content")
let iPhone: Machine = NewIphone()
if let pdf: PDF = iPhone.convert(document: document) {
    print(pdf)
}
 */

let document = Document(name: "Document Name", content: "Document Content")
let ultraMachine: DocumentConverter = UltraMachine()
let pdf: PDF = ultraMachine.convert(document: document)
print(pdf)
