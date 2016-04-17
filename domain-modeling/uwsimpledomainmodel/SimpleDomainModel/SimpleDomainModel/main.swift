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

public class TestMe {
    public func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// CustomStringConvertible
//
protocol CustomStringConvertible {
    // Human readable representation
    var description : String { get set }
}

////////////////////////////////////
// Mathematics
//
protocol Mathematics {
    func + (left: Money, right: Money) -> Money
    func - (left: Money, right: Money) -> Money
}


////////////////////////////////////
// Money
//
public struct Money : CustomStringConvertible, Mathematics{
    public var amount : Int
    public var currency : String
    
    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
        self._description = "\(self.currency)\(self.amount)"
    }
    
    // Human readable format
    private var _description: String
    public var description: String {
        get{
            return _description
        }
        set(value){
            _description = value
        }
    }
    
    // Convert to the currency passed in
    public func convert(to: String) -> Money {
        // Check for same currency
        if self.currency == to {
            return self
        }
        
        // Convert to USD
        var usdCurrency = 0
        switch self.currency {
        case "USD": usdCurrency = self.amount
        case "GBP": usdCurrency = Int(2 * Double(self.amount))
        case "EUR": usdCurrency = Int(2.0/3 * Double(self.amount))
        case "CAN": usdCurrency = Int(0.8 * Double(self.amount))
        default: usdCurrency = -1
        }
        
        var finalAmount = 0
        // Convert to new currency
        switch to {
        case "USD": finalAmount = usdCurrency
        case "GBP": finalAmount = Int(0.5 * Double(usdCurrency))
        case "EUR": finalAmount = Int(1.5 * Double(usdCurrency))
        case "CAN": finalAmount = Int(1.25 * Double(usdCurrency))
        default: finalAmount = -1
        }
        return Money(amount: finalAmount, currency: to)
    }
    
    // Returns the sum in the currency of the money passed in
    public func add(to: Money) -> Money {
        return Money(amount: to.amount + self.convert(to.currency).amount, currency: to.currency)
    }
    public func subtract(from: Money) -> Money {
        return Money(amount:  self.convert(from.currency).amount - from.amount, currency: from.currency)
    }
}

// Functions in Mathematics protocol for Money
func +(left: Money, right: Money) -> Money {
    return left.add(right)
}

func - (left: Money, right: Money) -> Money {
    return left.subtract(right)
}


////////////////////////////////////
// Job
//
public class Job: CustomStringConvertible {
    public var title: String
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    public var income: JobType
    
    public init(title: String, income: JobType) {
        self.title = title
        self.income = income
        switch income {
        case .Hourly(let rate): self._description = "The person is  a \(title) and earns \(rate) per hour"
        case .Salary(let salary): self._description = "The person is  a \(title) and earns a salary of \(salary)"
        }
    }
    
    // Human readable format
    private var _description: String
    public var description: String {
        get{
            return _description
        }
        set(value){
            _description = value
        }
    }

    
    public init(title : String, type : JobType) {
        self.title = title
        self.income = type
    }
    
    public func calculateIncome(hours: Int) -> Int {
        // Check hourly vs. salary
        switch income {
        case .Hourly(let rate): return Int(rate * Double(hours))
        case .Salary(let salary): return salary
        }
    }
    
    public func raise(amt : Double) {
        // Check hourly vs. salary
        
        switch income {
        case .Hourly(let rate): income = JobType.Hourly(rate + amt)
        case .Salary(let salary): income = JobType.Salary(salary + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person: CustomStringConvertible {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    
    private var _job : Job? = nil
    public var job : Job? {
        get {
            if age < 16 {
                return nil
            } else {
                return self._job
            }
        }
        set(value) {
            if age < 16 {
                self._job = nil
            } else {
                self._job = value
            }
        }
    }
    
    private var _spouse : Person? = nil
    public var spouse : Person? {
        get {
            if age < 18 {
                return nil
            } else {
                return self._spouse
            }
        }
        set(value) {
            if age < 18 {
                self._spouse = nil
            } else {
                self._spouse = value
            }
        }
    }
    
    // Human readable format
    private var _description: String
    public var description: String {
        get{
            return _description
        }
        set(value){
            _description = value
        }
    }

    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        _description = toString()
    }
    
    // Human readable format from model #1
    public func toString() -> String {
        var summary: String = ""
        summary = "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
        return summary
    }
}

////////////////////////////////////
// Family
//
public class Family: CustomStringConvertible {
    private var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = nil
        spouse2.spouse = nil
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
    
    public func haveChild(child: Person) -> Bool {
        for person in members {
            if (person.age > 21) {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    public func householdIncome() -> Int {
        var income: Int = 0
        for person in members {
            // Add only if the person has a job
            if person.job != nil {
                switch person.job!.income {
                case .Salary ( _): income += person.job!.calculateIncome(2000)
                case .Hourly ( _): income += (person.job!.calculateIncome(2000))
                }
            }
        }
        return income
    }
}





