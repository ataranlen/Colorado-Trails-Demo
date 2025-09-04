//
//  AuthService.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//


import Foundation
import Alamofire
import OAuthSwift

actor AuthService {
    static let shared = AuthService()
    var session = Session(configuration: Session.default.session.configuration, interceptor: nil, eventMonitors: [])
    var authModel: AuthModel?
    private var oauthToken: OauthToken?
    private var refreshTask: DataTask<OauthToken>? = nil

    var oauthSwift: OAuthSwift?

    func getOauthToken() async -> OauthToken? {
        if let existingTask = refreshTask,
           let model = try? await existingTask.value {
            return model
        } else {
            return oauthToken
        }
    }

    func checkLogin() async -> Bool {
        guard authModel == nil else {
            return true
        }
        if let refresh = Keychain.refreshToken,
           !refresh.isEmpty {
            oauthToken = OauthToken()
            oauthToken?.access = Keychain.accessToken ?? ""
            oauthToken?.refresh = refresh
            return true
        }
        return false
    }

    func login() async -> OauthToken? {
        await withCheckedContinuation { continuation in
            let oAuth2Swift = OAuth2Swift(
                consumerKey:    NetworkValues.clientID,
                consumerSecret: NetworkValues.clientSecret,
                authorizeUrl:   NetworkValues.authURI,
                accessTokenUrl:  NetworkValues.refreshEndpoint,
                responseType:   "code"
            )
            oauthSwift = oAuth2Swift
            Task { @MainActor in
                let handle = oAuth2Swift.authorize(
                    withCallbackURL: "oauth-swift://localhost",
                    scope: "read", state:"") { result in
                        switch result {
                        case .success(let (credential, _, _)):
                            print(credential.oauthToken)

                            let oauthToken = OauthToken(refresh: credential.oauthRefreshToken, access: credential.oauthToken)
                            Keychain.accessToken = oauthToken.access
                            Keychain.refreshToken = oauthToken.refresh
                            Task {
                                await self.checkLogin()
                            }

                            continuation.resume(returning: oauthToken)
                        case .failure(let error):
                            print(error.localizedDescription)
                            continuation.resume(returning: nil)
                        }
                    }
            }
        }
    }

    func tokenRefresh() async -> (OauthToken?, Int?) {
        // Check if a refresh request is already in progress
        if let existingTask = refreshTask {
            do {
                // Return the `OauthToken` of the in-progress request if one exists
                return (try await existingTask.value, nil)
            } catch {
                return (nil, nil)
            }
        }
        oauthToken?.access = ""
        // Construct the authentication endpoint URL
        let authURI = NetworkValues.refreshEndpoint
        // Set the login credentials to be sent in the request body
        guard let model = oauthToken else {
            return (nil, nil)
        }
        let credentials = ["refresh": model.refresh]

        // Create a data task to make the login request
        let request = await AuthAdaptor.shared.session.request(authURI, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: AuthAdaptor.deviceHeaders, requestModifier: { input in
            input.timeoutInterval = 60
        })
        refreshTask = request.serializingDecodable(OauthToken.self)
        do {
            guard let token = try await refreshTask?.value else {
                Task {
                    await self.clearTask()
                }
                return (nil, request.response?.statusCode ?? 401)
            }
            oauthToken = token
            Keychain.accessToken = oauthToken?.access
            Keychain.refreshToken = oauthToken?.refresh
            Task {
                await self.clearTask()
            }
            return (oauthToken, nil)
        } catch {

            Task {
                await self.clearTask()
            }
            return (nil, request.response?.statusCode)
        }
    }

    func clearTask() async {
        self.refreshTask = nil
    }

    func cancelLogin() async {
        Keychain.accessToken = nil
        Keychain.refreshToken = nil
        authModel = nil
        oauthToken = nil
        self.finishLogout()
    }

    func logout() async {
        Keychain.accessToken = nil
        Keychain.refreshToken = nil
        authModel = nil
        oauthToken = nil

        self.finishLogout()
    }

    func finishLogout() {
        // Future Improvement: logout
    }
}
