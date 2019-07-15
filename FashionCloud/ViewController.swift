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
    private var catalog = Catalog()
    
    private let pricatPath = Bundle.main.path(forResource: "pricat", ofType: "csv")
    private let mappingPath = Bundle.main.path(forResource: "mappings", ofType: "csv")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapper = Mapper(configPath: mappingPath)
        parser.delegate = self
    }
    
    // MARK: - IBActions - menus
    
    @IBAction func startParsing(_ sender: Any) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                try self?.parser.produceParsing(self?.pricatPath, mapper: self?.mapper)
            } catch {
                print("\(error)")
            }
        }
    }
    
    // MARK: - private
    
    private func printJSON(_ items: [Item]) {
        if let jsonData = try? JSONEncoder().encode(items) {
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
        } else {
            print("Parser can't encode items.")
        }
    }
    
    private func printJSON(_ catalog: Catalog?) {
        if let jsonData = try? JSONEncoder().encode(catalog),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Parser can't encode items.")
        }
    }
}

extension ViewController: ParserSubscribtion {
    
    func parserDidEnd(_ parsedItems: [Item]) {
        for item in parsedItems {
            catalog.addItem(item)
        }
        DispatchQueue.main.async { [weak self] in
            self?.printJSON(self?.catalog)
        }
    }
}
