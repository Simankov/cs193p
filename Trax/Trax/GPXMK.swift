//
//  GPXMK.swift
//  Tracks
//
//  Created by admin on 07/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import MapKit
extension GPX.Waypoint :MKAnnotation {
    var title: String! {return name}
    var subtitle : String! { return info}
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var thumbnailURL: NSURL? {return getImageURLofType("thumbnail")}
    var imageURL: NSURL? {return getImageURLofType("large")}
    private func getImageURLofType(type: String) -> NSURL?{
        for link in links {
            if link.type == type {
                return link.url
            }
        }
        return nil
    }
}
