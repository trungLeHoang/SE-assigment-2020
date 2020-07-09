//
//  Mainscreen.swift
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


//Main menu (after login)
struct Mainscreen : View {
    @Binding var foodmenu: Bool
    @Binding var cart : Bool
    @Binding var account : Bool
    @State var size = UIScreen.main.bounds.width / 1.6
    
    @State var menu = 0
    @State var page = 0


    var body: some View{
        
        
      ZStack {
                
                Color("Grey").edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    ZStack{
                        
                        HStack (spacing: 10) {
                            
                            Button(action: {
                                
                                self.size = 5
                                self.getnOrder()
                                
                            }) {
                                                                
                                Image("menu")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width:35 , height:35)
                                        .padding()
                                                                    
                            }
                            .background(Color("Yellow"))
                            .cornerRadius(25)
                            
                            Spacer()
                            
                            Button(action: {
                         
                                     self.cart.toggle()
                        
                               
                                    
                             
                             }) {
                                 
                                 Image("buy")
                                     .renderingMode(.original)
                                 .resizable()
                                     .frame(width:35 , height:35)
                                    .padding()
                                     
                             }
                            .background(Color("Yellow"))
                            .cornerRadius(25)
                            
                        }
                        .padding(.horizontal)
                        
                        Text("HOME")
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                            .foregroundColor(Color.black)
                    }
                    
                    
                    GeometryReader{g in
                        
                        // Simple Carousel List....
                        // Using GeomtryReader For Getting Remaining Height...
                        
                        Carousel(width: UIScreen.main.bounds.width, cart: self.$cart, page: self.$page, menu: self.$menu, height: g.frame(in: .global).height)
                    }
                    
                    
                    PageControl(menu: self.$menu, page: self.$page)
                    .padding(.top, 20)
                                        
                    
                    
                }
                .padding(.vertical)
        
                HStack{
                                                  
                    Menu(foodmenu: self.$foodmenu, size: self.$size, cart: self.$cart, account: self.$account)
                                       .cornerRadius(20)
                                       .padding(.leading, -size)
                                       .offset(x: -size)
                    
                        
                                                  
                    Spacer()
                }
                .animation(.spring())
                
            }
            
           
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


// Menu list struct
struct PageControl : UIViewRepresentable {
    
    @Binding var menu : Int
    @Binding var page : Int
    
    func makeUIView(context: Context) -> UIPageControl {
        
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = UIColor(named: "Orange")
        view.pageIndicatorTintColor = .black
        
        view.numberOfPages = data.count
        
        
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        
        // Updating Page Indicator When Ever Page Changes....
        
        DispatchQueue.main.async {
            print(self.page)
            uiView.currentPage = self.page
        }
    }
}

struct Listt : View {
    @EnvironmentObject var categories : getCategoriesData
    @Binding var cart : Bool
    @Binding var page : Int
    @Binding var menu : Int
    
    var body: some View{
        
        HStack(spacing: 0){
            
            
                ForEach(data){i in
                    // Mistakenly Used Geomtry Reader...
                    
                    Card(cart: self.$cart, page: self.$page, width: UIScreen.main.bounds.width, data: i)
                }
            }
            
        }
    }

struct Card : View {
    @Binding var cart : Bool
    @Binding var page : Int
    var width : CGFloat
    var data : Type
    @State var show = false
   
    
    var body: some View{
        
        VStack{
            
            VStack {
                
                Text(self.data.name)
                    .foregroundColor(Color("Yellow"))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top,20)
                
                Text(self.data.cName)
                    .foregroundColor(Color("Yellow"))
                    .foregroundColor(.black)
                    .padding(.vertical)
                
                Spacer(minLength: 0)
                
                Image(self.data.image)
                .resizable()
                .frame(width: self.width - (self.page == self.data.id ? 100 : 150), height: (self.page == self.data.id ? 250 : 200))
                    .cornerRadius(20)
                
                Text(self.data.price.stringValue+" VNĐ")
                    .foregroundColor(Color("Yellow"))
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 20)
                
                Button(action: {
                    if currentOrderID != -1 {
                        self.cart.toggle()
                    }
                    else {
                        self.show.toggle()
                                           
                    }
    
                }) {
                    
                    Text("Add to cart+")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                }
                .background(Color("Yellow"))
                .clipShape(Capsule())
                .padding(.top, 20)
                
                
                Spacer(minLength: 0)
                
                // For Filling Empty Space....
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(Color("Dark"))
            .cornerRadius(20)
            .padding(.top, 25)
            .padding(.vertical, self.page == data.id ? 0 : 25)
            .padding(.horizontal, self.page == data.id ? 0 : 25)
            
            // Increasing Height And Width If Currnet Page Appears...
        }
        .frame(width: self.width)
        .animation(.default)
        .sheet(isPresented: self.$show) {
                       
            OrderView(data: self.data,show: self.$show)
        }
    }
}

