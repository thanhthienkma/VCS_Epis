//
//  Preference.swift
//  camera
//
//  Created by Nguyen Nam on 4/7/20.
//

import Foundation
class Preference: NSObject {
    private let KEY_INIT = "key_init"
    static let shared = Preference()
    
    private let defaults = UserDefaults.standard
    
    private override init() {
        super.init()
        if !getBool(KEY_INIT) {
            NSObject.initialize()
        }
    }
    // Set int value
    public func setInt(_ val:Int, forKey:String){
        defaults.set(val, forKey: forKey)
    }
    // Get int value
    public func getInt(_ forKey:String)->Int{
        return defaults.integer(forKey: forKey)
    }
    
    // Set double value
    public func setDouble(_ val:Double, forKey:String){
        defaults.set(val, forKey: forKey)
    }
    // Get double value
    public func getDouble(_ forKey:String)->Double{
        return defaults.double(forKey: forKey)
    }
    // Get bool value
    public func getBool(_ forKey: String) -> Bool {
        return defaults.bool(forKey: forKey)
    }
    // Set bool value
    public func setBool(_ val: Bool, forKey: String) {
        defaults.set(val, forKey: forKey)
    }
    // Get string value
    public func getString(_ forKey: String) -> String {
        return defaults.object(forKey: forKey) as? String ?? ""
    }
    // Set string value
    public func setString(_ val: String, forKey: String) {
        defaults.set(val, forKey: forKey)
    }
    
    // Remove value
    public func remove(forKey: String) {
        defaults.removeObject(forKey: forKey)
    }
}


