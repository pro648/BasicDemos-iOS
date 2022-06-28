// 详细介绍 https://github.com/pro648/tips/blob/master/sources/%E5%BC%80%E9%97%AD%E5%8E%9F%E5%88%99.md

import Foundation

private class Person {
    private let name: String
    private let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

private class House {
    private var residents: [Person]
    
    init(residents: [Person]) {
        self.residents = residents
    }
    
    func add(_ resident: Person) {
        residents.append(resident)
    }
}
