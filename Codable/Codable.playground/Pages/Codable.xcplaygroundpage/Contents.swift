import Foundation

struct Address: Codable {
    let street: String
    let city: String
    let zipCode: String
    
//    enum CodingKeys: String, CodingKey {
//        case street
//        case city
//        case zipCode = "zip_code"
//    }
}

struct Person: Codable {
    let name: String
    let age: Int
    let address: Address
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case address
        
        case street
        case city
        case zipCode = "zip_code"
    }
    
    // 显式添加成员初始化器，因为实现了自定义 init(from decoder:) 后，编译器不会自动生成
    init(name: String, age: Int, address: Address) {
        self.name = name
        self.age = age
        self.address = address
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
        
        let street = try container.decodeIfPresent(String.self, forKey: .street)  ?? ""
        let city = try container.decodeIfPresent(String.self, forKey: .city)  ?? ""
        let zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)  ?? ""
        
        address = Address(street: street, city: city, zipCode: zipCode)
        
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(age, forKey: .age)
        try container.encodeIfPresent(address.street, forKey: .street)
        try container.encodeIfPresent(address.city, forKey: .city)
        try container.encodeIfPresent(address.zipCode, forKey: .zipCode)
    }
}


let address = Address(street: "Winterfull", city: "The North", zipCode: "1234567")
let person = Person(name: "Arya Stark", age: 18, address: address)

let encoder = JSONEncoder()
let data = try encoder.encode(person)
if let jsonStr = String(data: data, encoding: .utf8) {
    print("jsonStr: \(jsonStr)")
}

do {
    let decoder = JSONDecoder()
    let decodePerson = try decoder.decode(Person.self, from: data)
} catch {
    print("err: \(error)")
}
