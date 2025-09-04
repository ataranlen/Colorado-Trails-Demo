//
//  SegmentService.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//

import Foundation
import Alamofire

actor SegmentService {
    func fetch() async -> ([Segment], AFError?) {
        let coloradoFetchURI = URL(string: "https://www.strava.com/api/v3/segments/explore?bounds=37.00250395323338,-109.04545022572077,41.00242518721939,-102.05156506073824&activity_type=riding")!

        let request = await AuthAdaptor.shared.session.request(coloradoFetchURI, method: .get , encoding: JSONEncoding.default, headers: AuthAdaptor.deviceHeaders)

        let task = request.validate().serializingDecodable(Segments.self)
        do {
            let value = try await task.value
            return (value.segments, nil)
        } catch (let error) {
            return ([], request.error)
        }
    }
}
