//
//  Menu.swift
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

//Menu when clicking to the button at the left corner of the top
struct Menu : View {
    @Binding var foodmenu : Bool
    @Binding var size : CGFloat
    @Binding var cart : Bool
    @Binding var account : Bool
    
    @State var checkout = false
    
    var body : some View{
        
        VStack{
            
            if self.checkout {
                NavigationLink(destination: CheckOutScreen(checkout: self.$checkout), isActive: self.$checkout) {
                        Text("")
                    }
                    .hidden()
                                         
            }
            else if self.foodmenu {
                NavigationLink(destination: FoodMenu(foodmenu: self.$foodmenu, cart: self.$cart, account: self.$account), isActive: self.$checkout) {
                                   Text("")
                               }
                               .hidden()
                                                    
                       }
            
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                     
                    self.size =  UIScreen.main.bounds.width / 1.6
                }) {
                    
                    Text("X")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 15, height: 15)
                        .padding()
                }
                .background(Color("Yellow"))
                .foregroundColor(.white)
                .clipShape(Circle())
                .offset(x: -10,y:10)
            }
            
            HStack{
                
                Button(action: {
                    self.size = UIScreen.main.bounds.width / 1.6
                    self.foodmenu = false
             
                }) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.black)
                        .padding()
                                   
                    Text("Home")
                        .foregroundColor(Color.black)
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
                
           
            }.padding([.leading,.trailing], 20)
            
           HStack{
                                               
                          Button(action: {
                            
                              
                          }) {
                              Image("person")
                                            .renderingMode(.original)
                                            .resizable()
                                            .frame(width:35 , height:35)
                                            .padding()
                              Text("Account").fontWeight(.heavy).foregroundColor(.black)
                              Spacer()
                          }
                                .background(Color("Yellow"))
                                .cornerRadius(25)
                      }
                      .padding([.leading,.trailing], 20)
            
            HStack{
                                                
                Button(action: {
                    self.size = UIScreen.main.bounds.width / 1.6
                    self.foodmenu = true
                }) {
                    Image("wine")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    
                    Text("Full menu").fontWeight(.heavy).foregroundColor(.black)
                    
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
            }.padding([.leading,.trailing], 20)
            
            HStack{
                                     
                Button(action: {
                    self.size =  UIScreen.main.bounds.width / 1.6
                    self.checkout.toggle()
                    
                }) {
                    Image("payment")
                                  .renderingMode(.original)
                                  .resizable()
                                  .frame(width:35 , height:35)
                                  .padding()
                    Text("Your order").fontWeight(.heavy).foregroundColor(.black)
                    Spacer()
                }
                      .background(Color("Yellow"))
                      .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                                                
                    Button(action: {
                       
                               
                    }) {
                        Image("refund")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width:35 , height:35)
                            .padding()
                        Text("Your refund").fontWeight(.heavy).foregroundColor(.black)
                        Spacer()
                    }
                    .background(Color("Yellow"))
                    .cornerRadius(25)
            }
            .padding([.leading,.trailing], 20)
            
            HStack{
                                               
                Button(action: {
                              
                }) {
                    Image("question")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    Text("About us").fontWeight(.heavy).foregroundColor(.black)
                    Spacer()
                }
                .background(Color("Yellow"))
                .cornerRadius(25)
            }.padding([.leading,.trailing], 20)
            
            HStack{
                           
                 Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }) {
               
                    
                Image("logout")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width:35 , height:35)
                        .padding()
                    Text("Log out").fontWeight(.heavy).foregroundColor(.black)
                Spacer()
            }
            .background(Color("Yellow"))
            .cornerRadius(25)
            }.padding([.leading,.trailing], 20)
            
            Spacer()
            
        }
            .frame(width: UIScreen.main.bounds.width / 1.6)
            .background(Color("Dark"))
            .animation(.spring())
           
           
      
          
       
    }
   
}

//Check Out screen when clicking to the "Your Order" button in menu
struct ccCheckOutScreen : View {
    
    @Binding var checkout : Bool
    
    var body : some View {
        
        ZStack {
            VStack{
                if currentOrderID != -1 {
                Text("Your Order ID:")
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.black)
                
                Text(String(currentOrderID))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding()
                    .foregroundColor(Color("Orange"))
                    
                HStack{
                    Text("Your order Status")
                                   
                        Text(String(orderStatus))
                }
                
                Text("Pick up your order at court")
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.black)
                
                    Button(action: {
                        deleteCurrentOrderID()
                    }){
                        Text("Done")
                    }
                
                }
                else {
                    Text("You don't have any order")
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.black)
                }
            }
        }
        
    }
    
    
}
