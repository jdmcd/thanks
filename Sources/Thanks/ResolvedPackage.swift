//
//  ResolvedPackage.swift
//  SwiftThanks
//
//  Created by Jimmy McDermott on 12/22/17.
//

import Foundation

struct ResolvedPackage: Codable {
    var object: PackageObject
    var version: Int
    
    struct PackageObject: Codable {
        var pins: [Pin]
    }
    
    struct Pin: Codable {
        var package: String
        var repositoryURL: String
        
        var relativeUrl: String? {
            guard let repoUrl = URL(string: repositoryURL) else {
                return nil
            }
            
            let components = repoUrl.pathComponents
            return (components[1] + "/" + components[2]).replacingOccurrences(of: ".git", with: "")
        }
    }
}
