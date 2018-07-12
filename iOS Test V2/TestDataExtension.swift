//
//  TestDataExtension.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/10/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import CoreData

extension TestData {
    
    //checking if user exists if so then updates info or creates new object
    class func updateUserData ( name: String, jsonDict : [String:Any] ) -> TestData {
        if let existingData = getUser(name: name) {
            existingData.updateFromJson( jsonDict )
            return existingData
        } else {
            return TestData(jsonDict: jsonDict)
        }
    }
    
    //getting the user then returning test data if its found
    class func getUser ( name : String ) -> TestData? {
        //assiging the context
        let context = CoreDataStack.shared.persistentContainer.viewContext

        let request : NSFetchRequest<TestData> = TestData.fetchRequest()
        request.predicate = NSPredicate(format: "username = %@", name)
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                return result.first
            } else {
                print("Error fetching user data from core data")
            }
        } catch {
            print(error)
        }
        return nil
    }
    // change from cm to feet and inches for Height
    var feetInchesString : String {
        let allInches = Double(height) / 2.54
        let feet = Int(allInches / 12)
        let inches = Int(allInches) % 12
        return "\(feet)'\(inches)\""
    }
    // getting sec
    var millis : Int {
        return Int(age * 365 * 24 * 60 * 60 * 1000)
    }
    
    var millisString: String {
        return "\(millis)"
    }
    
    
    //prepare a dict for patching to the sever from what we have currently in the core data object
    var jsonDict : [String:Any] {
        
        var dict = [String:Any]()
        
        dict["likes_javascript"] = likes_javascript
        
        dict["age"] = millis
        
        dict["height"] = height
        
        return dict
    }
    // updating the user info from the json
    func updateFromJson ( _ jsonDict : [String:Any] ) {
        if let millis = jsonDict["age"] as? Int64 {
            self.age = Int64( millis / ( 365 * 24 * 60 * 60  * 1000) )
            print(self.age)
        }
        
        if let height = jsonDict["height"] as? Int32 {
            self.height = height
        }
        
        if let likes = jsonDict["likes_javascript"] as? Bool {
            self.likes_javascript = likes ? 1 : 0
        }
        
        if let name = jsonDict["username"] as? String {
            self.username = name
        }
        
        if let magicNumber = jsonDict["magic_number"] as? Int32 {
            self.magic_number = magicNumber
        }
        
        if let magicHash = jsonDict["magic_hash"] as? String {
            self.magic_hash = magicHash
        }
        
        if let uid = jsonDict["id"] as? Int64 {
            self.user_id = uid
        }
        
        try? self.managedObjectContext?.save()
        //todo: error handling
        

    }
    
    convenience init( jsonDict : [String:Any] ) {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "TestData", in: context) {
            
            self.init(entity: entity, insertInto: context)
            self.updateFromJson(jsonDict)
            
        } else {
            fatalError("Unable to find Entity Task")
        }
    }

}
