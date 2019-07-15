//
//  ViewController.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 12/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    private enum Parser: Error {
        case noSourceFile
        case mapperNotFound
        case parsingProblem
    }

    private var mapper: Mapper?
    
    private let pricatPath = Bundle.main.path(forResource: "pricat", ofType: "csv")
    private let mappingPath = Bundle.main.path(forResource: "mappings", ofType: "csv")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapper = Mapper(configPath: mappingPath)
    }
    
    // MARK: - IBActions - menus
    
    @IBAction func startParsing(_ sender: Any) {
        do {
            try produceParsing()
        } catch {
            print("\(error)")
        }
    }

    // MARK: - private
    
    private func produceParsing() throws {
        guard let pricatPath = pricatPath else {
            print("Can't find pricat CSV file.")
            throw Parser.noSourceFile
        }
        guard let _ = mapper else {
            print("Mapper is not initialized.")
            throw Parser.mapperNotFound
        }
        let pricatURL = NSURL.fileURL(withPath: pricatPath)

        guard let stream = InputStream(url: pricatURL) else {
            return
        }
        let configuration = CSV.Configuration(delimiter: ";", encoding: .utf8)

        let parser = CSV.Parser(inputStream: stream, configuration: configuration)
        parser.delegate = self
        do {
            try parser.parse()
        } catch {
            throw Parser.parsingProblem
        }
    }    
}

extension ViewController: ParserDelegate {
    func parserDidBeginDocument(_ parser: CSV.Parser) {
        print("DidBeginDocument")
    }
    
    func parserDidEndDocument(_ parser: CSV.Parser) {
        print("DidEndDocument")
    }
    
    func parser(_ parser: CSV.Parser, didBeginLineAt index: UInt) {
        
    }
    
    func parser(_ parser: CSV.Parser, didEndLineAt index: UInt) {
        print("DidEndLine \(index)")
    }
    
    func parser(_ parser: CSV.Parser, didReadFieldAt index: UInt, value: String) {
        
    }
}
