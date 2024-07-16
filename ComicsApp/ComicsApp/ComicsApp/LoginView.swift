//
//  LoginView.swift
//  ComicsApp
//
//  Created by Kevin Sanchez on 7/13/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var isCreateAccountViewPresented = false
    @State private var isPasswordCorrect: Bool = false
    @State private var showErrorAlert: Bool = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        NavigationStack{
            //-----------------
            ZStack{
                //location 1
                Image("back2")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
        
                
                //-----------------
                VStack{
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    
                    //location 2
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.orange)
                    
                    
                    Spacer()
                    
                    //---------------
                    //Email Field
                    //---------------
                    //location 3
                    HStack{
                        Image(systemName: "mail")
                            .foregroundColor(.orange)
                        TextField("Email", text:$email)
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        
                        
                        if(email.count != 0){
                            Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                                .frame(width: 30)
                                .fontWeight(.bold)
                                .foregroundColor(email.isValidEmail() ? .green : .red)
                        }
                        
                    }
                    .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.orange)
                        ).background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        ).padding(.horizontal)
                        
                        .padding()
                                        
                    //----------------
                    //Password Field
                    //----------------
                    //location 4
                    HStack{
                        Image(systemName: "lock")
                            .foregroundColor(.orange)
                        TextField("Password", text: $password)
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }.padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.orange)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        ).padding(.horizontal)
                        .padding()
                                        
                    //----------------
                    //New Account Button
                    //----------------
                    //location 5
                    Button(action: {
                        isCreateAccountViewPresented.toggle()
                    }) {
                        Text("Create Account")
                    }.foregroundColor(.orange)
                        .font(.title)
                        .fontWeight(.medium)
                        .sheet(isPresented: $isCreateAccountViewPresented) {
                            CreateAccountView()
                            
                        }
                    
                    //----------------
                    //Spacers
                    //----------------
                    //location 6
                    Spacer()
                    Spacer()
                    
                    //----------------
                    //Login Button
                    //----------------
                    //location 7
                    Button(action:{
                        
                        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
                            
                            if let error = error{
                                print(error)
                                email = ""
                                password = ""
                                showErrorAlert.toggle()
                            }
                            
                            if let authResult = authResult{
                                isPasswordCorrect = true
                            }
                        }//end sign in
                        
                        
                    }) {
                        Text("Login")
                            .foregroundColor(.orange)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.yellow)
                                    .foregroundColor(.black)
                                    .opacity(0.5)
                            ).padding(.horizontal)
                        
                            .alert(isPresented: $showErrorAlert, content:{
                                Alert(title: Text("Error"),
                                      message: Text("Please make sure your email and password are correct"))
                            })
                        
                    }
                    .padding()
                    .padding(.top)
                        
                    
                }//end VStack
                
                //----------------
                //location 8
                
            }//end ZStack
            
            //----------------
            //location 9
            NavigationLink(destination: HomeView(), isActive: $isPasswordCorrect){
                EmptyView()
            }
            
        }//end Navigation Stack
        //location 10
        
    }//end body
}//end loginview

#Preview {
    LoginView()
}
