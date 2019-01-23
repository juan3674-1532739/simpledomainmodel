//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    public var exchange : [String : [String : Double]]
    
    init (amount : Int, currency : String) {
        self.amount = amount
        self.currency = currency
        self.exchange = [
            "USD": ["GBP": 0.5, "EUR": 1.5, "CAN": 1.25],
            "GBP": ["USD": 2.0, "EUR": 3.0, "CAN" : 2.5],
            "EUR": ["USD": 0.67, "GBP": 0.34, "CAN": 8.4],
            "CAN": ["USD": 0.8, "EUR": 1.2, "GBP": 0.4]
        ]
    }
    public func convert(_ to: String) -> Money {
        return Money(amount : Int(Double(self.amount) * self.exchange[self.currency]![to]!), currency : to)
    }
    
    public func add(_ to: Money) -> Money {
        if to.currency == self.currency {
            return Money(amount: self.amount + to.amount, currency: to.currency)
        }
        let converted : Money = convert(to.currency)
        return Money(amount: converted.amount + to.amount, currency: to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        if from.currency == self.currency {
            return Money(amount: from.amount - self.amount, currency: from.currency)
        }
        let converted : Money = convert(from.currency)
        return Money(amount: from.amount - converted.amount, currency: from.currency)
    }
}
//
//////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let rate):
            return Int(rate * Double(hours))
        case .Salary(let rate):
            return rate
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let rate):
            self.type = JobType.Hourly(rate + amt)
        case .Salary(let rate):
            self.type = JobType.Salary(Int((Double(rate) + amt)))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {return _job }
        set(value) {
            if self.age <= 15 {
                _job = nil
            } else {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {return _spouse }
        set(value) {
            if self.age <= 15 {
                _spouse = nil
            } else {
                _spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job?.type)) spouse:\(String(describing: self.spouse?.firstName))]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for mem in self.members {
            if mem.age >= 21 {
                self.members.append(child)
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var result : Int = 0
        for mem in self.members {
            if mem.job != nil {
                result += mem.job!.calculateIncome(2000)
            }
        }
        return result
    }
}



