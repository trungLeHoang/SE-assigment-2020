import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import SDWebImageSwiftUI

//UI
var status = ""
var orderStatus = false
struct ContentView: View {
    
   
    var body: some View {
        
        
        
      Home()
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @State var account = false
    @State var cart = false
    @State var muilti = false
    @State var show = false
    @State var pickup = false
    @State var status = true
    @State var checkout = false
    @State var mainscreen = false
    @State var foodmenu = false
  
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
                if self.status{
                    
                    
                    Mainscreen(foodmenu: self.$foodmenu, cart: self.$cart, account: self.$account)
                
                    if self.foodmenu {
                        FoodMenu(foodmenu: self.$foodmenu,cart: self.$cart, account: self.$account, show: self.show)
                        
                        if self.cart {
                                               
                            GeometryReader{_ in
                                                      
                                CartView(pickup: self.$pickup, cart: self.$cart)
                                                   
                                                      
                            }.background(
                                                      
                            Color.black.opacity(0.55)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                        self.cart.toggle()
                                }
                            )
                        }
                                           
                        if self.pickup {
                                      
                            NavigationLink(destination: PickUpScreen(pickup: self.$pickup,checkout: self.$checkout), isActive: self.$pickup) {
                                Text("")
                                                                                 
                            }
                            .hidden()
                        }
                    }
                    else {
                        if self.cart {
                            
                               GeometryReader{_ in
                                   
                                CartView(pickup: self.$pickup, cart: self.$cart)
                                
                                   
                               }.background(
                                   
                                   Color.black.opacity(0.55)
                                       .edgesIgnoringSafeArea(.all)
                                       .onTapGesture {
                                           
                                        self.cart.toggle()
                                   }
                               )
                        }
                    
                    
                        if self.pickup {
                   
                            NavigationLink(destination: PickUpScreen(pickup: self.$pickup,checkout: self.$checkout), isActive: self.$pickup) {
                                    Text("")
                                                              
                                }
                                .hidden()
                           
                        }
                    
                    }
                }
               
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
        
    }
    
  
}

struct OrderStatus : View {
    
    @Binding var check : Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Text("Your order Status")
                
                    Text(String(orderStatus))
                }
                
                Button(action: {
                    
                 
                })
                {
                    Text("Click")
                }
            }
        }
    }
}

struct FoodMenu : View {
    
    @Environment(\.colorScheme) var scheme
    @Binding var foodmenu : Bool
    @Binding var cart : Bool
    @Binding var account : Bool
    @State var show = false
    @State var size = UIScreen.main.bounds.width / 1.6
    
    @State var data = Type(id: -1, name: "", cName: "", price: 0,image: "")

    var body: some View {
        NavigationView {
            ZStack{
                VStack{
         
                    ZStack{
                        
                        HStack(spacing: 15){
                            
                          Button(action: {
                                self.size = 5
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
                        
                        
                        
                        Text("Menu")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Main meal")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(meal,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if currentOrderID != -1 {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                                                   
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    
                                    }
                                }
                                
                            }
                        }
                        .padding()
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Drink")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(drink,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if currentOrderID != -1 {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                                                   
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    
                                    }
                                }
                                
                            }
                        }
                        .padding()
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Extra")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(extra,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if currentOrderID != -1 {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                                                   
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    
                                    }
                                }
                                
                            }
                        }
                        .padding()
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Dessert")
                                    .fontWeight(.bold)
                                    .font(.title)
                                
                                Spacer()
                            }
                            .padding(.top,30)
                            .padding(.bottom, 20)
                            
                             ForEach(dessert,id: \.self){furniture in
                                
                                HStack(spacing: 15){
                                    
                                   ForEach(furniture){i in
                                        
                                        Button(action:{
                                            self.data = i
                                            
                                            if currentOrderID != -1 {
                                                self.cart.toggle()
                                            }
                                            else {
                                                self.show.toggle()
                                                                   
                                            }
                                        }){
                                            VStack {
                                                Image(i.image)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 50,height: 50)
                                                  
                                                
                                                Text(i.name)
                                                     .foregroundColor(Color("Yellow"))
                                                    .fontWeight(.bold)
                                                
                                                Text(String(i.price.intValue)+" VNĐ")
                                                    .foregroundColor(Color("Yellow"))
                                                    .padding(.top, 6)
                                            }
                                        }
                                        .padding()
                                        .background(Color("Dark"))
                                        .cornerRadius(10)
                                    
                                    }
                                }
                                
                            }
                        }
                        .padding()
                    }
                    
                    
                    Spacer()
                    
                 
                }
                .sheet(isPresented: self.$show) {
                                      
                           OrderView(data: self.data,show: self.$show)
                    }
                   
                
               HStack{
                    Menu(foodmenu: self.$foodmenu,size: self.$size, cart: self.$cart, account: self.$account)
                        .cornerRadius(20)
                        .padding(.leading, -size)
                        .offset(x: -size)
                                                                                            
                    Spacer()
                }
                .animation(.spring())

            }
            .background(Color("Grey").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
           
            
        }
        
       
    }
}

// orderView -> cardView -> Listt -> Carousel -> Mainscreen


// orderView -> button -> foodmenu


struct CheckOutScreen : View {
    
    @Binding var checkout : Bool
    
