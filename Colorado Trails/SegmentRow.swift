//
//  SegmentRow.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//



import SwiftUI

struct SegmentRow: View {
    var segment: Segment

    var body: some View {
        VStack {
            let mainImage = segment.elevationProfile

                AsyncImage(url: URL(string: mainImage))
                { phase in
                    switch phase {
                    case .failure: Image(systemName: "photo") .font(.largeTitle)
                    case .success(let image):
                        image.resizable()
                    default: ProgressView()

                    }
                }
                .frame(width: 300, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))


            VStack(alignment: .leading) {
                Text(segment.name).bold().font(.title3)
                Text("Distance: \(segment.distance)").font(.title3)
                Text("Category: \(segment.climbCategory)").font(.body)
            }
        }
    }
}
