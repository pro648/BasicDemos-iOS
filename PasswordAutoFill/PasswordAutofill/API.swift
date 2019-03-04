//  API.swift
//  PasswordAutofill
//
//  Created by pro648 on 2019/2/23
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

// MARK: - return types

public enum APIResult {
    case success
    case failure(_ error: String?)
}

public enum MotivationalLotteryResult {
    case success(_ motivation: String)
    case failure
}

// MARK: - API access class

public class API {
    // Update this URL definition
    static let baseURL = URL(string: "https://safe-ridge-91450.herokuapp.com")
    
    static let defaultsKey = "TOKEN-KEY"
    static let defaults = UserDefaults.standard
    
    public static var token: String? {
        get {
            return defaults.string(forKey: API.defaultsKey)
        }
        set {
            defaults.set(newValue, forKey: API.defaultsKey)
        }
    }
    
    // MARK: - Access fuctions
    
    /// Register a new user and save the returned access token.
    ///
    /// - Parameters:
    /// - username: desired username
    /// - password: desired password
    /// - completion: closure that receives an 'APIResult' after the call completes. This is **NOT** called on the main thread.
    public static func register(_ username: String, password: String, completion: @escaping (APIResult) -> Void) {
        struct RegisterData: Encodable {
            let username: String
            let password: String
        }
        guard let baseURL = API.baseURL else {
            completion(.failure(nil))
            return
        }
        let body = RegisterData(username: username, password: password)
        let url = baseURL.appendingPathComponent("/api/user")
        var registerRequest = URLRequest(url: url)
        registerRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        registerRequest.httpMethod = "POST"
        
        do {
            registerRequest.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(nil))
            return
        }
        
        URLSession.shared.dataTask(with: registerRequest) { (data, response, _) in
            DispatchQueue.main.async {
                guard let jsonData = data else {
                    completion(.failure(nil))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode else {
                        do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                            if let error = json?["reason"] as? String {
                                completion(.failure(error))
                                return
                            }
                        } catch { }
                        completion(.failure(nil))
                        return
                }
                
                do {
                    let token = try JSONDecoder().decode(Token.self, from: jsonData)
                    self.token = token.token
                    completion(.success)
                } catch {
                    completion(.failure(nil))
                }
            }
            }
            .resume()
    }
    
    
    /// Login an existing user and save the returned access token.
    ///
    /// - Parameters:
    /// - username: user's username
    /// - password: user's password
    /// - completion: closure that receives an 'APIResult' after the call completes, This is **NOT** called on the main thread.
    public static func login(_ username: String, password: String, completion: @escaping (APIResult) -> Void) {
        guard let loginString = "\(username):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
            else {
                fatalError()
        }
        
        guard let baseURL = baseURL else {
            completion(.failure(nil))
            return
        }
        
        let url = baseURL.appendingPathComponent("/api/login")
        var  loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: loginRequest) { (data, response, _) in
            DispatchQueue.main.async {
                guard let jsonData = data else {
                    completion(.failure(nil))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode else {
                        do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                            if let error = json?["reason"] as? String {
                                completion(.failure(error))
                                return
                            }
                        } catch { }
                        completion(.failure(nil))
                        return
                }
                
                do {
                    let token = try JSONDecoder().decode(Token.self, from: jsonData)
                    self.token = token.token
                    completion(.success)
                } catch {
                    completion(.failure(nil))
                }
            }
            }
            .resume()
    }
    
    
    /// Log the user out and delete the saved access token.
    public static func logout() {
        guard let baseURL = baseURL, let token = token else {
            return
        }
        
        let url = baseURL.appendingPathComponent("/api/logout")
        var logoutRequest = URLRequest(url: url)
        logoutRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        logoutRequest.httpMethod = "POST"
        URLSession.shared.dataTask(with: logoutRequest) { (_, response, _) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode
                    else {
                        return
                }
                self.token = nil
            }
            }
            .resume()
    }
    
    
    /// Change the user's password
    ///
    /// - Parameters:
    /// - newPassword: the desired new password
    /// - completion: closure that receives an 'APIRequest' after the call completes. This is **NOT** called on the main thread.
    public static func changePassword(_ newPassword: String, completion: @escaping (APIResult) -> Void) {
        struct NewPasswordData: Encodable {
            let newPassword: String
        }
        
        guard let baseURL = baseURL, let token = token else {
            completion(.failure(nil))
            return
        }
        let body = NewPasswordData(newPassword: newPassword)
        let url = baseURL.appendingPathComponent("/api/user")
        var changeRequest = URLRequest(url: url)
        changeRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        changeRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        changeRequest.httpMethod = "PUT"
        do {
            changeRequest.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(nil))
            return
        }
        
        URLSession.shared.dataTask(with: changeRequest) { (_, response, _) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode else {
                        completion(.failure(nil))
                        return
                }
                
                completion(.success)
            }
            }
            .resume()
    }
    
    
    /// Retrieve a new motivational quote for the logged in user
    ///
    /// - Parameter completion: closure that receives a 'MotivationalLotteryResult' after the call completes. This is **NOT** called on the main thread.
    public static func motivationalLottery(_ completion: @escaping (MotivationalLotteryResult) -> Void) {
        struct MotivationalLotteryData: Decodable {
            let motivation: String
        }
        guard let baseURL = baseURL,
            let token = token else {
                completion(.failure)
                return
        }
        let url = baseURL.appendingPathComponent("/api/motivation")
        var motivationalLotteryRequest = URLRequest(url: url)
        motivationalLotteryRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        motivationalLotteryRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: motivationalLotteryRequest) { (data, response, _) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                    200..<200 ~= httpResponse.statusCode,
                    let jsonData = data else {
                        completion(.failure)
                        return
                }
                do {
                    let motivationalLottery = try JSONDecoder().decode(MotivationalLotteryData.self, from: jsonData)
                    completion(.success(motivationalLottery.motivation))
                } catch {
                    completion(.failure)
                }
            }
            }
            .resume()
    }
}

// MARK: - private structure

final class Token: Codable {
    var token: String
    var userID: UUID
    
    init(token: String, userID: UUID) {
        self.token = token
        self.userID = userID
    }
}
