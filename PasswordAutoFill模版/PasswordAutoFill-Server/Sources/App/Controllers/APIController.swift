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

struct APIController: RouteCollection {
  func boot(router: Router) throws {
    let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
    let tokenAuthMiddleware = User.tokenAuthMiddleware()
    let guardAuthMiddleware = User.guardAuthMiddleware()
    
    let apiGroup = router.grouped("api")
    let basicAuthGroup = apiGroup.grouped(basicAuthMiddleware)
    let tokenAuthGroup = apiGroup.grouped(tokenAuthMiddleware, guardAuthMiddleware)
    
    apiGroup.post(User.self, at: "user", use: createHandler)
    tokenAuthGroup.put(NewPasswordData.self, at: "user", use: changePasswordHandler)
    basicAuthGroup.post("login", use: loginHandler)
    tokenAuthGroup.post("logout", use: logoutHandler)
    tokenAuthGroup.get("motivation", use: motivationalHandler)
  }
  
  func createHandler(_ req: Request, user: User) throws -> Future<Token> {
    try user.validate()
    user.password = try BCrypt.hash(user.password)
    return user.save(on: req).flatMap { user in
      let token = try Token.generate(for: user)
      return token.save(on: req)
    }
  }
  
  func changePasswordHandler(_ req: Request, data: NewPasswordData) throws -> Future<HTTPStatus> {
    try data.validate()
    let user = try req.requireAuthenticated(User.self)
    user.password = try BCrypt.hash(data.newPassword)
    return user.save(on: req).transform(to: .noContent)
  }
  
  func loginHandler(_ req: Request) throws -> Future<Token> {
    let user = try req.requireAuthenticated(User.self)
    let token = try Token.generate(for: user)
    return token.save(on: req)
  }
  
  func logoutHandler(_ req: Request) throws -> Future<HTTPStatus> {
    let user = try req.requireAuthenticated(User.self)
    return try Token.query(on: req)
      .filter(\.userID == user.requireID())
      .delete()
      .transform(to: .noContent)
  }
  
  func motivationalHandler(_ req: Request) -> MotivationalLottery {
    return MotivationalLottery()
  }
}

struct NewPasswordData: Content {
  let newPassword: String
}

extension NewPasswordData: Validatable, Reflectable {
  static func validations() throws -> Validations<NewPasswordData> {
    var validations = Validations(self)
    try validations.add(\.newPassword, .count(12...))
    try validations.add(\.newPassword, .characterSet(.alphanumerics + User.symbols))
    return validations
  }
}
