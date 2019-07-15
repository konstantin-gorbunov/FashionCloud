//
//  Catalog.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 15/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

class Catalog {
    
    var values: [String: String] = [:]
    var articles: [Article] = []
    
    // MARK: - public
    
    func addItem(_ item: Item) {
        guard let article = getRelatedArticle(item) else {
            print("Can't create an Article.")
            return
        }
        let variation = Variation()
        for (index, header) in item.headers.enumerated() {
            let itemValue = item.values[index]
            if let currentValue = values[header] {
                if currentValue != itemValue {
                    for art in articles {
                        art.process(header, withValue: currentValue, variation: variation)
                    }
                    article.process(header, withValue: itemValue, variation: variation)
                    values.removeValue(forKey: header)
                }
            } else {
                if isArticleHeaderPresent(header) {
                    article.process(header, withValue: itemValue, variation: variation)
                } else {
                    values[header] = itemValue
                }
            }
        }
    }
    
    // MARK: - private
    
    private func isArticleHeaderPresent(_ header: String) -> Bool {
        for article in articles {
            if article.isHeaderPresent(header) {
                return true
            }
        }
        return false
    }
    
    private func getRelatedArticle(_ item: Item) -> Article? {
        if let indexOfArticleNumber = item.headers.firstIndex(of: "article_number") {
            let value = item.values[indexOfArticleNumber]
            if let articleWithSameNumber = articles.first(where: { article -> Bool in
                return article.values["article_number"] == value
            }) {
                return articleWithSameNumber
            } else {
                let article = Article()
                article.values["article_number"] = value
                articles.append(article)
                return article
            }
        }
        return nil
    }
}

extension Catalog: CustomStringConvertible {
    
    var description: String {
        var description: String = "\(String(describing: type(of: self)))\n"
        for value in values {
            description.append("\(value.key): \(value.value)\n")
        }
        for (index, article) in articles.enumerated() {
            if index == 0 {
                description.append("\n")
            }
            description.append("\(article.description)\n")
        }
        return description
    }
}
