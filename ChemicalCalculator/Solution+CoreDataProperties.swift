//
//  Solution+CoreDataProperties.swift
//  
//
//  Created by Vivian Liu on 4/26/17.
//
//

import Foundation
import CoreData


extension Solution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Solution> {
        return NSFetchRequest<Solution>(entityName: "Solution")
    }

    @NSManaged public var concentrationUnit: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var finalConcentration: Double
    @NSManaged public var finalVolume: Double
    @NSManaged public var massUnit: String?
    @NSManaged public var soluteMass: Double
    @NSManaged public var volumeUnit: String?
    @NSManaged public var isDiluted: Bool
    @NSManaged public var stockConcentration: String?
    @NSManaged public var stockNeededVolume: Double
    @NSManaged public var stockNeededVolumeUnit: String?
    @NSManaged public var groups: NSSet?
    @NSManaged public var solute: Compound?

}

// MARK: Generated accessors for groups
extension Solution {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}
