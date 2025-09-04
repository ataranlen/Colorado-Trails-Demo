//
//  AuthModel.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//

import Foundation

struct AuthModel: Codable {
    let tokenType: String
    let expiresAt, expiresIn: Int
    let refreshToken, accessToken: String
    let athlete: Athlete

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresAt = "expires_at"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case athlete
    }
}
