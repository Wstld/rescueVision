//
//  ObjectDetectionViewModel.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-02-03.
//

import Foundation
import Combine

final class ObjectDetectionViewModel: ObservableObject {
    var camera:CameraModel = CameraModel()
    @Published var showInfo:Bool = false
    @Published var idObj:InventoryItem!
    @Published var loadingObject:Bool = false

   
    var firebaseModel = FireBaseModel()
    
   
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
                    self.loadingObject = false
                    self.idObj = obj
                    self.showInfo = foundObject
                }
            }else{
                //when found object is set back to false.
                self.showInfo = foundObject
            }
        })
    }

}
