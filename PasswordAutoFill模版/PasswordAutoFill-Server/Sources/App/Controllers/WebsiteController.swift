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
import Leaf
import Authentication

struct WebsiteController: RouteCollection {
  func boot(router: Router) throws {
    let sessionRoutes = router.grouped(User.authSessionsMiddleware())
    let protectedRoutes = sessionRoutes.grouped(RedirectMiddleware<User>(path: "/login"))
    
    sessionRoutes.get("login", use: loginHandler)
    sessionRoutes.post(LoginPostData.self, at: "login", use: loginPostHandler)
    sessionRoutes.get("register", use: registerHandler)
    sessionRoutes.post(RegisterData.self, at: "register", use: registerPostHandler)
    
    protectedRoutes.get(use: indexHandler)
    protectedRoutes.post("logout", use: logoutHandler)
    protectedRoutes.get("changePassword", use: changePasswordHandler)
    protectedRoutes.post(ChangePasswordData.self, at: "changePassword", use: changePasswordPostHandler)
  }
  
  func indexHandler(_ req: Request) throws -> Future<View> {
    let loggedIn = try req.isAuthenticated(User.self)
    let context = IndexContext(userLoggedIn: loggedIn)
    return try req.view().render("index", context)
  }
  
  func loginHandler(_ req: Request) throws -> Future<View> {
    let error = req.query[Bool.self, at: "error"] != nil
    let message = req.query[String.self, at: "message"]
    let context = LoginContext(loginError: error, message: message)
    return try req.view().render("login", context)
  }
  
  func loginPostHandler(_ req: Request, data: LoginPostData) throws -> Future<Response> {
    return User.authenticate(username: data.username, password: data.password, using: BCryptDigest(), on: req)
      .map(to: Response.self) { user in
        guard let user = user else {
          return req.redirect(to: "/login?error")
        }
        try req.authenticateSession(user)
        return req.redirect(to: "/")
    }
  }
  
  func logoutHandler(_ req: Request) throws -> Response {
    try req.unauthenticateSession(User.self)
    return req.redirect(to: "/login")
  }
  
  func registerHandler(_ req: Request) throws -> Future<View> {
    let message = req.query[String.self, at: "message"]
    let context = RegisterContext(message: message)
    return try req.view().render("register", context)
  }
  
  func registerPostHandler(_ req: Request, data: RegisterData) throws -> Future<Response> {
    do {
      try data.validate()
    } catch (let error) {
      let redirect = redirectWith(error: error, to: "/register", on: req)
      return req.future(redirect)
    }

    let user = User(username: data.username, password: data.password)
    do {
      try user.validate()
    } catch (let error) {
      let redirect = redirectWith(error: error, to: "/register", on: req)
      return req.future(redirect)
    }
    
    user.password = try BCrypt.hash(data.password)
    return user.save(on: req).map(to: Response.self) { user in
      try req.authenticateSession(user)
      return req.redirect(to: "/")
      }
      .catchMap { error in
        return self.redirectWith(error: error, to: "/register", on: req)
    }
  }
  
  func changePasswordHandler(_ req: Request) throws -> Future<View> {
    let message = req.query[String.self, at: "message"]
    let context = ChangePasswordContext(message: message)
    return try req.view().render("changePassword", context)
  }
  
  func changePasswordPostHandler(_ req: Request, data: ChangePasswordData) throws -> Future<Response> {
    let user: User

    do {
      user = try req.requireAuthenticated(User.self)
    } catch (let error) {
      let redirect = redirectWith(error: error, to: "/login", on: req)
      return req.future(redirect)
    }
    
    do {
      try data.validate()
    } catch (let error) {
      let redirect = redirectWith(error: error, to: "/changePassword", on: req)
      return req.future(redirect)
    }
    
    return User.authenticate(username: user.username, password: data.oldPassword, using: BCryptDigest(), on: req)
      .flatMap(to: Response.self) { user in
        guard let user = user else {
          let error = BasicValidationError("Old password invalid")
          let redirect = self.redirectWith(error: error, to: "/changePassword", on: req)
          return req.future(redirect)
        }
        user.password = try BCrypt.hash(data.newPassword)
        return user.save(on: req).map(to: Response.self) { _ in
          return req.redirect(to: "/")
        }
    }
  }
}

// MARK: - Private methods

private extension WebsiteController {
  func redirectWith(error: Error, to: String, on req: Request) -> Response {
    let redirect: String
    if let error = error as? Debuggable,
      let message = error.reason.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      redirect = to + "?message=\(message)"
    } else {
      redirect = to + "?message=Unknown+error"
    }
    return req.redirect(to: redirect)
  }
}

// MARK: - Page contexts and form data

struct IndexContext: Encodable {
  let title = "Motivation"
  let motivationalLottery = MotivationalLottery()
  let userLoggedIn: Bool
}

struct LoginContext: Encodable {
  let title = "Log In"
  let loginError: Bool
  let message: String?
  
  init(loginError: Bool = false, message: String? = nil) {
    self.loginError = loginError
    self.message = message
  }
}

struct LoginPostData: Content {
  let username: String
  let password: String
}

struct RegisterContext: Encodable {
  let title = "Register"
  let message: String?
  
  init(message: String? = nil) {
    self.message = message
  }
}

struct RegisterData: Content {
  let username: String
  let password: String
  let confirmPassword: String
}

extension RegisterData: Validatable, Reflectable {
  static func validations() throws -> Validations<RegisterData> {
    var validations = Validations(self)
    try validations.add(\.password, .count(12...))
    try validations.add(\.password, .characterSet(.alphanumerics + User.symbols))
    validations.add("passwords match") { data in
      guard data.password == data.confirmPassword else {
        throw BasicValidationError("passwords don't match")
      }
    }
    return validations
  }
}

struct ChangePasswordContext: Encodable {
  let title = "Change Password"
  let message: String?
  
  init(message: String? = nil) {
    self.message = message
  }
}

struct ChangePasswordData: Content {
  let oldPassword: String
  let newPassword: String
  let confirmPassword: String
}

extension ChangePasswordData: Validatable, Reflectable {
  static func validations() throws -> Validations<ChangePasswordData> {
    var validations = Validations(self)
    try validations.add(\.newPassword, .count(12...))
    try validations.add(\.newPassword, .characterSet(.alphanumerics + User.symbols))
    validations.add("passwords match") { data in
      guard data.newPassword == data.confirmPassword else {
        throw BasicValidationError("new passwords don't match")
      }
    }
    return validations
  }
  
  
}
