import Combine

var greeting = "Hello, playground"
Just(5).sink {
    print($0)
}
