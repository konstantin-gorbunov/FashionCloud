//
//  ViewController.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 12/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private var mapper: Mapper?
    private let parser = Parser()
    
    private let pricatPath = Bundle.main.path(forResource: "pricat", ofType: "csv")
    private let mappingPath = Bundle.main.path(forResource: "mappings", ofType: "csv")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapper = Mapper(configPath: mappingPath)
    }
    
    // MARK: - IBActions - menus
    
    @IBAction func startParsing(_ sender: Any) {
        do {
            try parser.produceParsing(pricatPath, mapper: mapper)
        } catch {
            print("\(error)")
        }
    }
}
