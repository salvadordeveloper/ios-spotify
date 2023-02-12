//
//  AuthManager.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()

    private var refreshingToken = false

    private init() {}

    public var signInURL: URL? {

        let base = "https://accounts.spotify.com/authorize"

        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    var isSignedIn: Bool {
        return accessToken != nil
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }

    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }

    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }

    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300

        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }

    public func exchangeCodeForToken(
        code: String,
        completion: @escaping(Bool) -> Void) {
        // Get Token
            guard let url = URL(string: Constants.tokenAPIURL) else { return  }

            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
            ]
            var request = URLRequest(url: url)
            request.httpMethod  = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            let basicToken = Constants.clientID+":"+Constants.clientSecret
            let data = basicToken.data(using: .utf8)
            guard let base64String = data?.base64EncodedString() else {
                print("Error: failure to get base64 ")
                completion(false)
                return
            }
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            request.httpBody = components.query?.data(using: .utf8 )

           let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                     return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print("Success: \(json)")

                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self.cacheToken(result: result)
                    completion(true)
                } catch {
                    print("Error: \(error.localizedDescription)")
                    completion(false)

                }
            }
            task.resume()

    }

    private var onRefreshBlocks = [((String) -> Void)]()
    ///  Supply valid token to be u   sed with Api calls
    public func withValidToken(completion: @escaping (String) -> Void) {

        guard !refreshingToken else {
            // Append the completion
            onRefreshBlocks.append(completion)
            return
        }

        if shouldRefreshToken {
            // refresh token
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }

    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {

        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }

        // Refresh the Token
        guard let url = URL(string: Constants.tokenAPIURL) else { return  }

        refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: url)
        request.httpMethod  = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Error: failure to get base64 on refresh Token ")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8 )

       let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in

           self?.refreshingToken = false

           guard let data = data, error == nil else {
                 return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Success: \(json)")

                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.accessToken) }

                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print("Error: \(error.localizedDescription)")
                completion?(false)

            }
        }
        task.resume()

    }

    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "access_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn)),
                                       forKey: "expirationDate")

        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }

    }

    public func signout(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        completion(true)
    }

}