    var body: some View {
        
        NavigationView{
            ZStack {
                
                Color("Grey").edgesIgnoringSafeArea(.all)

                if currentOrderID != -1 {
                   
                    VStack(spacing: 10){
                       

                        
                        VStack(spacing: 10) {
                            
                            
                            Text("Your Order ID:")
                                .fontWeight(.bold)
                                .padding()
                                 .foregroundColor(Color("Yellow"))
                                
                            
                            Text(String(currentOrderID))
                                .fontWeight(.bold)
                                .frame(width: 75,height: 75)
                                .padding()
                                .background(Color("Yellow"))
                                .foregroundColor(Color.black)
                                .cornerRadius(75)
                              
                            
                            VStack(alignment: .leading){
                                HStack {
                                    VStack(alignment: .leading){
                                        Text("Name: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                        
                                        Text("Pick up time: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                        
                                        Text("Payment type: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)
                                        
                                        Text("Total: ")
                                            .fontWeight(.bold)
                                            .padding()
                                            .foregroundColor(Color.black)

                                    }
                                    
                                    VStack(alignment: .leading){
                                        Text(Email)
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                        Text( timeFormatter.string(from: tPickUp))
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                        Text(paymentType)
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                        
                                        Text(String(nTotal)+" VNĐ")
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(Color.black)
                                    }
                                }
                                
                                
                                
                               
                            }
                            .frame(width: UIScreen.main.bounds.width-50 )
                            .background(Color("Yellow"))
                            .cornerRadius(20)
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width-25,height: 410)
                        .background(Color("Dark"))
                        .cornerRadius(30)
                        .padding(.top,-60)
               
                        VStack(spacing: 10) {
                          
                            Text("Order's Status")
                                .fontWeight(.bold)
                                .padding()
                                 .foregroundColor(Color("Yellow"))
                            
                            if status == "confirm" {
                                Image("accept")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200,height:200)
                                
                                Text("Your order is successfully confirm.")
                                 .foregroundColor(Color("Yellow"))
                            }
                            else if status == "cooking" {
                                Image("soup")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200,height:200)
                                
                                Text("Your order is preparing.")
                                 .foregroundColor(Color("Yellow"))
                            }
                            else if status == "finish" {
                                Image("dinner")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 200,height:200)
                                
                                Text("Your order is done. Please pick up at the court")
                                .foregroundColor(Color("Yellow"))
                            }
                          
                                                     
                            HStack(spacing: 10){
                                
                                
                                Rectangle()
                                    .frame(width:110,height: 10)
                                   .foregroundColor(Color("Yellow"))
                                    .cornerRadius(5)
                                
                                if status == "cooking" || status == "finish" {
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color("Yellow"))
                                        .cornerRadius(5)
                                }
                                else {
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                }
                                
                                if status == "finish"{
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color("Yellow"))
                                        .cornerRadius(5)
                                    }
                                else {
                                    Rectangle()
                                        .frame(width:110,height: 10)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                }
                              
                            }
                               
                            
                            HStack(spacing: 10) {
                              
                                if status == "finish" {
                                    
                                    HStack(spacing: 5){
                                                        
                                                        Image("back")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .frame(width:15 , height:15)
                                                            .padding(.vertical)
                                                            
                                                        
                                                        Text("Return")
                                                            .fontWeight(.bold)
                                                            .foregroundColor(Color.black)
                                                            .padding(.vertical)
                                                        
                                    }
                                    .frame(width: ((UIScreen.main.bounds.width-50)/3)-5)
                                    .background(Color("Grey"))
                                    .cornerRadius(10)
                                    
                                               
                                }
                                else {
                                    Button(action: {
                                        self.checkout.toggle()
                                    }){
                                        HStack(spacing: 5){
                                            
                                            Image("back")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width:15 , height:15)
                                                .padding(.vertical)
                                                
                                            
                                            Text("Return")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.black)
                                                .padding(.vertical)
                                            
                                        }
                                        .frame(width: ((UIScreen.main.bounds.width-50)/3)-5)
                                        .background(Color("Yellow"))
                                        .cornerRadius(10)
                        
                                    }
                                    .frame(width: ((UIScreen.main.bounds.width-50)/3)-5)
                                    .background(Color("Yellow"))
                                    .cornerRadius(10)
                                }
                                
                                if status != "finish" {
                                    Text("Not done yet")
                                        .padding()
                                        .frame(width: 2*((UIScreen.main.bounds.width-50)/3)-5)
                                        .foregroundColor(Color.white)
                                        .background(Color("Grey"))
                                        .cornerRadius(10)
                                }
                                else {
                                    Button(action: {
                                        deleteCurrentOrderID()
                                        self.checkout.toggle()
                                    }){
                                        Text("Done")
                                            .fontWeight(.bold)
                                            .frame(width: 2*((UIScreen.main.bounds.width-50)/3)-5)
                                            .padding(.vertical)
                                            .foregroundColor(Color.black)
                                            .background(Color("Yellow"))
                                            .cornerRadius(10)
                                        }
                                                       
                                                   
                                }
                                
                            }
                            
                            
                            
                          
                           
                        }
                        .frame(width: UIScreen.main.bounds.width-25,height: 410)
                        .background(Color("Dark"))
                        .cornerRadius(30)
                        
                        Spacer()
                    }
                    
                }
                else {
                    VStack{
                        Spacer()
                        
                        Text("You don't have any order")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color.black)
                        
                        Button(action: {
                            self.checkout.toggle()
                        }){
                            HStack(spacing: 5){
                                
                                Image("back")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:15 , height:15)
                                    .padding(.vertical)
                                    
                                
                                Text("Return")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width-50)
                            .background(Color("Yellow"))
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                }
            }
               
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
    
}


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
