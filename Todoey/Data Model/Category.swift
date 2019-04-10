//
//  Category.swift
//  Todoey
//
//  Created by Felipe on 5/4/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
