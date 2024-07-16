//
//  HomeView.swift
//  ComicsApp
//
//  Created by Kevin Sanchez on 7/13/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        ZStack{
            Image("back")
                .resizable()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    HomeView()
}
