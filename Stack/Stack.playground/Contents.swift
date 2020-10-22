import UIKit

example(of: "Using a stack") {
    var stack = Stack<Int>()
    stack.push(1)
    stack.push(2)
    stack.push(3)
    stack.push(4)
    
    print(stack)
    
    if let poppedValue = stack.pop() {
        assert(4 == poppedValue)
        print("Popped: \(poppedValue)")
    }
}

example(of: "Initializing a stack from an array") {
    let array = ["A", "B", "C", "D"]
    var stack = Stack(array)
    print(stack)
    stack.pop()
}

example(of: "Initializing a stack from an array literal") {
    var stack: Stack = [1.0, 2.0, 3.0, 4.0]
    print(stack)
    stack.pop()
}

// 查看圆扣号是否匹配
func checkParentheses(_ string: String) -> Bool {
    var stack = Stack<Character>()
    
    for character in string {
        if character == "(" {
            // 遇到左括号，添加到栈。
            stack.push(character)
        } else if character == ")" {
            if stack.isEmpty {
                // 遇到右括号时，如果栈是空的，则不匹配。
                return false
            } else {
                // 不是空的，移除一个元素。
                stack.pop()
            }
        }
    }
    
    // 最终，栈是空的，就刚好匹配；否则，不匹配。
    return stack.isEmpty
}
