//  RequestManager.swift

import Foundation

let Req = RequestManager.sharedInstance

final class RequestManager {
    static let sharedInstance = RequestManager()
    
    let baseURLString = "https://reddit.com"
    let topPathString = "/top.json"
    
    func limitQuery(_ limit: Int) -> String {
        return "?limit=\(limit)"
    }
    
    func request(urlString: String, limit: Int = 50) -> URLRequest? {
        let path = urlString + limitQuery(limit)
        guard let url = URL(string: path) else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func requestJSON(completion: @escaping (([Children]) -> Void)) {
        let urlString = baseURLString + topPathString
        guard let request = self.request(urlString: urlString, limit: 50) else { return }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let thing = try decoder.decode(Thing.self, from: data)
                    guard let listing = thing.data else { return }
                    completion(listing.children)
                } catch let error {
                    print(error)
                    return
                }
            }
        }.resume()
    }
}
