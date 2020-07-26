//
//  getData.swift
//  SFCS
//
//  Created by Đặng Nhật Quân on 7/1/20.
//  Copyright © 2020 Đặng Nhật Quân. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import SDWebImageSwiftUI


class getCartData : ObservableObject{
    
    @Published var datas = [cart]()
    
    init() {
        getnOrder()
        let db = Firestore.firestore()
        
        db.collection(String(OrderID)).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let name = i.document.get("item") as! String
                    let quantity = i.document.get("quantity") as! NSNumber
                    let pic = i.document.get("pic") as! String
                    let price = i.document.get("price") as! NSNumber
                   

                    self.datas.append(cart(id: id, name: name, quantity: quantity, pic: pic, price: price ))
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let quantity = i.document.get("quantity") as! NSNumber
                    
                    for j in 0..<self.datas.count{
                        
                        if self.datas[j].id == id{
                            
                            self.datas[j].quantity = quantity
                        }
                    }
                }
            }
        }
    }
    
   
}

class getCategoriesData : ObservableObject{
    
    @Published var datas = [TypeCatogory]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection(String(OrderID)).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
               
                let id = i.document.documentID
                let name = i.document.get("name") as! String
                let cName = i.document.get("cName") as! String
                let price = i.document.get("price") as! String
                let image = i.document.get("image") as! String
                
                self.datas.append(TypeCatogory(id: id, name: name,cName: cName, price: price, image: image))
            }
        }
    }
}


func getTime()-> String {
    
    let currentTime = Date()
    
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .medium
    
    let timeString = formatter.string(from: currentTime)
    
    return timeString
    
    
}

func getnOrder(){
                    
                    var ref: DatabaseReference!
                    
                    ref = Database.database().reference()
                    
                    ref.child("nOrder").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                        let value = snapshot.value as? NSDictionary
                        
                        nOrder = value!["nOrder"] as! Int
                        OrderID = value!["orderID"] as! Int
                        print(nOrder)
                        print(OrderID)
                    // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                    
                }

func addOrder(cartdata: [cart]){
     getnOrder()
    var STT = 0
    var ref: DatabaseReference!
    
    ref = Database.database().reference().child("orderList").child(String(nOrder+1))
    
    let Order = [
        "ID" : OrderID+1,
        "userID" : userEmail,
        "isDone" : false,
        "paymentType": paymentType,
        "date" : getTime(),
        "pickuptime": timeFormatter.string(from: tPickUp),
        "status": status
    ] as [String:Any]
    
    ref.setValue(Order)
    
   ref=Database.database().reference().child("orderList").child(String(nOrder)).child("itemList")
                 
                 
          for i in cartdata {
                     
              ref=Database.database().reference().child("orderList").child(String(nOrder+1)).child("itemList").child(String(STT))
                     
              let Item = [
                         "name" : i.name,
                         "quantity" : i.quantity,
                         "price" : i.price
                      
              ] as [String:Any]
              
              ref.setValue(Item)
          
        
        STT += 1
        
    }
 
     ref = Database.database().reference().child("nOrder")
    let n = [
         "nOrder" : nOrder+1,
         "orderID" : OrderID+1
     ] as [String:Any]
                            
     ref.setValue(n)
 
    
               
}

func getStatus(){
   
    var ref: DatabaseReference!
                  
                  ref = Database.database().reference()
                  
    ref.child("orderList").child(String(UserDefaults.standard.integer(forKey: "currentnOrder"))).observeSingleEvent(of: .value, with: { (snapshot) in
                  
                      let value = snapshot.value as? NSDictionary
                      
                      status = value!["status"] as! String
                     
                        print(haveOrder)
                        
                  // ...
                  }) { (error) in
                      print(error.localizedDescription)
                  }
       
}

func isLoggedIn() -> Bool {
    return UserDefaults.standard.bool(forKey: "isLoggedIn")
}
