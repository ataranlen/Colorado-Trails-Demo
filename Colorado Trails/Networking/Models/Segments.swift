//
//  Segments.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//


import Foundation

// MARK: - Segments
struct Segments: Codable {
    let segments: [Segment]
}

// MARK: - Segment
struct Segment: Codable, Identifiable, Hashable {
    let id, resourceState: Int
    let name: String
    let climbCategory: Int
    let climbCategoryDesc: String
    let avgGrade: Double
    let startLatlng, endLatlng: [Double]
    let elevDifference, distance: Double
    let points: String
    let starred: Bool
    let elevationProfile: String
    let localLegendEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case resourceState = "resource_state"
        case name
        case climbCategory = "climb_category"
        case climbCategoryDesc = "climb_category_desc"
        case avgGrade = "avg_grade"
        case startLatlng = "start_latlng"
        case endLatlng = "end_latlng"
        case elevDifference = "elev_difference"
        case distance, points, starred
        case elevationProfile = "elevation_profile"
        case localLegendEnabled = "local_legend_enabled"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Segment, rhs: Segment) -> Bool {
        return lhs.id == rhs.id
    }
}
