//
//  DataController.swift
//  FoodTracker
//
//  Created by Andy Stannard on 15/04/2015.
//  Copyright (c) 2015 inni Accounts. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController{
    
    class func jsonAsUSDIdAndNameFromSearchResults(json: NSDictionary) -> [(name: String, idValue: String)]{
        var usdaItemsSearchResults:[(name:String, idValue: String)] = []
        var searchResult:(name: String, idValue: String)
        
        

        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    if itemDictionary["fields"] != nil {
                        let fieldsDictionary = itemDictionary["fields"] as NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            let idValue:String = itemDictionary["_id"]! as String
                            let name:String = fieldsDictionary["item_name"]! as String
                            searchResult = (name : name, idValue : idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        return usdaItemsSearchResults
        
    }
    
    func saveUSDItemForID( idValue: String,  json: NSDictionary){
        
        
        if( json["hits"] != nil){
            let results:[AnyObject] = json["hits"]! as [AnyObject]

            for itemDictionary in results {
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue {
                    
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
                    var requestForUSDItem = NSFetchRequest(entityName: "USDItem")
                    let itemDictionaryId = itemDictionary["_id"]! as String
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    requestForUSDItem.predicate = predicate
                    var error: NSError?
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDItem, error: &error)
                    
                    if items?.count != 0 {
                        //items already saved
                        println("already saved")
                        
                        return
                    }else{
                        println("lets save it")
                        let entityDescription = NSEntityDescription.entityForName("USDItem", inManagedObjectContext: managedObjectContext!)
                        let usdaItem = USDItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                        usdaItem.idValue  = itemDictionary["_id"]! as String
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil {
                            let fieldDictionary = itemDictionary["fields"] as NSDictionary
                            
                            if fieldDictionary["item_name"] != nil {
                                
                                usdaItem.name = fieldDictionary["item_name"]! as String
                                
                            }
                            
                            // USDA fields
                            if fieldDictionary["usda_fields"] != nil {
                                let usdaFieldsDictionary = fieldDictionary["usda_fields"]! as NSDictionary
                                
                                if usdaFieldsDictionary["CA"] != nil {
                                    
                                    let calciumDictionary = usdaFieldsDictionary["CA"]! as NSDictionary
                                    let calciumValue: AnyObject = calciumDictionary["value"]!
                                    usdaItem.calcium = "\(calciumValue)"
                                }
                                else{
                                    usdaItem.calcium = "0"
                                }
                                
                                
                                if usdaFieldsDictionary["CHOCDF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"]! as NSDictionary
                                    if carbohydrateDictionary["value"] != nil {
                                        let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!
                                        usdaItem.carbohydrate = "\(carbohydrateValue)"
                                    }
                                }
                                else {
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                
                                // Cholesterol Grouping (optional to add this comment)
                                if usdaFieldsDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as NSDictionary
                                    if cholesterolDictionary["value"] != nil {
                                        let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
                                        usdaItem.cholesterol = "\(cholesterolValue)"
                                    }
                                }
                                else {
                                    usdaItem.cholesterol = "0"
                                }
                                // Protein Grouping (optional to add this comment)
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as NSDictionary
                                    if proteinDictionary["value"] != nil {
                                        let proteinValue: AnyObject = proteinDictionary["value"]!
                                        usdaItem.protein = "\(proteinValue)"
                                    }
                                }
                                else {
                                    usdaItem.protein = "0"
                                }
                                
                                // Sugar Total
                                if usdaFieldsDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as NSDictionary
                                    if sugarDictionary["value"] != nil {
                                        let sugarValue:AnyObject = sugarDictionary["value"]!
                                        usdaItem.sugar = "\(sugarValue)"
                                    }
                                }
                                else {
                                    usdaItem.sugar = "0"
                                }
                                // Vitamin C
                                if usdaFieldsDictionary["VITC"] != nil {
                                    let vitaminCDictionary = usdaFieldsDictionary["VITC"]! as NSDictionary
                                    if vitaminCDictionary["value"] != nil {
                                        let vitaminCValue: AnyObject = vitaminCDictionary["value"]!
                                        usdaItem.vitaminC = "\(vitaminCValue)"
                                    }
                                }
                                else {
                                    usdaItem.vitaminC = "0"
                                }
                                // Energy
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as NSDictionary
                                    if energyDictionary["value"] != nil {
                                        let energyValue: AnyObject = energyDictionary["value"]!
                                        usdaItem.energy = "\(energyValue)"
                                    }
                                }
                                else {
                                    usdaItem.energy = "0"
                                }
                                
                                (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
                                
                            }

                            
                            //END USDA Fields
                            
                        }
                    }
                    
                }
                
            }// end itemDictionary For
            
        }//End hits if
    }
    
}