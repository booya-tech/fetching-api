//
//  WongnaiData.swift
//  lineman-assignment
//
//  Created by Panachai Sulsaksakul on 4/17/23.
//

import Foundation

struct WongnaiData: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let name: String
    let image_url: [String]
    let description: String
    let positive_votes_count: Int
}
