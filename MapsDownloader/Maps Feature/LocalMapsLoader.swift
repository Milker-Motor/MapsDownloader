//
//  LocalMapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

public class LocalMapsLoader {}

struct XMLParsingError: Error {}

extension LocalMapsLoader: MapsLoader {
    public func load(completion: @escaping (MapsLoader.Result) -> Void) {
        let parser = RegionXMLParser()
        guard let xmlPath = Bundle.main.path(forResource: "regions", ofType: "xml"),
              let xmlData = try? Data(contentsOf: URL(fileURLWithPath: xmlPath)),
              let parsedRegions = parser.parseRegions(from: xmlData) else {
            completion(.failure(XMLParsingError()))
            return
        }
        
        completion(.success(
            parsedRegions
                .map { Map(name: $0.name) }
                .sorted { $0.name < $1.name }
        ))
    }
    
}

private struct Region {
    let name: String
    let type: String?
    let translate: String?
    var subregions: [Region] = []
}

private class RegionXMLParser: NSObject {
    private var regions: [Region] = []
    private var currentRegion: Region?
    private var regionStack: [Region] = []
    
    func parseRegions(from xmlData: Data) -> [Region]? {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        return parser.parse() ? regions[1].subregions : nil
    }
}

extension RegionXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        
        if elementName == "region" {
            let name = attributeDict["name"]?.capitalized ?? "Unknown"
            let type = attributeDict["type"]
            let translate = attributeDict["translate"]
            let newRegion = Region(name: name, type: type, translate: translate)
            
            if let parentRegion = regionStack.last {
                var updatedParent = parentRegion
                updatedParent.subregions.append(newRegion)
                regionStack[regionStack.count - 1] = updatedParent
            } else {
                regions.append(newRegion)
            }
            
            regionStack.append(newRegion)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "region", let finishedRegion = regionStack.popLast(), regionStack.isEmpty {
            regions.append(finishedRegion)
        }
    }
}
