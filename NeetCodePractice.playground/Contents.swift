import UIKit

// Given an integer array nums, return true if any value appears at least twice in the array, and return false if every element is distinct.


class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var duplicateValue: Bool = false
        var numSet = Set<Int>()
        for num in nums {
            let isInserted = numSet.insert(num).inserted
            if !isInserted {
                duplicateValue = true
            }
        }
        return duplicateValue
    }
}

Solution().containsDuplicate([1, 2, 3, 1])


// Given an integer x, return true if x is a palindrome, and false otherwise.

func isPalindrome(_ x: Int) -> Bool {
    var reverseNumber = 0
    var number = x
    while (number != 0) {
        let lastDigit = number % 10
        reverseNumber = reverseNumber * 10 + lastDigit
        number /= 10
    }
    return reverseNumber == x
}

isPalindrome(1211)

// 123 % 10 == 3, 123 / 10 = 12
// 12 % 10 == 2, 12 / 10 = 1
// 1 % 10 == 1,

class Solution1 {
    func isPalindrome(_ x: Int) -> Bool {
        guard x > 0 else { return false }
        var reverseNumber = 0
        var number = x
        while (number != 0) {
            let lastDigit = number % 10
            reverseNumber = reverseNumber * 10 + lastDigit
            number /= 10
        }
        return reverseNumber == x
    }
}
