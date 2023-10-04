// 详细介绍：https://github.com/pro648/tips/blob/master/sources/@autoclosure%E7%9A%84%E4%BD%BF%E7%94%A8.md

import Foundation

// 直接调用
/*
func goodMorning(morning: Bool, whom: String) {
    if morning {
        print("Good Morning, \(whom)")
    }
}

//goodMorning(morning: true, whom: "Pavel")
//goodMorning(morning: false, whom: "John")

func giveAname() -> String {
    print("giveAname() is called")
    return "Robert"
}

goodMorning(morning: true, whom: giveAname())
goodMorning(morning: false, whom: giveAname())
 */

// 闭包
/*
func goodMorning(morning: Bool, whom: () -> String) {
    if morning {
        print("Good morning, \(whom())")
    }
}

func giveAname() -> String {
    print("giveAname() is called")
    return "Robert"
}

goodMorning(morning: false, whom: giveAname)
 */

// 自动闭包

func goodMorning(morning: Bool, whom: @autoclosure () -> String) {
    if morning {
        print("Good morning, \(whom())")
    }
}

func giveAname() -> String {
    print("giveAname() is called")
    return "Robert"
}

goodMorning(morning: true, whom: giveAname())
goodMorning(morning: false, whom: giveAname())
goodMorning(morning: true, whom: "Pavel")
goodMorning(morning: false, whom: "Jhon")
