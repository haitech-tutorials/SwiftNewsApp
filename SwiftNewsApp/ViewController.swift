//
//  ViewController.swift
//  SwiftNewsApp
//
//  Created by Tutorials on 3/31/19.
//  Copyright © 2019 HaiTech Tutorials. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 380
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? PlaylistItemCell else {
            fatalError("Could not dequeue PlaylistItemCell")
        }
        
        cell.itemTitleLabel.text = "Testing 12345"
        cell.itemTimestampLabel.text = "29 hours ago"
        
        return cell
    }

}

