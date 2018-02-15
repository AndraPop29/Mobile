//
//  TouristAttractions.swift
//  explore-ios
//
//  Created by Andra Pop on 2017-11-13.
//  Copyright © 2017 andrapop. All rights reserved.
//

import Foundation
import os.log
import FirebaseDatabase
import PromiseKit
import FirebaseStorage

class TouristAttractions {
    var attractionsList = [TouristAttraction]()
    static let shared = TouristAttractions()
    let ref = Database.database().reference()
    private init(){}
    func getCountries() -> [String] {
        return Array(Set(attractionsList.map {$0.country}));
    }
    func getAttractions(fromCountry country: String) -> [TouristAttraction] {
        return attractionsList.filter ({ return $0.country == country})
    }
    func updateAttraction(withId id: String, attraction: TouristAttraction) {
        let databaseRef = Database.database().reference(withPath: "touristAttractions/")
        databaseRef.updateChildValues([id : attraction.toAnyObject()])
    }
    func uploadImageFor(_ attraction: TouristAttraction, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // storage/carImages/image.jpg
        let imageName = attraction.name
        let imagesReference = storageReference.child("attractionsImages").child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(attraction.image!, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
    }
    func addAttraction(attraction: TouristAttraction) {
 
        uploadImageFor(attraction, progressBlock: { (percentage) in
            
        }, completionBlock: { (fileURL, errorMessage) in
            let key = self.ref.child("touristAttractions").childByAutoId().key
            attraction.Id = key
            if let url = fileURL {
                attraction.imageURL = url
            }
            let databaseRef = Database.database().reference(withPath: "touristAttractions")
            
            let touristAttrRef = databaseRef.child(String(describing: attraction.Id!))
            touristAttrRef.setValue(attraction.toAnyObject())
            
            
        })
    }
    func saveAttractions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(attractionsList, toFile:TouristAttraction.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Attractions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save attractions...", log: OSLog.default, type: .error)
        }
    }
    func loadAttractionsFromFirebase() -> Promise<[TouristAttraction]>{
        return Promise { fulfill, reject in
            ref.child("touristAttractions").observeSingleEvent(of: .value, with: { (snapshot) in
                var newItems: [TouristAttraction] = []
                for item in snapshot.children {
                    let attr = TouristAttraction(snapshot: item as! DataSnapshot)
                    newItems.append(attr)
                }
                fulfill(newItems)
                self.attractionsList = newItems
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
       
    }
    
    func loadAttractions() -> [TouristAttraction]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TouristAttraction.ArchiveURL.path) as? [TouristAttraction]
    }
    
    func getTop5Attractions() -> Array<TouristAttraction> {
        let sortedAttractions = attractionsList.sorted(by: {lhs, rhs in
            return lhs.ratingAverage > rhs.ratingAverage
        })
        if(sortedAttractions.count <= 5) {
            return Array(sortedAttractions.prefix(sortedAttractions.count)).filter({$0.ratingAverage != 0})
        } else {
            return Array(sortedAttractions.prefix(5)).filter({$0.ratingAverage != 0})
        }
        
    }
    func remove(attraction: TouristAttraction) {
        attraction.ref?.removeValue()
    }
    func removeBy(id: String) {
        var i = 0
        while(i<attractionsList.count) {
            if attractionsList[i].Id == id {
                attractionsList.remove(at: i)
            }
            i = i+1
        }
    }
    func getAttr(withId id: String) -> TouristAttraction {
        return attractionsList.filter { $0.Id! == id }.first!
    }
    func rateAttraction(withId id: String, with rating: Double) {
        if let i = attractionsList.index(where: { $0.Id == id}) {
            attractionsList[i].rateTouristAttraction(number: rating)
            ref.child("touristAttractions").child(id).setValue(attractionsList[i].toAnyObject())
        }
    }
    func rateAttraction(named name: String, with rating: Double) {
        if let i = attractionsList.index(where: { $0.name ==  name}) {
            attractionsList[i].rateTouristAttraction(number: rating)
        }
    }
}
