//
//  RSSFeed.swift
//  XMLParser Swift5
//
//  Created by sarath kumar on 09/10/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    private var rssItem = [RSSItem]()
    private var currentElement: String = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentDate: String = "" {
        didSet {
            currentDate = currentDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            let string = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            let str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            currentDescription = str
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    // MARK: - Parse XML
    
    func parseFeed(url: String, completionHandler: @escaping ([RSSItem]) -> Void) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("uable to get the data from the server!")
                return
            }
            
            // XML parsing
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    // MARK: - XML parser delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDate = ""
            currentDescription = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "pubDate":
            currentDate += string
        case "description":
            currentDescription += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentDate)
            self.rssItem.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.parserCompletionHandler?(rssItem)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
