//
//  Character.swift
//  RickAndMorty
//
//  Created by Denis Khlopin on 04.05.2021.
//

import Foundation

enum Gender: String, Codable {
    case Female, Male, Genderless, unknown
}

enum CharacterStatus: String, Codable {
    case Alive, Dead, unknown

    var colorName: String {
        switch self {
        case .Alive:
            return "alive"
        case .Dead:
            return "dead"
        case .unknown:
            return "unknown"
        }
    }
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
