import Combine
import Foundation // numberFormatter을 위해 import

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
        // 구독할 데이터 개수 제한 해지
        subscription.request(.unlimited)
        // 2개만 구독 끝나지 않으면 completion 호출 안됨.
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("데이터를 받았습니다.", input)
        return .none
    }
}

let publisher = ["A", "B", "C", "D"].publisher
let subscriber = CustomSubscribier()

publisher.subscribe(subscriber)

let formatter = NumberFormatter()
formatter.numberStyle = .ordinal
(1...10).publisher.map {
    formatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
}.sink {
    print($0)
}

// PassthroughSubject Example

let subject = PassthroughSubject<String, Error>()

subject.sink(receiveCompletion: { completion in
    // 에러가 발생한 경우도 receiveCompletion 블록이 호출됩니다.
    switch completion {
    case .failure:
        print("Error가 발생하였습니다.")
    case .finished:
        print("데이터의 발행이 끝났습니다.")
    }
}, receiveValue: { value in
    print(value)
})

subject.send("A")

// CurrentValueSubject Example

let currentStatus = CurrentValueSubject<Bool, Error>(true)

currentStatus.sink(receiveCompletion: { completion in
    switch completion {
    case .failure:
        print("Error가 발생하였습니다.")
    case .finished:
        print("데이터의 발행이 끝났습니다.")
    }
}, receiveValue: { value in
    print(value)
})

print("초기값은 \(currentStatus.value)입니다.")
currentStatus.send(false)
currentStatus.value = true

let externalProvider = PassthroughSubject<String, Never>()

let anyCancleable = externalProvider.sink{ steam in
    print("전달받은 데이터 \(steam)")
}

externalProvider.send("A")
externalProvider.send("B")
externalProvider.send("C")
anyCancleable.cancel()
externalProvider.send("A")

