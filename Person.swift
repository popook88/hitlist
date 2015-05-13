//
//  Person.swift
//  HitList
//
//  Created by Kevin Kane on 5/12/15.
//  Copyright (c) 2015 KevinKane. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var date: NSDate
    
    func fullName() -> String {
        return self.name
    }

}