struct Carousel : UIViewRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        
        return Carousel.Coordinator(parent1: self)
    }
    
    var width : CGFloat
    @Binding var cart : Bool
    @Binding var page : Int
    @Binding var menu : Int
    var height : CGFloat
    
    func makeUIView(context: Context) -> UIScrollView{
        
        // ScrollView Content Size...
        
        
       
            
            let total = width * CGFloat(data.count)
            let view = UIScrollView()
            view.isPagingEnabled = true
            //1.0  For Disabling Vertical Scroll....
            view.contentSize = CGSize(width: total, height: 1.0)
            view.bounces = true
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            view.delegate = context.coordinator
            
        let view1 = UIHostingController(rootView: Listt(cart: self.$cart, page: self.$page, menu: self.$menu))
            view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
            view1.view.backgroundColor = .clear
            
            view.addSubview(view1.view)
            
           return view
        
        
        // Now Going to  embed swiftUI View Into UIView...
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        
        
        var parent : Carousel
        
        init(parent1: Carousel) {
            
        
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            // Using This Function For Getting Currnet Page
            // Follow Me...
            
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            
            self.parent.page = page
        }
    }
}

struct Loader : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
        
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {
        
        
    }
}



// Order view ( when click to "add to cart+")

struct OrderView : View {
    
    var data : Type
    @State var cash = false
    @State var quick = false
    @State var quantity = 0
    @Binding var show : Bool

    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        VStack( spacing: 15){
            
           
            
                Image(self.data.image)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .padding()
                                .offset(x: 0,y: 0)
            
            
            
            VStack(alignment: .leading, spacing: 25) {
                
                Text(data.name).fontWeight(.heavy).font(.title)
                Text(data.price.stringValue+"VNĐ").fontWeight(.heavy).font(.body)
                
                
                Stepper(onIncrement: {
                    
                    self.quantity += 1
                    
                }, onDecrement: {
                
                    if self.quantity != 0{
                        
                        self.quantity -= 1
                    }
                }) {
                    
                    Text("Quantity \(self.quantity)")
                }
                
                Button(action: {
                    
                    
                    if self.quantity >= 1 {
                        let db = Firestore.firestore()
                        db.collection(String(OrderID))
                            .document()
                            .setData(["item":self.data.name,"quantity":self.quantity,"quickdelivery":self.quick,"cashondelivery":self.cash,"pic":self.data.image,"price":self.data.price]) { (err) in
                                
                                if err != nil{
                                    
                                    print((err?.localizedDescription)!)
                                    return
                                }
                                
                                // it will dismiss the recently presented modal....
                                
                                self.presentation.wrappedValue.dismiss()
                            }
                    }
                        self.show.toggle()
                    
                    
                    
                }) {
                    
                    Text("Add To Cart")
                        .foregroundColor(Color("Yellow"))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                    
                }.background(Color("Dark"))
                    .foregroundColor(.black)
                .cornerRadius(20)
                
            }.padding()
            
            Spacer()
        }
        .background(Color("Yellow"))
        .edgesIgnoringSafeArea(.all)
    }
}





// orderView -> cardView -> Listt -> Carousel -> Mainscreen


// orderView -> button -> foodmenu
