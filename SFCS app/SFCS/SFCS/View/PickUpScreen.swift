//
//  PickUpScreen.swift
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
import MomoiOSSwiftSdk


// PickUp view when choose "pay now" in cartView
struct pickUpScreen : View {
    @ObservedObject var cartdata = getCartData()
    @Binding var pickup : Bool
    @Binding var checkout : Bool
    @State var payment = false
    @State var setTime = false
    var result = 0

    var body: some View {
        
        NavigationView {
            ZStack {
                if self.payment {
                    NavigationLink(destination: Payment(payment: self.$payment), isActive: self.$payment) {
                        Text("")
                    }
                    .hidden()
                }
                if self.setTime {
                    NavigationLink(destination: pickupTime(setTime: self.$setTime), isActive: self.$setTime) {
                                    Text("")
                    }
                    .hidden()
                }
                
                ZStack {
            
                    Color("Grey").edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        ZStack {
                            HStack (spacing: 10) {
                                                               
                                Button(action: {
                                    self.pickup.toggle()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.title)
                                        .foregroundColor(Color.black)
                                        .padding()
                                }
                                .background(Color("Yellow"))
                                .cornerRadius(10)
                                                               
                                Spacer()
                            }
                            .padding(.horizontal)
                                
                            Text("Check Out")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                        }
                            
                        HStack{
                            VStack{
                                GeometryReader{g in
                                    List {
                                                                          
                                        ForEach(self.cartdata.datas){i in
                                                                                                    
                                            HStack(spacing: 15){
                                                Image(i.pic)
                                                    .resizable()
                                                    .frame(width: 55, height: 55)
                                                    .cornerRadius(10)
                                                                                                     
                                                VStack(alignment: .leading){
                                                    Text(i.name)
                                                    Text("\(i.quantity)"+" x "+"\(i.price)")
                                                }
                                                    
                                                Spacer()
                                                    
                                                Text(String(i.quantity.intValue*i.price.intValue))
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
                                }
                            }
                            .padding(.top)
                            .frame(width: UIScreen.main.bounds.width - 30,height: 400)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top)
                                    
                        HStack {
                            Button(action: {
                                self.setTime.toggle()
                            }){
                                HStack{
                                    Text("Pick up time: ")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .padding(.vertical)
                                            
                                    Text( timeFormatter.string(from: tPickUp))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("Orange"))
                                        .padding(.vertical)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                        .padding(.top)
                            
                        HStack{
                            Button(action: {
                                print("open payment view")
                                self.payment.toggle()
                            }){
                                Text("Payment Type: ")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    
                                Text(String(paymentType))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Orange"))
                                    
                                Image(systemName: "chevron.up")
                                    .foregroundColor(Color("Orange"))
                            }
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 30)
                        }
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                        .padding(.top)
                            
                        HStack{
                            Text("Total: ")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding(.vertical)
                                    
                            Text(String(total(cartdata: cartdata.datas)) + " VNĐ")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding(.vertical)
                        }
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                        .padding(.top)
                                
                        HStack{
                            Button(action: {
                                status = "confirm"
                                UserDefaults.standard.setValue(nOrder+1, forKeyPath: "currentnOrder")
                                addOrder(cartdata: self.cartdata.datas)
                                UserDefaults.standard.setValue(true, forKeyPath: "haveOrder")
                                self.pickup.toggle()
                                
                                if (paymentType == "Momo Pay"){
                                    momoPayment()
                                }
                    
                            }){
                                Text("Pay now")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 30)
                            }
                        }
                        .background(Color("Yellow"))
                        .cornerRadius(15)
                        .padding(.top)
                            
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
}

//Pickup time setting view
struct pickupTime : View {
    
    @State var time = Date()
    @Binding var setTime : Bool
    @State var tap = false
    
    var body: some View {
        
        ZStack{
            
            Color("Grey").edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    HStack(spacing: 10) {
                        Button(action: {
                            self.setTime.toggle()
                            tPickUp = self.time
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        .background(Color("Yellow"))
                        .cornerRadius(10)

                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Text("Select the pickup time :")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                }
                
                VStack {
                    Form {
                        DatePicker("Pickup time", selection: $time, in: Date()..., displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    }
                    .offset(x: 0, y: 25)
                    .frame(width: UIScreen.main.bounds.width - 30,height: 350)
                    .cornerRadius(10)
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

//Payment types setting view
struct Payment : View {
    
    @Binding var payment : Bool
    
    var body : some View {
        ZStack {
            
            Color("Grey").edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 10) {
                    Button(action: {
                       self.payment.toggle()
                    }){
                        Text("Return")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .frame(width: 100,height: 50)
                    .background(Color("Yellow"))
                    .cornerRadius(10)
                    .padding(.bottom)
                               
                    Text("Select payment type: ")
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .foregroundColor(Color("Yellow"))
                        .frame(width: UIScreen.main.bounds.width-160,height: 80)
                        .background(Color("Dark"))
                        .cornerRadius(10)
                }
                
                VStack(spacing: 10){
                    Spacer()
                    
                    Button(action: {
                        self.payment.toggle()
                        paymentType = "Cash"
                    }){
                        HStack{
                            Image("money")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width:35, height:35)
                            
                            Text("Cash")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                
                        }
                        .frame(width: UIScreen.main.bounds.width-70,height:(UIScreen.main.bounds.height-195)/4)
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                    }
               
                    Button(action: {
                        self.payment.toggle()
                        paymentType = "Credit card"
                    }){
                         HStack{
                            Image("credit-card")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width:35, height:35)
                            
                            Text("Credit card")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width-70,height:(UIScreen.main.bounds.height-195)/4)
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                    }
   
                    Button(action: {
                        self.payment.toggle()
                        MoMoPayment.requestToken()
                        paymentType = "Momo Pay"
                    }){
                        HStack{
                            Image("momo")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width:35, height:35)
                            
                            Text("Momo pay")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width-70,height:(UIScreen.main.bounds.height-195)/4)
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                    }

                    Button(action: {
                        self.payment.toggle()
                        paymentType = "Apple Pay"
                    }){
                        HStack{
                            Image("company")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width:35, height:35)
                            
                            Text("Apple pay")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width-70,height:(UIScreen.main.bounds.height-195)/4)
                        .background(Color("Yellow"))
                        .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .frame(width: UIScreen.main.bounds.width-50,height: UIScreen.main.bounds.height-130)
                .background(Color("Dark"))
                .cornerRadius(10)
                .padding(.top, -15)
                    
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
