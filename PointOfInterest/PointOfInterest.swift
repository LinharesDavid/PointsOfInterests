//
//  PointOfInterest.swift
//  PointOfInterest
//
//  Created by David Linhares on 28/11/2018.
//  Copyright © 2018 David Linhares. All rights reserved.
//

import Foundation

struct PointOfInterest {
    let title: String
    let details: String?
    let type: PointType
    let coordinates: (Double, Double)

    static func from(json: [String: Any]) -> PointOfInterest? {
        guard
            let title = json["title"] as? String,
            let typeInt = json["type"] as? Int,
            let type = PointType(rawValue: typeInt),
            let coordinates = json["coordinates"] as? [String: Any],
            let lat = coordinates["lat"] as? Double,
            let lon = coordinates["lon"] as? Double
        else {
            return nil
        }

        return PointOfInterest(title: title, details: json["details"] as? String, type: type, coordinates: (lat,lon))
    }
}
