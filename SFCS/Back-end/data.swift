//
//  data.swift
//  SFCS
//
//  Created by Đặng Nhật Quân on 7/1/20.
//  Copyright © 2020 Đặng Nhật Quân. All rights reserved.
//

import Foundation

var nTotal = 0
var currentOrderID = -1
var currentnOrderID = -1
var OrderID = 0
var nOrder = 0
var Email = ""
var checkOutID = 0
var paymentType = "Cash"
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

func setCurrentOrderID(){
    currentOrderID = OrderID
}

func deleteCurrentOrderID(){
    currentOrderID = -1
}

var meal = [
    [
    Type(id: 0, name: "White Rice", cName: "meal", price: 20000,image: "rice"),
    Type(id: 7, name: "Mexican Bread", cName: "meal" , price: 35000,image: "breadmeal")
    ],
    [
    Type(id: 11, name: "Vietnamese hotdog", cName: "meal"  , price: 20000,image: "hotdog"),
    Type(id: 14, name: "Sandwich", cName: "meal"  , price: 20000,image: "sandwich")
    ],
    [
    Type(id: 12, name: "Meat", cName: "meal" , price: 253000,image: "meat"),
    Type(id: 13, name: "Chinese Noodles", cName: "meal"  , price: 49000,image: "noodles")
    ],
    [
    Type(id: 10, name: "Hotdog", cName: "meal" , price: 25000,image: "hot-dog"),
    Type(id: 9, name: "Chicken", cName: "meal"  , price: 120000,image: "chicken")
    ],

    [
    Type(id: 8, name: "Burger", cName: "meal"  , price: 39000,image: "burger"),
    ]

]

var drink = [
    [
        Type(id: 4, name: "Coffee", cName: "drink", price: 30000,image: "coffee"),
        Type(id: 5, name: "Green tea", cName: "drink", price: 10000,image: "greentea")
    ],
    
    [
        Type(id: 6, name: "Bubble milk tea", cName: "drink" , price: 45000,image: "milktea"),
        Type(id: 3, name: "Fresh Milk", cName: "drink", price: 20000,image: "milk")
    ],
]

var extra = [
    [
    Type(id: 1, name: "Fired Potatoe", cName: "extra", price: 20000,image: "friedpotato")
    ]
 
]


var dessert = [
    [
         Type(id: 2, name: "France Flan", cName: "dessert", price: 25000,image: "dessert")
    ]

]
