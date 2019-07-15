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

protocol ParserSubscribtion: class {
     func parserDidEnd(_ parsedItems: [Item])
}

class Parser {
    
    public weak var delegate: ParserSubscribtion?
    
    private var parsedItems: [Item] = []
    private var currentItem: Item?
    private var headers: [String] = []
    private var mapper: Mapper?
    
    // MARK: - public
    
    func produceParsing(_ path: String?, mapper: Mapper?) throws {
        
        guard let pricatPath = path else {
            print("Can't find pricat CSV file.")
            throw ParserError.noSourceFile
        }
        guard let mapper = mapper else {
            print("Mapper is not initialized.")
            throw ParserError.mapperNotFound
        }
        self.mapper = mapper
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
    
    // MARK: - private
    
    private func mapping(_ item: inout Item, withMapper: Mapper?) {
        guard let mapper = mapper else {
            print("Mapper is not initialized.")
            return
        }
        for rule in mapper.rules {
            var sourcesIndex: [Int] = []
            var skipRule = false
            for (sourceIndex, sourceType) in rule.sourceTypes.enumerated() {
                if let indexOfSource = headers.firstIndex(of: sourceType) {
                    sourcesIndex.append(indexOfSource)
                    if item.values[indexOfSource] != rule.sources[sourceIndex] {
                        skipRule = true
                    }
                } else {
                    skipRule = true
                    print("Parser can't find source type")
                }
            }
            if skipRule {
                continue
            }
            sourcesIndex.sort()
            for index in sourcesIndex.reversed() {
                item.headers.remove(at: index)
                item.values.remove(at: index)
            }
            if let firstIndex = sourcesIndex.first {
                item.headers.insert(rule.destinationType, at: firstIndex)
                item.values.insert(rule.destination, at: firstIndex)
            }
        }
    }
}

extension Parser: ParserDelegate {
    func parserDidBeginDocument(_ parser: CSV.Parser) {
    }
    
    func parserDidEndDocument(_ parser: CSV.Parser) {
        delegate?.parserDidEnd(parsedItems)
    }
    
    func parser(_ parser: CSV.Parser, didBeginLineAt index: UInt) {
        if index == 0 {
            return
        }
        currentItem = Item(headers: headers)
    }
    
    func parser(_ parser: CSV.Parser, didEndLineAt index: UInt) {
        guard var currentItem = currentItem else {
            return
        }
        mapping(&currentItem, withMapper: mapper);
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
