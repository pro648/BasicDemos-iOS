//
//  PetCardStore.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/25.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

struct PetCardStore {
    static let defaultPets: [PetCard] = {
        return parsePets()
    }()
    
    private static func parsePets() -> [PetCard] {
        guard let fileUrl = Bundle.main.url(forResource: "Pets", withExtension: "plist") else { return [] }
        do {
            let petData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let pets = try PropertyListDecoder().decode([PetCard].self, from: petData)
            return pets
        } catch {
            print(error)
            return []
        }
    }
}
