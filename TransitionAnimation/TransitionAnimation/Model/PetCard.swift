//
//  PetCard.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/25.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

struct PetCard: Decodable {
    let name: String
    let description: String
    let image: UIImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        let imageName = try container.decode(String.self, forKey: .image)
        image = UIImage(named: imageName)!
    }
}
