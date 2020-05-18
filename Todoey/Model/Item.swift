//
//  Item.swift
//  Todoey
//
//  Created by Madhavi Mummadireddy on 5/18/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item : Object {
    @objc dynamic var title :  String = ""
    @objc dynamic var done : Bool = false
}
