//
//  PlaylistItem.swift
//  SwiftNewsApp
//
//  Created by Tutorials on 4/15/19.
//  Copyright © 2019 HaiTech Tutorials. All rights reserved.
//

import Foundation

struct ServerResponse: Decodable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    let id: String
    let title: String
    let description: String
    let imageURL: URL
    let publishedDate: String
    let videoId: String
    
    private enum ItemCodingKeys: String, CodingKey {
        case id
        case snippet
    }
    
    private enum SnippetCodingKeys: String, CodingKey {
        case title
        case description
        case thumbnails
        case publishedDate = "publishedAt"
        case resourceId
    }
    
    private enum ThumbnailsCodingKeys: String, CodingKey {
        case standard
    }
    
    private enum StandardCodingKeys: String, CodingKey {
        case imageURL = "url"
    }
    
    private enum ResourceIdCodingKeys: String, CodingKey {
        case videoId
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: ItemCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        
        let snippetContainer = try container.nestedContainer(keyedBy: SnippetCodingKeys.self, forKey: .snippet)
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        self.publishedDate = try snippetContainer.decode(String.self, forKey: .publishedDate)
        
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: ThumbnailsCodingKeys.self, forKey: .thumbnails)
        
        let standardContainer = try thumbnailsContainer.nestedContainer(keyedBy: StandardCodingKeys.self, forKey: .standard)
        self.imageURL = try standardContainer.decode(URL.self, forKey: .imageURL)
        
        let resourceContainer = try snippetContainer.nestedContainer(keyedBy: ResourceIdCodingKeys.self, forKey: .resourceId)
        self.videoId = try resourceContainer.decode(String.self, forKey: .videoId)
    }
}
