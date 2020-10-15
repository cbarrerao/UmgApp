//
//  Inicios.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/9/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI

import Firebase

struct Inicio: View {
    
    
    @State var seleccion = 0
    
    var body: some View {
        
        
        
        ZStack(alignment: .bottom){
            fondogris.edgesIgnoringSafeArea(.bottom)
            //Color.red.edgesIgnoringSafeArea(.all)
            VStack{
                if self.seleccion == 0 {
                    
                    Perfil()
                }else if self.seleccion ==  1{
                    AnunciosIng()
                }else if self.seleccion ==  2{
                    Suscripciones()
                }else if self.seleccion ==  3{
                    Mensajes()
                }
                
            }
            
            barraFlotante(seleccion: self.$seleccion)
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
            /*.navigationBarItems(leading: Button(action: {
        do{
            try Auth.auth().signOut()
            self.presentationMode.wrappedValue.dismiss()
        }catch let error{
            print(error)
        }
        
        }){
            navCerrarSesion()
        })*/
    }
}

struct Inicio_Previews: PreviewProvider {
    static var previews: some View {
        Inicio()
    }
}

struct barraFlotante:View {
    @Environment (\.presentationMode) var presentationMode
    @StateObject var dataMensajes = ModeloMensajes()
    @Binding var seleccion : Int
    @State var expandida = false
    var body: some View{
        HStack{
            
            HStack{
                
                if !self.expandida{
                    
                    Button(action: {
                        self.expandida.toggle()
                    }){
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            //.padding(.all,1)
                    }
                }else{
                   // Spacer()
                    Button(action: {
                        self.seleccion = 0
                    }){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(self.seleccion == 0 ? .orange:.black)
                            //.padding(.horizontal)
                    }
                    Spacer(minLength: 5)
                    Button(action: {
                        self.seleccion = 1
                    }){
                        Image(systemName: "folder.circle.fill")
                        .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(self.seleccion == 1 ? .orange:.black)
                            //.padding(.horizontal)
                
                    }
                    Spacer(minLength: 5)
                    Button(action: {
                        self.seleccion = 2
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(self.seleccion == 2 ? .orange:.black)
                            //.padding(.horizontal)
                    }
                    
                    Spacer(minLength: 5)
                    ZStack{
                        Button(action: {
                            self.seleccion = 3
                        }){
                            Image(systemName: "message.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(self.seleccion == 3 ? .orange:.black)
                                //.padding(.horizontal)
                        }
                        if (self.dataMensajes.mensajesnuevos > 0){
                            Text("\(self.dataMensajes.mensajesnuevos)").padding(6).background(Color.red).clipShape(Circle())
                                .foregroundColor(Color.white).offset(x: 12, y: -15)
                        }
                        
                    }
                    
                    
                    Spacer(minLength: 5)
                    Button(action: {
                        do{
                            try Auth.auth().signOut()
                            print("se cerro la sesion")
                            //ContentView()
                            self.presentationMode.wrappedValue.dismiss()
                        }catch let error{
                            print(error)
                        }
                    }){
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(self.seleccion == 4 ? .orange:.black)
                            //.padding(.horizontal)
                    }
                    
                    
                }
            }.padding(.vertical,self.expandida ? 15:8)
                .padding(.horizontal,self.expandida ? 15:8)
                .background(Color("Fondo"))
                .clipShape(Capsule())
                .padding(10)
                .onLongPressGesture{
                    self.expandida.toggle()
            }.animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
            Spacer(minLength: 0)
            
        }
        
    }
}
