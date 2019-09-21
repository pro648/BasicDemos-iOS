//
//  QueryService.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class QueryService {

    // MARK: - Variables And Properties
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var tracks: [Track] = []

    // MARK: - Type Alias

    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Track]?, String) -> Void

    // MARK: - Internal Methods

    func getSearchResult(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()

        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"

            guard let url = urlComponents.url else {
                return
            }

            dataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                defer {
                    self?.dataTask = nil
                }

                if let error = error {
                    print("DataTask error: " + error.localizedDescription + "\n")
                    return
                }

                guard let httpURLResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpURLResponse.statusCode),
                    let mimeType = httpURLResponse.mimeType,
                    mimeType == "text/javascript" else {
                        print("Status code or mime type error \n")
                        return
                }

                if let data = data {
                    self?.updateSearchResults(data)

                    DispatchQueue.main.async {
                        completion(self?.tracks, self?.errorMessage ?? "")
                    }
                }
            })

            dataTask?.resume()
        }
    }

    // MARK: - Private Methods

    func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        tracks.removeAll()

        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }

        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }

        var index = 0

        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
                let previewURLString = trackDictionary["previewUrl"] as? String,
                let previewURL = URL(string: previewURLString),
                let name = trackDictionary["trackName"] as? String,
                let artist = trackDictionary["artistName"] as? String {
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
}
