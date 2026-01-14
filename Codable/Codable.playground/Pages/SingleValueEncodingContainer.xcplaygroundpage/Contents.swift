//: [Previous](@previous)

import Foundation

enum Response: Codable {
    case success(String)
    case error(Int)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let message = try? container.decode(String.self) {
            self = .success(message)
        } else if let code = try? container.decode(Int.self) {
            self = .error(code)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Invalid data")
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .success(let message):
            try container.encode(message)
        case .error(let code):
            try container.encode(code)
        }
    }
}

let res = Response.success("Operation completed")
let res2 = Response.error(404)

let encoder = JSONEncoder()
let data1 = try encoder.encode(res)
let data2 = try encoder.encode(res2)

if let jsonString1 = String(data: data1, encoding: .utf8) {
    print("JSON1 输出：\(jsonString1)")
}
if let jsonString2 = String(data: data2, encoding: .utf8) {
    print("JSON2 输出：\(jsonString2)")
}

//: [Next](@next)
