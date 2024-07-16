//
//  CreateAccountView.swift
//  ComicsApp
//
//  Created by Kevin Sanchez on 7/13/24.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            Image("back3")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                

                
                //----------------------
                //location 1
                Text("New Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.orange)
                
                Spacer()
                
                //----------------------
                //Email field
                //----------------------
                //location 2
                
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
                    
                }.padding()
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
                
                
                //----------------------
                //Password field
                //----------------------
                //location 3
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(.orange)
                    TextField("Password", text: $password)
                        .foregroundColor(.gray)
                        .font(.title)
                        .fontWeight(.bold)
                    
                }.padding()
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
                
                
                //----------------------
                //Cancel Create account button
                //----------------------
                //location 4
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .foregroundColor(.orange)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.red)
                                    .foregroundColor(.black)
                                    .opacity(0.5)
                            ).padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    //---------------------------------
                    
                    Button(action: {
                        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
                            
                            if let error = error{
                                print(error)
                                
                                return
                            }
                            
                            if let authResult = authResult{
                                print("\(authResult.user.uid)")
                            }
                            
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Submit")
                            .foregroundColor(.green)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.green)
                                    .foregroundColor(.black)
                                    .opacity(0.5)
                            ).padding(.horizontal)
                    }
                    
                    Spacer()
                    
                }//end HStack
                
                
                
                //----------------------
                //location 5
                
                Spacer()
                Spacer()

                
                
            }//end VStack
            
            
        }
        
        
        
    }//end body
}//end createview

#Preview {
    CreateAccountView()
}
