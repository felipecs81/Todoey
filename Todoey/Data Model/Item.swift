//
//  Item.swift
//  Todoey
//
//  Created by Felipe on 20/3/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

import Foundation

class Item: Encodable,Decodable{
    
    var title : String = ""
    var done: Bool = false
    
}
