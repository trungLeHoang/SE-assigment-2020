//
//  data.swift
//  SFCS
//
//  Created by Đặng Nhật Quân on 7/1/20.
//  Copyright © 2020 Đặng Nhật Quân. All rights reserved.
//

import Foundation


var currentOrderID = UserDefaults.standard.integer(forKey: "currentnOrder")
var nTotal = 0
var haveOrder = UserDefaults.standard.bool(forKey: "haveOrder")
var OrderID = 0
var nOrder = 0
var userEmail = ""
var checkOutID = 0
var paymentType = "Cash"
var status = ""

var tPickUp = Date()

var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeStyle = .short

    return formatter
}


struct Type : Identifiable,Hashable{
        var id : Int
          var name : String
          var cName : String
          var price : NSNumber
          var image : String
}

struct TypeCatogory: Identifiable {
    
    var id : String
    var name : String
    var cName : String
    var price : String
    var image : String
}

struct cart : Identifiable {
    
    var id : String
    var name : String
    var quantity : NSNumber
    var pic : String
    var price: NSNumber
   
    
}

var  data = [
    Type(id: 0, name: "White Rice", cName: "meal", price: 20000,image: "rice"),
    Type(id: 1, name: "Fired Potatoe", cName: "extra", price: 20000,image: "friedpotato"),
    Type(id: 2, name: "France Flan", cName: "dessert", price: 25000,image: "dessert"),
    Type(id: 3, name: "Fresh Milk", cName: "drink", price: 20000,image: "milk"),
    Type(id: 4, name: "Coffee", cName: "drink", price: 30000,image: "coffee"),
    Type(id: 5, name: "Green tea", cName: "drink", price: 10000,image: "greentea"),
    Type(id: 6, name: "Bubble milk tea", cName: "drink" , price: 45000,image: "milktea"),
    Type(id: 7, name: "Mexican Bread", cName: "meal" , price: 35000,image: "breadmeal"),
    Type(id: 8, name: "Burger", cName: "meal"  , price: 39000,image: "burger"),
    Type(id: 9, name: "Chicken", cName: "meal"  , price: 120000,image: "chicken"),
    Type(id: 10, name: "Hotdog", cName: "meal" , price: 25000,image: "hot-dog"),
    Type(id: 11, name: "Vietnamese hotdog", cName: "meal"  , price: 20000,image: "hotdog"),
    Type(id: 12, name: "Meat", cName: "drink" , price: 253000,image: "meat"),
    Type(id: 13, name: "Chinese Noodles", cName: "meal"  , price: 49000,image: "noodles"),
    Type(id: 14, name: "Sandwich", cName: "meal"  , price: 20000,image: "sandwich"),
]

var meal = [
    [
    Type(id: 0, name: "White Rice", cName: "meal", price: 20000,image: "rice"),
    Type(id: 1, name: "Mexican Bread", cName: "meal" , price: 35000,image: "breadmeal")
    ],
    [
    Type(id: 2, name: "Vietnamese hotdog", cName: "meal"  , price: 20000,image: "hotdog"),
    Type(id: 3, name: "Sandwich", cName: "meal"  , price: 20000,image: "sandwich")
    ],
    [
    Type(id: 4, name: "Meat", cName: "meal" , price: 253000,image: "meat"),
    Type(id: 5, name: "Chinese Noodles", cName: "meal"  , price: 49000,image: "noodles")
    ],
    [
    Type(id: 6, name: "Hotdog", cName: "meal" , price: 25000,image: "hot-dog"),
    Type(id: 7, name: "Chicken", cName: "meal"  , price: 120000,image: "chicken")
    ],

    [
    Type(id: 8, name: "Burger", cName: "meal"  , price: 39000,image: "burger"),
    ]

]

var drink = [
    [
        Type(id: 9, name: "Coffee", cName: "drink", price: 30000,image: "coffee"),
        Type(id: 10, name: "Green tea", cName: "drink", price: 10000,image: "greentea")
    ],
    
    [
        Type(id: 11, name: "Bubble milk tea", cName: "drink" , price: 45000,image: "milktea"),
        Type(id: 12, name: "Fresh Milk", cName: "drink", price: 20000,image: "milk")
    ],
    
    [
        Type(id: 13, name: "Soda", cName: "drink" , price: 10000,image: "soda"),
        Type(id: 14, name: "Lemon Juice", cName: "drink", price: 20000,image: "lemon-juice")
    ],
    
    [
        Type(id: 15, name: "Orange juice", cName: "drink" , price: 10000,image: "drink"),
        Type(id: 16, name: "Banana milk", cName: "drink", price: 20000,image: "banana-milk")
    ],
    
    
]

var extra = [
    [
    Type(id: 17, name: "Fired Potatoe", cName: "extra", price: 20000,image: "friedpotato"),
    Type(id: 18, name: "Vegetable", cName: "extra", price: 20000,image: "healthy-food")
    ],
    
    [
    Type(id: 19, name: "Cheese flat", cName: "extra", price: 5000,image: "cheese"),
    Type(id: 20, name: "Poutine", cName: "extra", price: 25000,image: "poutine")
    ]
 
]

var dessert = [
    [
    Type(id: 21, name: "France Flan", cName: "dessert", price: 10000,image: "dessert"),
    Type(id: 22, name: "Jelly", cName: "dessert", price: 10000,image: "jelly")
    ],
    
    [
    Type(id: 23, name: "Donut", cName: "dessert", price: 20000,image: "sweet"),
    Type(id: 24, name: "Tart", cName: "dessert", price: 25000,image: "tart")
    ],
    
    [
    Type(id: 25, name: "Tiramisu", cName: "dessert", price: 25000,image: "tiramisu"),
    Type(id: 26, name: "Macaron", cName: "dessert", price: 20000,image: "macaron")
    ],
    
    [
    Type(id: 27, name: "Ice cream", cName: "dessert", price: 10000,image: "ice-cream"),
    Type(id: 28, name: "Croissant", cName: "dessert", price: 20000,image: "bread")
    ]

]
