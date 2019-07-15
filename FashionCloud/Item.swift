//
//  Item.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 15/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

struct Item {
    let headers: [String]
    var values: [String] = []
    
    init(headers: [String]) {
        self.headers = headers
    }
}
