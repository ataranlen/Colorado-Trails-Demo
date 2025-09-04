//
//  AuthAdaptor.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//


import Foundation
import UIKit
import Alamofire

actor AuthAdaptor: RequestInterceptor {
    var session: Session!

    init() {
        let config = Session.default.session.configuration
        session = Session(configuration: config, interceptor: self, eventMonitors: [])
    }

    static let shared = AuthAdaptor()
    let policy = RetryPolicy()

    static let deviceHeaders: HTTPHeaders = {
        return ["Content-Type": "application/json"]
    }()

    nonisolated func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        Task {
            var request = urlRequest
            var userAppToken = await AuthService.shared.getOauthToken()?.access ?? ""
            if userAppToken.isEmpty, let accessToken = await reAuth(true)?.access {
                userAppToken = accessToken
            }
            guard !userAppToken.isEmpty else {
                completion(.failure(AFError.sessionInvalidated(error: nil)))
                return
            }

            request.addValue("Bearer \(userAppToken)", forHTTPHeaderField: "Authorization")
            completion(.success(request))
        }
    }

    nonisolated func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        Task {
            var request = urlRequest
            request.timeoutInterval = 60
            var userAppToken = await AuthService.shared.getOauthToken()?.access ?? ""
            if userAppToken.isEmpty, let accessToken = await reAuth(true)?.access {
                userAppToken = accessToken
            }
            guard !userAppToken.isEmpty else {
                completion(.failure(AFError.sessionInvalidated(error: nil)))
                return
            }
            request.addValue("Bearer \(userAppToken)", forHTTPHeaderField: "Authorization")
            completion(.success(request))
        }
    }

    nonisolated func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, request.retryCount < 5 else {
            completion(.doNotRetry)
            return
        }
        if policy.retryableHTTPStatusCodes.contains(statusCode) {
            completion(.retryWithDelay(pow(Double(policy.exponentialBackoffBase), Double(request.retryCount)) * policy.exponentialBackoffScale))
        } else if statusCode == 401 {
            Task {
                if await reAuth(true) != nil {
                    completion(.retryWithDelay(pow(Double(policy.exponentialBackoffBase), Double(request.retryCount)) * policy.exponentialBackoffScale))
                } else {
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }

    }

    @discardableResult
    func reAuth(_ doLogout: Bool = false) async -> OauthToken?{
        let (model, afError) = await AuthService.shared.tokenRefresh()

        if let model = model, !model.access.isEmpty {
            return model
        } else if let afError = afError {
            if afError == 401, doLogout {
                await AuthService.shared.logout()
            } else {
                print("Refresh Token failed, not logging out due to error code \(afError)")
            }
            return nil
        } else {
            print("Refresh Token failed due to network, not logging out")
            return nil
        }
    }
}
