//
//  Athlete.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//


struct Athlete: Codable {
    let id: Int
    let username: String
    let resourceState: Int
    let firstname, lastname, city, state: String
    let country: String?

    enum CodingKeys: String, CodingKey {
        case id, username
        case resourceState = "resource_state"
        case firstname, lastname, city, state, country
    }
}
