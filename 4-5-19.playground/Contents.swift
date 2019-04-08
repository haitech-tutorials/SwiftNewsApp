import UIKit

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


//struct Snippet: Decodable {
//    let title: String
//    let description: String
//    let thumbnails: Thumbnails
//    let publishedAt: String
//    let resourceId: ResourceId
//}
//
//struct Thumbnails: Decodable {
//    let standard: Standard
//}
//
//struct Standard: Decodable {
//    let url: URL
//}
//
//struct ResourceId: Decodable {
//    let videoId: String
//}

func downloadVideos() {
    
    let url = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL8seg1JPkqgH-ZuXSBBXRGRlnmVtEud04&maxResults=50&key=AIzaSyAdiBfryuUjT_RDycWu5eduPw_w6SZDIQ0")!
    
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        if error != nil {
            print(error?.localizedDescription ?? "")
        }
        
        guard let data = data else { return }
        
        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//            print(json)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ServerResponse.self, from: data)
            response.items.forEach { item in
//                print(item.snippet.title)
//                print(item.snippet.publishedAt)
                print(item.publishedDate)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    task.resume()
}

downloadVideos()

