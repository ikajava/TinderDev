//
//  Developer.swift
//  TinderForDevs
//
//  Created by Ika Javakhishvili on 05/1/18.
//  Copyright © 2018 Ika Javakhishvili. All rights reserved.
//

import Foundation
import UIKit

struct Developers: Decodable {
    let dev: [Developer]
}

struct Developer: Decodable {
    var id: Int
    var name: String
    var skill: String
    var gender: String
}
