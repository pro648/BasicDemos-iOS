// 详细介绍：https://github.com/pro648/tips/blob/master/sources/%E9%9D%A2%E5%90%91%E5%8D%8F%E8%AE%AE%E7%BC%96%E7%A8%8B.md

import UIKit

//protocol Bird {
//    var name: String { get }
//    var canFly: Bool { get }
//}

// Bird协议遵守CustomStringConvertible协议。
protocol Bird: CustomStringConvertible {
    var name: String { get }
    var canFly: Bool { get }
}

extension CustomStringConvertible where Self: Bird {
    var description: String {
        canFly ? "I can fly" : "Guess I'll just sit here"
    }
}

extension Bird {
    // Flyable birds can fly.
    var canFly: Bool { self is Flyable }
}

protocol Flyable {
    var airspeedVelocity: Double { get }
}

struct FlappyBird: Bird, Flyable {
    var name: String
    let flappyAmplitude: Double
    let flappyFrequency: Double
    let canFly = true
    
    var airspeedVelocity: Double {
        3 * flappyFrequency * flappyAmplitude
    }
}

struct Penguin: Bird {
    let name: String
    let canFly = false
}

struct SwiftBird: Bird, Flyable {
    var name: String { "Swift \(version)"}
    let canFly = true
    let version: Double
    private var speedFactor = 1000.0
    
    init(version: Double) {
        self.version = version
    }
    
    var airspeedVelocity: Double {
        version * speedFactor
    }
}

// enum也可以遵守协议
enum UnladenSwallow: Bird, Flyable {
    case african
    case european
    case unknown
    
    var name: String {
        switch self {
        case .african:
            return "African"
        case .european:
            return "European"
        case .unknown:
            return "What do you mean? African or European?"
        }
    }
    
    var airspeedVelocity: Double {
        switch self {
        case .african:
            return 10.0
        case .european:
            return 9.9
        case .unknown:
            fatalError("You are thrown from the bridge of death!")
        }
    }
}

extension UnladenSwallow {
    var canFly: Bool {
        self != .unknown
    }
}

UnladenSwallow.unknown.canFly   // false
UnladenSwallow.african.canFly   // true
Penguin(name: "King Penguin").canFly    // false

UnladenSwallow.african

let numbers = [10, 20, 30, 40, 50, 60]
let slice = numbers[1...3]
let reversedSlice = slice.reversed()

let answer = reversedSlice.map({ $0 * 10 })
print(answer)

class Motorcycle {
    init(name: String) {
        self.name = name
        speed = 200.0
    }
    
    var name: String
    var speed: Double
}

// 声明Racer协议，指定竞赛的指标。
protocol Racer {
    var speed: Double { get }
}

// 下面类型均遵守了Racer协议，即均可以进行比赛。
extension FlappyBird: Racer {
    var speed: Double {
        airspeedVelocity
    }
}

extension SwiftBird: Racer {
    var speed: Double {
        airspeedVelocity
    }
}

extension Penguin: Racer {
    var speed: Double {
        42
    }
}

extension UnladenSwallow: Racer {
    var speed: Double {
        canFly ? airspeedVelocity : 0.0
    }
}

extension Motorcycle: Racer { }

// 数组中实例均遵守了Racer协议
let racers: [Racer] = [
    UnladenSwallow.african,
    UnladenSwallow.european,
    UnladenSwallow.unknown,
    Penguin(name: "King Penguin"),
    SwiftBird(version: 5.1),
    FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0),
    Motorcycle(name: "Giacomo")
]

/// 查找速度最快的选手
//func topSpeed(of racers: [Racer]) -> Double {
//    racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
//}
//topSpeed(of: racers)

// RacersType是范型，需遵守Sequence协议。
// where语句指定Sequence的元素必须遵守Racer协议。
func topSpeed<RacersType: Sequence>(of racers: RacersType) -> Double where RacersType.Iterator.Element == Racer {
    racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}

topSpeed(of: racers[1...3])

// 当Sequence的元素为Racer类型时，为其添加topSpeed方法。
extension Sequence where Iterator.Element == Racer {
    func topSpeed() -> Double {
        self.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
    }
}

racers.topSpeed()
racers[1...3].topSpeed()

protocol Score: Comparable {
    var value: Int { get }
}

struct RacingScore: Score {
    let value: Int
    
    static func <(lhs: RacingScore, rhs: RacingScore) -> Bool {
        lhs.value < rhs.value
    }
}

RacingScore(value: 150) >= RacingScore(value: 130)  // true

protocol Cheat {
    mutating func boost(_ power: Double)
}

extension SwiftBird: Cheat {
    // 修改speedFactor，让其增加power。
    mutating func boost(_ power: Double) {
        speedFactor += power
    }
}

// 创建可变对象
var swiftBird = SwiftBird(version: 5.0)
// 速度增加3
swiftBird.boost(3.0)
swiftBird.airspeedVelocity  // 5015
// 速度再次增加3
swiftBird.boost(3.0)
swiftBird.airspeedVelocity  // 5030
