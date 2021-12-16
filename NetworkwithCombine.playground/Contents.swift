import Foundation
import Combine

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

let cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .map{ $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())
    .replaceError(with: [])
    .eraseToAnyPublisher()
    .sink(receiveValue: { posts in
        print("전달받은 데이터는 총 \(posts.count)개 입니다.")
    })
