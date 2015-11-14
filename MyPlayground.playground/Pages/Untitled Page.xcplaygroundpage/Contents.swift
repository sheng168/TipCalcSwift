//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let string = String.localizedStringWithFormat(
    NSLocalizedString("the result is %5.2f", comment:"gives numeric result to the user"),
    12.3 )

for i in 0...100 {
    print(String.localizedStringWithFormat("%02d", i))
}

String.localizedStringWithFormat("%05.0F+%.0f%% = %.2f", 10.0, (0.151*100), 11.15)
//: [Next](@next)
