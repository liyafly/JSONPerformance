//
//  HandyAirport.swift
//  JSONPerformance
//
//  Created by 李亚非 on 2021/7/10.
//

import Foundation
import HandyJSON
import ObjectMapper
import SwiftyJSON

public struct HandyAirport: HandyJSON {
    
    public init() { }
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
    
    public struct Runway: HandyJSON {
        public init() {  }
        enum Surface: String, HandyJSONEnum {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        var direction: String?
        var distance: Int?
        var surface: Surface?
    }
    
    var runways: [Runway]?
}

public struct ObjectAirport: Mappable {
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
    var runways: [Runway]?
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        name <- map["name"]
        iata <- map["iata"]
        icao <- map["icao"]
        coordinates <- map["coordinates"]
        runways <- map["runways"]
    }
    
    public struct Runway: Mappable {
        enum Surface: String {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        var direction: String?
        var distance: Int?
        var surface: Surface?
        
        public init?(map: Map) {
            
        }
        
        public mutating func mapping(map: Map) {
            direction <- map["direction"]
            distance <- map["distance"]
            surface <- map["surface"]
        }
        
        
    }
}


public struct AirportJSON {
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
    var runways: [RunwayJSON]?

    public init(jsonData: JSON) {
        name = jsonData["name"].string
        iata = jsonData["iata"].string
        icao = jsonData["icao"].string
        coordinates = jsonData["coordinates"].arrayObject as? [Double]
        let runwaysArray = jsonData["runways"].array ?? []
        runways = runwaysArray.map { RunwayJSON(jsonDate: $0) }
    }
    
    public struct RunwayJSON {
        enum Surface: String {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        public init(jsonDate: JSON) {
            direction = jsonDate["direction"].string
            distance = jsonDate["distance"].int
            let surfaceRawValue = jsonDate["surface"].string
            surface = Surface(rawValue: surfaceRawValue ?? "other")
        }
        var direction: String?
        var distance: Int?
        var surface: Surface?
        
       
        
        
    }
}
