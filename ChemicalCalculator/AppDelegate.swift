//
//  AppDelegate.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/17/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel
import GoogleMobileAds
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    


    var window: UIWindow?
    
    var compoundCount: Int {
        get {
            let context = persistentContainer.viewContext
            var count: Int?
            context.performAndWait {
                count = try? context.count(for: NSFetchRequest(entityName: "Compound"))
            }
            return count ?? 0
        }
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if compoundCount == 0 {
            loadIntoDatabase()
        }
        //window?.tintColor = UIColor(red: 251/255.0, green: 248/255.0, blue: 243/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UISegmentedControl.appearance().tintColor = UIColor.warmOrange()
        UISegmentedControl.appearance().backgroundColor = UIColor.grayWhite()
        UISearchBar.appearance().backgroundColor = UIColor.warmOrange()
        UISearchBar.appearance().barTintColor = UIColor.grayWhite()
        UISearchBar.appearance().tintColor = UIColor.warmOrange()
        
        //Initialize mixpanel library
        Mixpanel.initialize(token: "1ee2dcdd71bcb235b3c3bd940d2e5e74")
        

        Mixpanel.mainInstance().track(event: "App Open")
        
        // Initialize Google Mobile Ads SDK
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3264388918879738~9937229008")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ChemicalCalculator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - preload database

    private func readPlistData() -> NSArray? {
        if let path = Bundle.main.path(forResource: "compound", ofType: "plist") {
            return NSArray(contentsOfFile: path)
        }
        return nil
    }
    
    private func loadIntoDatabase() {
        let context = persistentContainer.viewContext
        context.performAndWait {
            if let data = self.readPlistData() {
                for compoundInfo in data {
                    _ = Compound.compoundWithCompoundInfo(compoundInfo: compoundInfo as! Dictionary<String, Any>, inManagedObjectContext: context)
                }
                self.saveContext()
            }
        }
        print ("\(compoundCount) compounds" )
    }
    
    
}

