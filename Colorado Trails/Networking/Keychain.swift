//
//  Keychain.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//



import Foundation
import KeychainSwift
import LocalAuthentication

private let kAccessToken = "accessToken"
private let kRefreshToken = "refreshToken"

struct Keychain {
    static let keychain = KeychainSwift()

    static var accessToken: String? {
        get {
            return keychain.get(kAccessToken)
        }
        set (newValue) {
            if let value = newValue {
                keychain.set(value, forKey: kAccessToken, withAccess: .accessibleAfterFirstUnlockThisDeviceOnly)
            } else {
                keychain.delete(kAccessToken)
            }
        }
    }

    static var refreshToken: String? {
        get {
            return keychain.get(kRefreshToken)
        }
        set (newValue) {
            if let value = newValue {
                keychain.set(value, forKey: kRefreshToken, withAccess: .accessibleAfterFirstUnlockThisDeviceOnly)
            } else {
                keychain.delete(kRefreshToken)
            }
        }
    }
}
