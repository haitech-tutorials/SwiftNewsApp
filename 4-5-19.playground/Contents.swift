import UIKit

struct ServerResponse: Decodable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    let id: String
    let snippet: Snippet
}

struct Snippet: Decodable {
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let publishedAt: String
    let resourceId: ResourceId
}

struct Thumbnails: Decodable {
    let standard: Standard
}

struct Standard: Decodable {
    let url: URL
}

struct ResourceId: Decodable {
    let videoId: String
}

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
                print(item.snippet.thumbnails.standard.url)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    task.resume()
}

downloadVideos()

