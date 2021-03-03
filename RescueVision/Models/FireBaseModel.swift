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
    private let db = Firestore.firestore()
    var identifiableObjects:CollectionReference{
        return db.collection("identifiableObjects")
    }
    
    //fetch with completion handler.
    func fetchItemInfo(name:String,completion: @escaping (_ retrivedObject:InventoryItem?) -> Void){
        let document = identifiableObjects.document("\(name)")
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
                    completion(nil)
                }
            case .failure(let error):
                print("error decoding: \(error)")
                completion(nil)
            }
        }
    }
    
    //helper function, not used in app.
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

