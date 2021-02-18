//
//  FireBaseModel.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-02-10.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct FireBaseModel {
    var db = Firestore.firestore()
    var identifiableObjects:CollectionReference{
        return db.collection("identifiableObjects")
    }
   

    
    func fetchItemInfo(name:String,completion: @escaping (_ retrivedObject:InventoryItem) -> Void){
        
//        let document = identifiableObjects.document("\(name.lowercased())")
        let document = identifiableObjects.document("släckbil 1310")
        document.getDocument{(doc, error) in
            let result = Result {
                try doc?.data(as: InventoryItem.self)
            }
            switch result{
            
            case .success(let foundObject):
                if let foundObject = foundObject{
                    completion(foundObject)
                }else{
                    print("didnt find object in database")
                }
            case .failure(let error):
                print("error decoding: \(error)")
            }
        }
        
  
        
  
        
    }
    
    func uploadJSONtoFireBase(objects:[InventoryItem]){
        objects.forEach{ obj in
            do{
                try identifiableObjects.document("\(obj.name.lowercased())").setData(from: obj)
            }catch{
                print(error)
            }
        }
    }
}

