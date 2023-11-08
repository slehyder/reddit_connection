//
//  SearchModel.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

struct SearchModel: Codable {
    struct Get: Codable {
        struct Request: Codable {
            var after : String?
            var query: String?
        }
        
        struct Response: Codable {
            let data: RedditData
        }
    }
}

struct RedditData: Codable {
    let after: String?
    let children: [RedditPostContainer]
}

struct RedditPostContainer: Codable {
    let data: RedditPost
}

struct RedditPost: Codable {
    let title: String
    let linkFlairText: String?
    let postHint: String?
    let url: String?
    let score: Int
    let numComments: Int

    enum CodingKeys: String, CodingKey {
        case title
        case linkFlairText = "link_flair_text"
        case postHint = "post_hint"
        case url
        case score
        case numComments = "num_comments"
    }
}
