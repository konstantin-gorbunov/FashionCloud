//
//  Article.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 15/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

class Article {
    
    var values: [String: String] = [:]
    var variations: [Variation] = []
    
    // MARK: - public
    
    func isHeaderPresent(_ header: String) -> Bool {
        if let _ = values[header] {
            return true
        } else if let variation = variations.first, let _ = variation.values[header] {
            return true
        }
        return false
    }
    
    func process(_ header: String, withValue itemValue: String, variation: Variation) {
        if let currentValue = values[header] {
            if currentValue != itemValue {
                if variations.count == 0 {
                    variations.append(Variation())
                }
                for variation in variations {
                    variation.values[header] = currentValue
                }
                values.removeValue(forKey: header)
                
                setVariationValue(variation, header: header, value: itemValue)
            }
        } else {
            if let firstVariation = variations.first, let _ = firstVariation.values[header] {
                setVariationValue(variation, header: header, value: itemValue)
            } else {
                values[header] = itemValue
            }
        }
    }
    
    // MARK: - private
    
    private func setVariationValue(_ variation: Variation, header: String, value: String) {
        variation.values[header] = value
        if needAddVariation(variation) {
            variations.append(variation)
        }
    }
    
    private func needAddVariation(_ variation: Variation) -> Bool {
        if let _ = variations.firstIndex(where: { obj -> Bool in
            return obj === variation
        }) {
            return false
        }
        return true
    }
}

extension Article: CustomStringConvertible {
    
    var description: String {
        var description: String = "\(String(describing: type(of: self)))\n"
        for value in values {
            description.append("\(value.key): \(value.value)\n")
        }
        for (index, variation) in variations.enumerated() {
            if index == 0 {
                description.append("\n")
            }
            description.append("\(variation.description)\n")
        }
        return description
    }
}
