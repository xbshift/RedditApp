//  RequestService.swift

import Foundation

final class RequestService {
    static let sharedInstance = RequestService()
    
    let baseURLString = "https://reddit.com"
    let topPathString = "/top.json"
    
    func query(limit: Int, pagingAfter: String?) -> String {
        if let after = pagingAfter {
            return "?after=\(after)&limit=\(limit)"
        } else {
            return "?limit=\(limit)"
        }
    }
    
    func request(urlString: String, pagingAfter: String?, limit: Int) -> URLRequest? {
        let path = urlString + query(limit: limit, pagingAfter: pagingAfter)
        guard let url = URL(string: path) else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func requestJSON(limit: Int, pagingAfter: String? = nil, completion: @escaping ((Listing) -> Void)) {
        let urlString = baseURLString + topPathString
        
        guard let request = self.request(urlString: urlString, pagingAfter: pagingAfter, limit: limit) else { return }
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
                    completion(listing)
                } catch let error {
                    print(error)
                    return
                }
            }
        }.resume()
    }
}
