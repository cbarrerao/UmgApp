//
//  ContentView.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/9/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI
import Firebase
let gris = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)
let grisclaro = Color(red: 165/255.0, green: 165/255.0, blue: 165/255.0)
let azulmarino = Color(red: 37/255.0, green: 40/255.0, blue: 80/255.0)
let amarillo = Color(red: 246/255.0, green: 246/255.0, blue: 101/255.0)
let verde = Color(red: 138/255.0, green: 246/255.0, blue: 236/255.0)
let grisoscuro = Color(red: 96/255.0, green: 104/255.0, blue: 102/255.0)
let rojofondo = Color(red: 188/255.0, green: 44/255.0, blue: 2/255.0)
let naranjafondo = Color(red: 247/255.0, green: 147/255.0, blue: 30/255.0)
let naranjaclaromensajes = Color(red: 247/255.0, green: 147/255.0, blue: 30/255.0)
let naranjamensajes = Color(red: 241/255.0, green: 90/255.0, blue: 36/255.0)
let fondogris = LinearGradient(gradient: .init(colors: [.white,grisclaro]), startPoint: .top, endPoint: .bottom)
let fondonaranja = LinearGradient(gradient: .init(colors: [rojofondo,naranjafondo]), startPoint: .top, endPoint: .bottom)

struct ContentView: View {
    @ObservedObject var sedes = getSedes()
    @State var correo:String = ""
    @State var contra:String = ""
    @State var titulo:String = ""
    @State var mensaje: String = ""
    @State var alerta = false
    @State var alertacontra = false
    @State var movimiento = false
    @State var movregistro = false
    @State var vista = 0
    
    var body: some View{
        
        //ZStack{
            //Image("inicio")
            NavigationView{
                ZStack{
                    fondogris.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        HStack{
                            Spacer()
                            VStack{
                                Image("inicio")
                                    .resizable()
                                    .frame(width: 150, height: 170, alignment: .center)
                                    .padding(.top,120)
                                    //.aspectRatio(contentMode: .fill)
                                Text("Inicia Sesión")
                                    .font(.title)
                                    .foregroundColor(.white)
                                
                               //lbltitulo()
                            }
                            Spacer()
                        }.padding()
                        .background(Image("pestana").resizable())
                        
                        /*VStack{
                            Spacer()
                            lbltitulo()
                        }.padding()
                            .background(Image("pestana").resizable())*/
                        //logo()
                        
                        VStack{
                            HStack{
                                Image("user")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .leading)
                                    
                                txtcorreo(correo: $correo)
                                
                            }.padding(.all,8)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding(.bottom, 10)
                            HStack{
                                Image("contra")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .leading)
                                    
                                txtcontra(contra: $contra)
                                
                            }.padding(.all,8)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding(.bottom, 10)
                            
                            
                            NavigationLink(destination: Inicio(), isActive: $movimiento){
                                Text("")
                            }
                            Button(action: {
                                Auth.auth().signIn(withEmail: self.correo, password: self.contra) { (result, error) in
                                    if let error = error {
                                        self.alerta = true
                                        print("Failed to sign in",error.localizedDescription)
                                        return
                                    }
                                    self.movimiento = true
                                    self.vista = 1
                                    print("entro correcto")
                                }
                            }){
                                btnlogin()
                            }.alert(isPresented: $alerta){
                                Alert(title:Text("Error al ingresar"), message: Text("Contrase;a y/o usuario incorrecto"))
                            }
                            
                            Button(action: {
                                self.movregistro.toggle()
                                //print(self.sedes)
                            }){
                                    
                                btnRegistro()
                            }.sheet(isPresented: $movregistro){
                                Registro()
                            }
                            
                            Button(action: {
                                if(self.correo.isEmpty){
                                    self.titulo = "Falta informacion"
                                    self.mensaje = "Debe de ingresar el correo"
                                    self.alertacontra = true
                                }else{
                                    self.alertacontra = true
                                    Auth.auth().sendPasswordReset(withEmail: self.correo) { (error) in
                                        if(error != nil){
                                            self.titulo = "ERROR"
                                            self.mensaje = "No se pudo enviar el correo para restablecer contrase;a"
                                            self.alerta = true
                                        }else{
                                            self.titulo = "EXITO"
                                            self.mensaje = "El correo fue enviado con exito al correo establecido"
                                            self.alerta = true
                                        }
                                    }
                                    
                                }}){
                                    btnrecuperar()
                            }.alert(isPresented: $alertacontra){
                                Alert(title:Text(titulo), message: Text(mensaje))
                            }
                            Text("")
                            .padding()
                            .frame(width: 220, height: 10)
                            .padding(.bottom,10)
                            
                        }.padding()
                       
                    }.onAppear(){
                        if Auth.auth().currentUser == nil {
                            print("no hay usuario")
                            
                        }else{
                            print("si hay\(Auth.auth().currentUser?.uid ?? "")")
                            self.movimiento = true
                            self.vista = 1
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                
                    
            }
    
    }
    //}
}

struct lbltitulo:View {
    var body: some View {
        VStack{
            Text("UMG APP")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct logo: View {
    var body: some View {
        Image("logoumg")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 10)
    }
}

struct btnlogin: View {
    var body: some View {
        Text("Login")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 40)
            .background(LinearGradient(gradient: .init(colors: [.orange,.red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(35.0)
            .padding(.bottom,10)
    }
}

struct txtcorreo: View {
    @Binding var correo:String
    var body: some View {
        TextField("Correo", text: $correo)
            
    }
}

struct txtcontra: View {
    @Binding var contra:String
    var body: some View {
        SecureField("Contraseña",text: $contra)
            
    }
}

struct btnRegistro: View {
    var body: some View {
        Text("Registrar")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 40)
            .background(LinearGradient(gradient: .init(colors: [.orange,.red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(35.0)
            .padding(.bottom, 10)
    }
}

struct btnrecuperar: View {
    var body: some View {
        Text("Recuperar Contraseña")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 40)
            .background(LinearGradient(gradient: .init(colors: [.orange,.red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(35.0)
            .padding(.bottom,120)
    }
}

class getSedes:ObservableObject{
    @Published var data = [Sede]()
    let db = Firestore.firestore()
    init(){
        db.collection("Sedes").addSnapshotListener{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                let id = i.document.documentID
                let nombre = i.document.get("Nombre") as! String
                self.data.append(Sede(id: id, nombre: nombre))
            }
        }
    }
}

