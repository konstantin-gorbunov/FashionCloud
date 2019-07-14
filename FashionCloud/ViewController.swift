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
    
    private let pricatPath = Bundle.main.path(forResource: "pricat", ofType: "csv")
    private let mappingPath = Bundle.main.path(forResource: "mappings", ofType: "csv")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapper = Mapper(configPath: mappingPath)
    }
    
    // MARK: - IBActions - menus
    
    @IBAction func startParsing(_ sender: Any) {
        produceParsing()
    }

    // MARK: - private
    
    private func produceParsing() {
        guard let pricatPath = pricatPath else {
            print("Can't find pricat CSV file.")
            return
        }
        let pricatRequest = URLRequest(url: NSURL.fileURL(withPath: pricatPath))
        
        print("produceParsing of \(pricatRequest) with \(mapper)")
        // TODO: produceParsing
    }    
}

