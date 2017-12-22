//
//  Helpers.swift
//  SwiftThanks
//
//  Created by Jimmy McDermott on 12/22/17.
//

import Foundation
import Console

struct Helpers {
    
    static func getOauthToken() throws -> String {
        guard let folderPath = createThanksFolderIfNotPresent() else {
            throw TerminalError.cannotCreateThanksFolder
        }
        
        let oauthTextPath = folderPath + "/oauth.txt"
        
        if FileManager().fileExists(atPath: oauthTextPath) {
            guard let dataContents = FileManager().contents(atPath: oauthTextPath) else {
                throw TerminalError.cannotLoadAuthFile
            }
            
            return dataContents.makeString()
        } else {
            FileManager().createFile(atPath: oauthTextPath, contents: nil, attributes: nil)
            return ""
        }
    }
    
    static func setOAuthToken(token: String) throws {
        guard let folderPath = createThanksFolderIfNotPresent() else {
            throw TerminalError.cannotCreateThanksFolder
        }
        
        let oauthTextPath = folderPath + "/oauth.txt"
        
        FileManager().createFile(atPath: oauthTextPath,
                                 contents: token.data(using: .utf8),
                                 attributes: nil)
    }
    
    private static func createThanksFolderIfNotPresent() -> String? {
        do {
            if #available(OSX 10.12, *) {
                let homeDirectory = FileManager().homeDirectoryForCurrentUser
                let pathToThanksFolder = homeDirectory.relativePath + "/.swift-thanks"
                
                if !FileManager().fileExists(atPath: pathToThanksFolder) {
                    try FileManager().createDirectory(atPath: pathToThanksFolder,
                                                      withIntermediateDirectories: false,
                                                      attributes: nil)
                }
                
                return pathToThanksFolder
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    static func star(terminal: Terminal, repo: ResolvedPackage.Pin) throws -> Bool {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let relativeUrl = repo.relativeUrl else {
            return false
        }
        
        let urlString = "https://api.github.com/user/starred/\(relativeUrl)"
        guard let URL = URL(string: urlString) else {
            return false
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "PUT"
        
        let headerAuthValue = "token \(try getOauthToken())"
        request.addValue(headerAuthValue, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request)
        task.resume()
        
        if task.error == nil {
            return true
        }
        
        return false
    }
}
