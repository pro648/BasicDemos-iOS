// 详细文章介绍：https://github.com/pro648/tips/wiki/%E5%A4%87%E5%BF%98%E5%BD%95%E6%A8%A1%E5%BC%8F-Memento-Pattern

import Foundation

// MARK: - Originator
public class Game: Codable {
    
    public class State: Codable {
        public var attempsRemaining: Int = 5
        public var level: Int = 1
        public var score: Int = 0
    }
    public var state = State()
    
    public func rackUpMassivePoints() {
        state.score += 8008
    }
    
    public func monstersEatPlayer() {
        state.attempsRemaining -= 1
    }
}

// MARK: - Memento
typealias GameMemento = Data

// MARK: - CareTaker
public class GameSystem {
    public static let decoder = JSONDecoder()
    public static let encoder = JSONEncoder()
    
    public static func save<T: Codable>(_ object: T, with title: String) throws {
        do {
            let url = createDocumentURL(withTitle: title)
            let data = try encoder.encode(object)
            try data.write(to: url, options: .atomic)
        } catch (let error) {
            dump(error)
            throw error
        }
    }
    
    public static func retrieve<T: Codable>(_ type: T.Type, with title: String) throws -> T {
        let url = createDocumentURL(withTitle: title)
        return try retrieve(T.self, from: url)
    }
    
    public static func retrieve<T: Codable>(_ type: T.Type, from url: URL) throws -> T{
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch (let error) {
            dump(error)
            throw error
        }
    }
    
    public static func createDocumentURL(withTitle title: String) -> URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(title).appendingPathExtension("json")
    }
}

// MARK: - Example
var game = Game()
game.monstersEatPlayer()
game.rackUpMassivePoints()

// Save Game
try? GameSystem.save(game, with: "Best Game Ever")

// New Game
game = Game()
game.state.score = 200
dump(game)

// Load Game
game = try! GameSystem.retrieve(Game.self, with: "Best Game Ever")
dump(game)
