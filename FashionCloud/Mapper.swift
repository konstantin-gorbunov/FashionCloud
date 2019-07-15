//
//  Mapper.swift
//  FashionCloud
//
//  Created by Kostiantyn Gorbunov on 12/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

struct Mapper {
    
    private enum MappingHeaders {
        static let source: String = "source"
        static let destination: String = "destination"
        static let sourceType: String = "source_type"
        static let destinationType: String = "destination_type"
        
        static let allValues = [source, destination, sourceType, destinationType]
    }
    
    var rules: [MappingRule] = []
    
    init(configPath: String?) {
        guard let configPath = configPath else {
            fatalError("Config is required")
        }
        if let content = readDataFromCSV(configPath) {
            parsingConfig(data: content)
        }
    }
    
    private mutating func parsingConfig(data: String) {
        let rawRowData = parsingRule(data)
        guard let headers = rawRowData.first else {
            fatalError("Mapping header is required")
        }
        guard let indexOfSource = headers.firstIndex(of: MappingHeaders.source),
            let indexOfSourceType = headers.firstIndex(of: MappingHeaders.sourceType),
            let indexOfDestination = headers.firstIndex(of: MappingHeaders.destination),
            let indexOfDestinationType = headers.firstIndex(of: MappingHeaders.destinationType) else {
            fatalError("Mapping header values is not complite")
        }
        for row in rawRowData {
            if row == headers || row.count < MappingHeaders.allValues.count {
                continue
            }
            let sources = row[indexOfSource].components(separatedBy: "|")
            let sourceTypes = row[indexOfSourceType].components(separatedBy: "|")
            let destination = row[indexOfDestination]
            let destinationType = row[indexOfDestinationType]
            let rule = MappingRule(sources: sources, destination: destination, sourceTypes: sourceTypes, destinationType: destinationType)
            rules.append(rule)
        }
    }
    
    private func parsingRule(_ data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    private func readDataFromCSV(_ filepath: String) -> String? {
        do {
            let rawContent = try String(contentsOfFile: filepath, encoding: .utf8)
            return cleanRows(data: rawContent)
        } catch {
            fatalError("File Read Error: \(filepath)")
        }
    }

    private func cleanRows(data: String) -> String {
        return data.replacingOccurrences(of: "\r", with: "\n").replacingOccurrences(of: "\n\n", with: "\n")
    }
}
