import UIKit
//MARK: 1 задание
class Shape {
    let color: String
    
    init(color: String) {
        self.color = color
    }
    
    func calculateSquare() -> Double {
        return 0.0
    }
}

class Circle: Shape {
    let radius: Double
    
    init(color: String, radius: Double) {
        self.radius = radius
        super.init(color: color)
    }
    
    override func calculateSquare() -> Double {
        return Double.pi * radius * radius
    }
}

class Rectangle: Shape {
    let length: Double
    let width: Double
    
    init(color: String, length: Double, width: Double) {
        self.length = length
        self.width = width
        super.init(color: color)
    }
    
    override func calculateSquare() -> Double {
        return length * width
    }
}

class Triangle: Shape {
    let base: Double
    let height: Double
    
    init(color: String, base: Double, height: Double) {
        self.base = base
        self.height = height
        super.init(color: color)
    }
    
    override func calculateSquare() -> Double {
        return (base * height) / 2
    }
}

let circle = Circle(color: "Green", radius: 7.0)
let rectangle = Rectangle(color: "Red", length: 10.0, width: 4.0)
let triangle = Triangle(color: "Yelow", base: 2.0, height: 8.0)

let shapes: [Shape] = [circle, rectangle, triangle]

for shape in shapes {
    print("Color: \(shape.color), Square: \(shape.calculateSquare())")
}

//MARK: 2 задание

struct Contact {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String?
}
    
    func searchContacts(from contacts: [Contact], by searchText: String) -> [Contact] {
        let lowercasedSearch = searchText.lowercased()
        
        return contacts.filter { contact in
            contact.firstName.lowercased().contains(lowercasedSearch) || contact.lastName.lowercased().contains(lowercasedSearch)
        }
    }


let contacts = [Contact(firstName: "Александр", lastName: "Подалов", phoneNumber: "+375447689943", email: nil), Contact(firstName: "Мария", lastName: "Яковцева", phoneNumber: "+375293678809", email: "maria98@mail.ru"), Contact(firstName: "Александра", lastName: "Ярош", phoneNumber: "+375446868897", email: nil)]

let result = searchContacts(from: contacts, by: "Александр")

for contact in result {
    print("\(contact.firstName) \(contact.lastName) - \(contact.phoneNumber)")
}
