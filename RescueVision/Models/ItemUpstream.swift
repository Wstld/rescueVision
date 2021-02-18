//
//  ItemUpstream.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-02-10.
//

import Foundation
struct ItemUpstream:Codable,Identifiable,Hashable {
    enum CodingKeys:String,CodingKey {
        case properties = "properties"
        case name = "name"
        case id = "id"
        case contains = "contains"
        case info = "info"
    }
    let name:String
    let id:Int
    var contains:[Ittem]?
    var properties: [PropertyVals]
    var info:Infotry?


}

//MARK: - InvetoryItem
struct Ittem:Codable,Hashable {
    let name:String
    let amount:Int
}

//MARK: - PropertyValues
struct PropertyVals:Codable,Hashable {
    let text:String
    let value:Int
    let unit:String
}

//MARK: -InfoEntry

struct Infotry:Codable,Hashable {
    var warning:[String]
    var help:[String]
}
