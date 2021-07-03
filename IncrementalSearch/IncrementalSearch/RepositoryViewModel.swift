//
//  RepositoryViewModel.swift
//  IncrementalSearch
//
//  Created by Fangwei Hsu on 2021/07/02.
//

import Foundation

struct RepositoryViewModel: Codable {
    let items: [Repository]
    
    func fetchSearchResults(query: String, completionHandler: @escaping (RepositoryViewModel?, Error?) -> Void) {
        var components = URLComponents(string: "https://api.github.com/search/repositories")!
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
//            if let returnData = String(data: data!, encoding: .utf8) {
//                print(returnData)
//            }
            if let data = data,
               let repositoryViewModel = try? JSONDecoder().decode(RepositoryViewModel.self, from: data) {
                completionHandler(repositoryViewModel, nil)
            }
        })
        task.resume()
    }
}

struct Repository: Codable {
    let name: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case htmlUrl = "html_url"
    }
}
