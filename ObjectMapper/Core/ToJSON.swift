//
//  ToJSON.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2014-10-13.
//  Copyright (c) 2014 hearst. All rights reserved.
//

import Foundation

class ToJSON {
	
    func basicType<N>(field: N, key: String, inout dictionary: [String : AnyObject]) {
		var temp = dictionary
		var currentKey = key
		
		if let field: AnyObject = validJSON(field) {
			dictionary[currentKey] = field
		}
    }
	
	/// If `field` argument is valid as JSON, returns itself. Otherwise returns nil.
	func validJSON<N>(field: N) -> AnyObject? {
        switch field {
        // basic Types
        case let x as Bool:
			return x
        case let x as Int:
			return x
        case let x as Double:
			return x
        case let x as Float:
			return x
        case let x as String:
			return x

        // Arrays with basic types
		case let array as Array<AnyObject>:
			for val in array {
				if validJSON(val) == nil {
					return nil
				}
			}
			return array
			
        // Dictionaries with basic types
		case let dictionary as Dictionary<String, AnyObject>:
			for (key, val) in dictionary {
				if validJSON(val) == nil {
					return nil
				}
			}
			return dictionary
			
        default:
            //println("Default")
            return nil
		}
	}

    func optionalBasicType<N>(field: N?, key: String, inout dictionary: [String : AnyObject]) {
        if let field = field {
            basicType(field, key: key, dictionary: &dictionary)
        }
    }
    
    func basicArray(field: Array<AnyObject>, key: String, inout dictionary: [String : AnyObject]){
        dictionary[key] = field
    }
    
    func optionalBasicArray(field: Array<AnyObject>?, key: String, inout dictionary: [String : AnyObject]){
        if let value = field {
            basicArray(value, key: key, dictionary: &dictionary)
        }
    }
    
    func basicDictionary(field: Dictionary<String, AnyObject>, key: String, inout dictionary: [String : AnyObject]){
        dictionary[key] = field
    }
    
    func optionalBasicDictionary(field: Dictionary<String, AnyObject>?, key: String, inout dictionary: [String : AnyObject]){
        if let value = field {
            basicDictionary(value, key: key, dictionary: &dictionary)
        }
    }
    
    func object<N: Mappable>(field: N, key: String, inout dictionary: [String : AnyObject]) {
        dictionary[key] = Mapper().toJSON(field)
    }
    
    func optionalObject<N: Mappable>(field: N?, key: String, inout dictionary: [String : AnyObject]) {
        if let field = field {
            object(field, key: key, dictionary: &dictionary)
        }
    }
    
    func objectArray<N: Mappable>(field: Array<N>, key: String, inout dictionary: [String : AnyObject]) {
		let JSONObjects = Mapper().toJSONArray(field)

		if !JSONObjects.isEmpty {
            dictionary[key] = JSONObjects
        }
    }
    
    func optionalObjectArray<N: Mappable>(field: Array<N>?, key: String, inout dictionary: [String : AnyObject]) {
        if let field = field {
            objectArray(field, key: key, dictionary: &dictionary)
        }
    }
    
    func objectDictionary<N: Mappable>(field: Dictionary<String, N>, key: String, inout dictionary: [String : AnyObject]) {
		let JSONObjects = Mapper().toJSONDictionary(field)

		if !JSONObjects.isEmpty {
			dictionary[key] = JSONObjects
		}
    }
    
    func optionalObjectDictionary<N: Mappable>(field: Dictionary<String, N>?, key: String, inout dictionary: [String : AnyObject]) {
        if let field = field {
            objectDictionary(field, key: key, dictionary: &dictionary)
        }
    }
}
