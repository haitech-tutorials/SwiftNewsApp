//
//  ViewController.swift
//  SwiftNewsApp
//
//  Created by Tutorials on 3/31/19.
//  Copyright © 2019 HaiTech Tutorials. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UITableViewController {
    
    var playlistItems = [PlaylistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 380
        tableView.rowHeight = UITableView.automaticDimension
        
        downloadVideos()
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
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(ServerResponse.self, from: data)
                DispatchQueue.main.async {
                    response.items.forEach { item in
                        self.playlistItems.append(item)
                    }
                    self.tableView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistItems.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? PlaylistItemCell else {
            fatalError("Could not dequeue PlaylistItemCell")
        }
        
        let item = playlistItems[indexPath.row]
        cell.itemTitleLabel.text = item.title
        cell.itemTimestampLabel.text = item.publishedDate
        cell.itemImageView.sd_setImage(with: item.imageURL, completed: nil)
        return cell
    }

}

