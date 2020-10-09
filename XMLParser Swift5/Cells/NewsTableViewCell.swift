//
//  NewsTableViewCell.swift
//  XMLParser Swift5
//
//  Created by sarath kumar on 09/10/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit

enum CellState {
    case expanded
    case collapsed
}

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var item: RSSItem! {
        didSet {
            self.titleLabel.text = item.title
            self.descriptionLabel.text = item.description
            self.dateLabel.text = item.pubDate
        }
    }
    
}
