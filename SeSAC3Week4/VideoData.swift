//
//  Video.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/16.
//

import Foundation

// MARK: - Video
struct Video: Codable {
    let documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let author: String
    let datetime: String
    let playTime: Int
    let thumbnail: String
    let title: String
    let url: String

    var contents: String {
        return "\(author) | \(playTime)회\n\(datetime)"
    }
    
    enum CodingKeys: String, CodingKey {
        case author, datetime
        case playTime = "play_time"
        case thumbnail, title, url
    }
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
