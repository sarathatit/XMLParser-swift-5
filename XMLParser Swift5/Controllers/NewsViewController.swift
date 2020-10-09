//
//  ViewController.swift
//  XMLParser Swift5
//
//  Created by sarath kumar on 09/10/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    private var rssItem: [RSSItem]?
    private var cellState: [CellState]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Custom Methods
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://developer.apple.com/news/rss/news.rss") { (rssItem) in
            self.rssItem = rssItem
            self.cellState = Array(repeating: .collapsed, count: rssItem.count)
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItem else {
            return 0
        }
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        if let item = self.rssItem?[indexPath.row] {
            cell.item = item
            cell.selectionStyle = .none
            
            if let cellState = cellState {
                cell.descriptionLabel.numberOfLines = (cellState[indexPath.row] == .expanded) ? 0 : 4
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        tableView.beginUpdates()
        cell.descriptionLabel.numberOfLines = (cell.descriptionLabel.numberOfLines == 0) ? 3 : 0
        cellState?[indexPath.row] = (cell.descriptionLabel.numberOfLines == 0) ? .expanded : .collapsed
        tableView.endUpdates()
    }

}
