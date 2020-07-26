//
//  CartView.swift
//  SFCS
//
//  Created by Đặng Nhật Quân on 6/30/20.
//  Copyright © 2020 Đặng Nhật Quân. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import SDWebImageSwiftUI

//cart view when clicking to the button at the right corner of the top.
struct CartView : View {
    @Binding var pickup : Bool
    @Binding var cart : Bool
    @ObservedObject var cartdata = getCartData()
    @State var paymentType = ""
    @State var checkout = false
    var body : some View{
        
        VStack {
            
            if self.checkout {
                NavigationLink(destination: CheckOutScreen(checkout: self.$checkout), isActive: self.$checkout) {
                        Text("")
                }
                .hidden()
            }
            
            if UserDefaults.standard.bool(forKey: "haveOrder") != false {
                VStack{
                    Image("cooking")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 250,height: 250)
                        
                       
                    
                    Text("Your order is on process")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding([.top,.leading])
                
                    Button(action: {
                        self.checkout.toggle()
                    }) {
                                      
                        Text("Check your order now")
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                    }
                    .background(Color("Yellow"))
                    .clipShape(Capsule())
                    .padding(.top, 20)
                }
            }
            else {
                Text(self.cartdata.datas.count != 0 ? "Your cart" : "No Items In Cart")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding([.top,.leading])
           
           if self.cartdata.datas.count != 0{
                
                List {
                    
                    ForEach(self.cartdata.datas){i in
                        
                        HStack(spacing: 15){
                            
                            Image(i.pic)
                                .resizable()
                                .frame(width: 55, height: 55)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading){
                                
                                Text(i.name)
                                Text("\(i.quantity)")
                            }
                        }
                        .onTapGesture {
                                                   
                            UIApplication.shared.windows.last?.rootViewController?.present(textFieldAlertView(id: i.id), animated: true, completion: nil)
                        }
                        
                        
                    }
                    .onDelete { (index) in
                        
                        let db = Firestore.firestore()
                        db.collection(String(OrderID)).document(self.cartdata.datas[index.last!].id).delete { (err) in
                            
                            if err != nil{
                                
                                print((err?.localizedDescription)!)
                                return
                            }
                            
                            self.cartdata.datas.remove(atOffsets: index)
                        }
                    }
                    
                    
                }
                .background(Color("Mint"))
                
               
                Button(action:   {
                    self.pickup.toggle()
                    self.cart.toggle()
                    self.getnOrder()
                    
                }) {
                                   
                                   Text("Pay your order")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                       .padding(.vertical)
                                       .frame(width: 200)
                               }
                               .background(Color("Red"))
                               .cornerRadius(10)
                               .padding(.top,-10)
                
            }
            

            }
        }.frame(width: UIScreen.main.bounds.width - 110, height: UIScreen.main.bounds.height - 350)
       .background(Color("Dark"))
        .cornerRadius(25)
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
   
   
    
    
}

//view to setting quantity of item
func textFieldAlertView(id: String)->UIAlertController{
    
    let alert = UIAlertController(title: "Update", message: "Enter The Quantity", preferredStyle: .alert)
    
    alert.addTextField { (txt) in
        
        txt.placeholder = "Quantity"
        txt.keyboardType = .numberPad
    }
    
    let update = UIAlertAction(title: "Update", style: .default) { (_) in
        
        let db = Firestore.firestore()
        
        let value = alert.textFields![0].text!
            
        db.collection(String(OrderID+1)).document(id).updateData(["quantity":Int(value)!]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alert.addAction(cancel)
    
    alert.addAction(update)
    
    return alert
}
