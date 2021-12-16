import Combine

var greeting = "Hello, playground"
Just(5).sink {
    print($0)
}


let provider = (1...10).publisher

provider.sink(receiveCompletion: {_ in
    print("데이터 전달 완료")
}, receiveValue: {data in
    print(data)
})

class CustomSubscribier: Subscriber {
    typealias Input = String  // 성공타입
    typealias Failure = Never // 실패타입
    
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("모든 데이터의 발행이 완료되었습니다.")
    }
    
    func receive(subscription: Subscription) {
        print("데이터의 구독을 시작합니다.")
        //구독할 데이터 개수 제한 해지
        subscription.request(.unlimited)
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("데이터를 받았습니다.", input)
        return .none
    }
}

let publisher = ["A", "B", "C", "D"].publisher
let subscriber = CustomSubscribier()

publisher.subscribe(subscriber)
