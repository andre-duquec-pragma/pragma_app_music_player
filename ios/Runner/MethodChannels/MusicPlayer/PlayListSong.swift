//
//  PlaylistSong.swift
//  Runner
//
//  Created by Andres Duque on 28/02/23.
//

import Foundation

struct PlayListSong {
    let url: String?
    let name: String?

    init(from encodedData: [String: Any]) {
        self.url = encodedData["url"] as? String
        self.name = encodedData["name"] as? String
    }
}
