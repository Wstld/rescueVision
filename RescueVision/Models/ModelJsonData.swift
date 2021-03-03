//
//  ModelJsonData.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-28.
//

import Foundation
import Combine
//generic JSON to Swift obj model.
final class ModelJsonData:ObservableObject {
        @Published var invetoryList:[InventoryItem] = load("core.json")
    }
   
    func load <T:Decodable>(_ filename:String) -> T {
        let data:Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            fatalError("json file: \(filename) doesn't exist")
        }
        do {
            data = try Data(contentsOf: file)
        }catch{
            fatalError("could not load data:\(error)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError("Coudnt parse the file to \(T.self) because \(error)")
        }
    }
