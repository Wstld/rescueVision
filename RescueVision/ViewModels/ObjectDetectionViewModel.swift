//
//  ObjectDetectionViewModel.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-02-03.
//

import Foundation
import Combine

final class ObjectDetectionViewModel: ObservableObject {
    //models
    var camera:CameraModel = CameraModel()
    var firebaseModel = FireBaseModel()
    
    @Published var showInfo:Bool = false
    @Published var loadingObject:Bool = false
    
    //object fowarded to view
    @Published var idObj:InventoryItem!
    
    

   
    
    
   
    //Observer fires when name of object and object found is set in CameraModel.
    var anyCancellable: AnyCancellable? = nil
    init() {
        anyCancellable = Publishers.CombineLatest(camera.$foundObject,camera.$foundObjectName).sink(receiveCompletion: {_ in }, receiveValue: { [self](combined) in
            let (foundObject,objectName) = combined
            //do network call if object is found.
            if foundObject {
                self.loadingObject = true
                 
                self.firebaseModel.fetchItemInfo(name: objectName){
                    obj in
                    
                    if obj != nil{
                        self.loadingObject = false
                        self.idObj = obj
                        self.showInfo = foundObject
                    }
                    
                    else{
                        //if object found not exists in DB, reset.
                        self.loadingObject = false
                        camera.toggleOutput()
                    }
                   
                    
                }
            }else{
                //when found object is set back to false.
                self.showInfo = foundObject
            }
        })
    }

}
