//
//  Hwi.swift
//  SampleApp
//
//  Created by Sarah Poole on 9/22/24.
//

class Hwi: Codable {
    var hw: String
    var prs: [Prs]?
    
    private enum CodingKeys: String, CodingKey {
        case hw, prs
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hw = try values.decode(String.self, forKey: .hw)
        prs = try? values.decode([Prs].self, forKey: .prs)
    }
}
