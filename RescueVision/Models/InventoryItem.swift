//MARK: - InvetoryItem
struct InventoryItem:Codable,Identifiable,Hashable {
    enum CodingKeys:String,CodingKey {
        case name,id,contains,info,properties
    }
    
    let name:String
    let id:Int
    var contains:[Sections]?
    var properties: [PropertyValues]
    var info:InfoEntry?
    
   

    
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        
        if container.contains(.contains){
        contains = try container.decode([Sections].self, forKey: .contains)
        }else{
            contains = nil
        }
        
        if container.contains(.info){
            info = try container.decode(InfoEntry.self, forKey: .info)
        }else{
            info = nil
        }
        
        //For convertion from JSON file to PropertyValue
        do {
            let propTemp = try container.decode([String:PropertyValues].self, forKey: .properties)
            properties = propTemp.map{ key, val in
                return PropertyValues(text: val.text, value: val.value, unit: val.unit)
                
            }
        } catch  {
            //for conversion from fireStore to PropertyValue
            properties = try container.decode([PropertyValues].self, forKey: .properties)
        }
      
    }


}

//MARK: - InvetoryItem
struct Sections:Codable,Hashable {
    enum CodingKeys:String, CodingKey{
        case sectionName = "section_name"
        case sectionItems = "section_items"
    }
    let sectionName:String?
    let sectionItems:[SectionItems]
}
//MARK: -SectionItems
struct SectionItems:Codable,Hashable {
    let name:String
    let amount:Int
}

//MARK: - PropertyValues
struct PropertyValues:Codable,Hashable {
    let text:String
    let value:Double
    let unit:String
}


//MARK: -InfoEntry

struct InfoEntry:Codable,Hashable {
    var warning:[String]
    var help:[String]
}
