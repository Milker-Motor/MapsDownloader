//
//  LocalMapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

public class LocalRegionLoader {}

struct XMLParsingError: Error {}

extension LocalRegionLoader: RegionLoader {
    public func load(completion: @escaping (RegionLoader.Result) -> Void) {
        let parser = RegionXMLParser()
        guard let xmlPath = Bundle.main.path(forResource: "regions", ofType: "xml"),
              let xmlData = try? Data(contentsOf: URL(fileURLWithPath: xmlPath)),
              let parsedRegions = parser.parseRegions(from: xmlData) else {
            completion(.failure(XMLParsingError()))
            return
        }
        
        completion(.success(parsedRegions.toMaps().sorted { $0.name < $1.name }))
    }
}

extension Array where Element == RegionXML {
    func toMaps() -> [Region] {
        map { region in
            Region(name: region.name, parent: region.parent?.name, regions: region.subregions.toMaps())
        }
    }
}

private final class RegionXML {
    let name: String
    let map: String?
    let type: String?
    let translate: String?
    var parent: RegionXML?
    var subregions: [RegionXML]
    
    init(name: String, map: String?, type: String?, translate: String?, subregions: [RegionXML] = []) {
        self.name = name
        self.map = map
        self.type = type
        self.translate = translate
        self.subregions = subregions
    }
}

private class RegionXMLParser: NSObject {
    private var regions: [RegionXML] = []
    private var currentRegion: RegionXML?
    private var regionStack: [RegionXML] = []
    
    func parseRegions(from xmlData: Data) -> [RegionXML]? {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        return parser.parse() ? regions[1].subregions : nil
    }
}

extension RegionXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        
        guard elementName == "region" else { return }
        
        let name = attributeDict["name"]?.capitalized ?? "Unknown"
        let map = attributeDict["map"]
        let type = attributeDict["type"]
        let translate = attributeDict["translate"]
        let newRegion = RegionXML(name: name, map: map, type: type, translate: translate)
        
        if let parentRegion = regionStack.last {
            let updatedParent = parentRegion
            updatedParent.subregions.append(newRegion)
            regionStack[regionStack.count - 1] = updatedParent
            if parentRegion.name != "Europe" {
                newRegion.parent = parentRegion
            }
        } else {
            regions.append(newRegion)
        }
        
        regionStack.append(newRegion)
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "region", let finishedRegion = regionStack.popLast(), regionStack.isEmpty {
            regions.append(finishedRegion)
        }
    }
}
