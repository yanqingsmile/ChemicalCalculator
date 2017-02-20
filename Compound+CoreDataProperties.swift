//
//  Compound+CoreDataProperties.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/18/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import CoreData


extension Compound {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Compound> {
        return NSFetchRequest<Compound>(entityName: "Compound");
    }

    @NSManaged public var name: String?
    @NSManaged public var formula: String?
    @NSManaged public var molecularMass: Double

}
