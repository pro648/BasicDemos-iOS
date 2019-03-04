/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Vapor
import FluentPostgreSQL
import Authentication

final class User: Codable {
  var id: UUID?
  var username: String
  var password: String
  
  init(username: String, password: String) {
    self.username = username
    self.password = password
  }
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
//extension User: Parameter {}

extension User: Migration {
  static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      builder.unique(on: \.username)
    }
  }
}

extension User: BasicAuthenticatable {
  static let usernameKey: UsernameKey = \User.username
  static let passwordKey: PasswordKey = \User.password
}

extension User: TokenAuthenticatable {
  typealias TokenType = Token
}

extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}

extension User: Validatable, Reflectable {
  static let symbols = CharacterSet(charactersIn: "!@#$%^&*-_+={}[]<>")
  static func validations() throws -> Validations<User> {
    var validations = Validations(self)
    try validations.add(\.password, .count(12...))
    try validations.add(\.password, .characterSet(.alphanumerics + User.symbols))
    return validations
  }
}
