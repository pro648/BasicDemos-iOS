import Foundation

protocol Resident {}

private class Person: Resident {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

private class House {
    var residents: [Resident]

    init(residents: [Resident]) {
        self.residents = residents
    }

    func add(_ resident: Resident) {
        residents.append(resident)
    }
}

private struct NewPerson: Resident {
    let name: String
    let age: Int
    
    func complexMethod() {
        // Process something
    }
    
    func otherMethod() {
        // Process something
    }
}
