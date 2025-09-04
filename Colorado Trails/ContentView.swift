//
//  ContentView.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//

import SwiftUI
import OAuthSwift

struct ContentView: View {

    var oauthSwift: OAuthSwift?

    @State private var segments: [Segment] = []
    var body: some View {
        NavigationStack {
            List(segments) { segment in
//                NavigationLink {
//                    // Future improvement: open the segment view
//                } label: {
                    SegmentRow(segment: segment)
//                }
            }
            .scrollContentBackground(.hidden)
            .background(.white)
            .navigationTitle("Colorado Trails")
            .task() {
                await login()
            }
        }
    }

    private func login() async {

        if await !AuthService.shared.checkLogin(){
            let token = await AuthService.shared.login()
            if token != nil {
                await fetchRemoteData()
            }
        } else {
            await fetchRemoteData()
        }
    }

    private func fetchRemoteData() async {

        let segmentService = SegmentService()

        let (results, _) = await segmentService.fetch()
        self.segments =  results
    }
}

#Preview {
    ContentView()
}
