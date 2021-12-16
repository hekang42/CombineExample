import UIKit

enum HTTPError: LocalizedError {
    case statusCode
    case post
}

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

let task = URLSession.shared.dataTask(with: url) { data, response, error in
    if let error = error {
        fatalError("Error: \(error.localizedDescription)")
    }
    
    // 상태 코드 분기
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        fatalError("Error: invalid HTTP response code")
    }
    // 데이터 분기 처리
    guard let data = data else {
        fatalError("Error: missing response data")
    }
    
    //JSON 맵핑
    do {
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        print(posts.map { $0.title })
    }
    catch {
        print("Error: \(error.localizedDescription)")
    }
}
task.resume()
