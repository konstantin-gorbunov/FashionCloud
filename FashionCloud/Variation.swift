//
//  Variation.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 15/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

class Variation {
    
    var values: [String: String] = [:]
}

extension Variation: CustomStringConvertible {
    
    var description: String {
        var description: String = "\(String(describing: type(of: self)))\n"
        for value in values {
            description.append("\(value.key): \(value.value)\n")
        }
        return description
    }
}

extension Variation: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(values, forKey: .id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Variation"
    }
}
