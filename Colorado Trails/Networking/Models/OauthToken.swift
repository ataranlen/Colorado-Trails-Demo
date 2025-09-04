//
//  OauthToken.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//

import Foundation

struct OauthToken: Codable {
    var refresh: String = ""
    var access: String = ""
}
