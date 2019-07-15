//
//  Parser.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 15/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case noSourceFile
    case mapperNotFound
    case parsingProblem
}

class Parser {
    
    private var parsedItems: [Item] = []
    private var currentItem: Item?
    private var headers: [String] = []
    
    // MARK: - public
    
    func produceParsing(_ path: String?, mapper: Mapper?) throws {
        guard let pricatPath = path else {
            print("Can't find pricat CSV file.")
            throw ParserError.noSourceFile
        }
        guard let _ = mapper else {
            print("Mapper is not initialized.")
            throw ParserError.mapperNotFound
        }
        let pricatURL = NSURL.fileURL(withPath: pricatPath)
        
        guard let stream = InputStream(url: pricatURL) else {
            return
        }
        defer {
            stream.close()
        }
        let configuration = CSV.Configuration(delimiter: ";", encoding: .utf8)
        
        let parser = CSV.Parser(inputStream: stream, configuration: configuration)
        parser.delegate = self
        do {
            try parser.parse()
        } catch {
            throw ParserError.parsingProblem
        }
    }
}

extension Parser: ParserDelegate {
    func parserDidBeginDocument(_ parser: CSV.Parser) {
        print("DidBeginDocument")
    }
    
    func parserDidEndDocument(_ parser: CSV.Parser) {
        print("DidEndDocument \(parsedItems.count)")
    }
    
    func parser(_ parser: CSV.Parser, didBeginLineAt index: UInt) {
        if index == 0 {
            return
        }
        currentItem = Item(headers: headers)
    }
    
    func parser(_ parser: CSV.Parser, didEndLineAt index: UInt) {
        guard let currentItem = currentItem else {
            return
        }
        parsedItems.append(currentItem)
    }
    
    func parser(_ parser: CSV.Parser, didReadFieldAt index: UInt, value: String) {
        if index >= headers.count {
            headers.append(value)
            return
        }
        currentItem?.values.append(value)
    }
}
