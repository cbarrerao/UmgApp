//
//  Registro.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/9/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI

import Firebase

struct Sede: Identifiable {
    var id: String
    
    let nombre : String
}

struct Registro: View {
    @ObservedObject var sedes = getSedes()
    
    @State var correo:String = ""
    @State var codigo:String = ""
    @State var nombre:String = ""
    @State var apellido:String = ""
    @State var titulo:String = ""
    @State var contra:String = ""
    @State var mensaje:String = ""
    @State var confcontra:String = ""
    @State var alerta = false
    @State var movimiento = false
    @State var found = false
    @State var sedeelegida = ""
    
    //@State var sedeseleccionada = ""
    @Environment (\.presentationMode) var presentationMode
    
    let db = Firestore.firestore()
    
    var body: some View{
        ZStack{
            fondogris.edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical){
                VStack{
                    Text("Registro")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    Divider()
                        .frame(height: 3)
                        .background(Color.white)
                        
                }.padding()
                    .background(fondonaranja)
                    //.edgesIgnoringSafeArea(.all)
               VStack{
                    VStack{
                        //Titulo()
                        txtCorreo(correo: $correo)
                        txtCodigo(codigo: $codigo)
                        txtNombres(nombre: $nombre)
                        txtApellidos(apellido: $apellido)
                        txtTitulo(titulo: $titulo)
                        VStack{
                            Text("Sede Principal                                                         ")
                                .padding()
                                .background(gris)
                                .foregroundColor(grisclaro)
                                .cornerRadius(5.0)
                                .padding(.bottom,-30)
                            Picker(selection: $sedeelegida, label: Text("")){
                                ForEach(self.sedes.data){i in
                                    Text(i.nombre).tag(i.id)
                                    
                                }
                            }.background(gris)
                                .cornerRadius(5.0)
                                .padding(.bottom,5)
                        }
                                            
                    }
                    VStack{
                        txtContra(contra: $contra)
                        txtConfcontra(confcontra: $confcontra)
                        NavigationLink(destination: ContentView(), isActive: $movimiento){
                            Text("")
                        }
                        Button(action: {
                            
                            
                            if(self.correo.isEmpty){
                                self.mensaje = "Correo vacio \(self.sedeelegida)"
                                self.alerta = true
                            }else if(self.codigo.isEmpty){
                                self.mensaje = "Codigo de catedratico vacio"
                                self.alerta = true
                            }else if(self.nombre.isEmpty){
                                self.mensaje = "Nombre vacio"
                                self.alerta = true
                            }else if(self.apellido.isEmpty){
                                self.mensaje = "Apellido vacio"
                                self.alerta = true
                            }else if(self.titulo.isEmpty){
                                self.mensaje = "Titulo vacio"
                                self.alerta = true
                            }else if(self.contra.isEmpty){
                                self.mensaje = "Contra vacia"
                                self.alerta = true
                            }else if(self.confcontra.isEmpty){
                                self.mensaje = "Confirmacion de contrase;a vacia"
                                self.alerta = true
                            }else if(self.sedeelegida.elementsEqual("")){
                                self.mensaje = "Debe elegir una sede principal"
                                self.alerta = true
                            }else{
                                if(self.correo.hasSuffix("@miumg.edu.gt")){
                                    if(self.contra.count<6){
                                        self.mensaje = "La contrase;a debe tener al menos 6 caracteres"
                                        self.alerta = true
                                    }else{
                                        if(self.confcontra.elementsEqual(self.contra)){
                                            let codigoint = Int(self.codigo) ?? 0
                                            self.db.collection("codigoscat").whereField("codigo", isEqualTo: codigoint).addSnapshotListener { (snap, err) in
                                                var cargo:String = ""
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    for document in snap!.documentChanges {
                                                        self.found = true
                                                        cargo = String(document.document.get("cargo") as! Int)
                                                        //print("\(document.documentID) => \(document.data())")
                                                    }
                                                }
                                                if(self.found){
                                                    //AQUI VA LO DE GUARDAR
                                                    Auth.auth().createUser(withEmail: self.correo, password: self.contra) { (resultado, error) in
                                                        if error != nil{
                                                            self.mensaje = "Error al registrar usuario"
                                                            self.alerta = true
                                                        }else{
                                                            let usuario = Auth.auth().currentUser
                                                            
                                                            let nuevo = [
                                                                "Codigo": self.codigo,
                                                                "Nombres": self.nombre,
                                                                "Apellidos": self.apellido,
                                                                "Titulo": self.titulo,
                                                                "Sede": self.sedeelegida,
                                                                "Cargo": cargo,
                                                                "Suscripciones": "Gen"
                                                            ]
                                                            self.db.collection("usuarios").document(usuario!.uid).setData(nuevo) { (er) in
                                                                if(er != nil){
                                                                    self.mensaje = "Error al guardar datos del usuario"
                                                                    self.alerta = true
                                                                }else{
                                                                    self.presentationMode.wrappedValue.dismiss()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }else{
                                                    self.mensaje = "El codigo ingresado no existe"
                                                    self.alerta = true
                                                }
                                            }
                                        }else{
                                            self.mensaje = "Las contrase;as no coinciden"
                                            self.alerta = true
                                        }
                                    }
                                }else{
                                    self.mensaje = "El correo debe ser de la universidad"
                                    self.alerta = true
                                }
                            }
                        }){
                            btnRegistrar()
                        }.alert(isPresented: $alerta){
                            Alert(title:Text("ERROR"), message: Text(mensaje))
                        }.padding(.bottom, 10)
                    }
               }.padding(.all,10)
               
            }
        }
    }
    
    
}



struct Registro_Previews: PreviewProvider {
    static var previews: some View {
        Registro()
    }
}

struct Titulo: View {
    var body: some View {
        VStack{
            Text("Registro")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
        }
    }
}

struct txtCorreo: View {
    @Binding var correo:String
    var body: some View {
        TextField("Correo", text: $correo)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct txtCodigo: View {
    @Binding var codigo:String
    var body: some View {
        TextField("Codigo Catedratico", text: $codigo)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct txtNombres: View {
    @Binding var nombre:String
    var body: some View {
        TextField("Nombres", text: $nombre)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct txtApellidos: View {
    @Binding var apellido:String
    var body: some View {
        TextField("Apellidos", text: $apellido)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct txtTitulo: View {
    @Binding var titulo:String
    var body: some View {
        TextField("Titulo", text: $titulo)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct txtContra: View {
    @Binding var contra:String
    var body: some View {
        SecureField("Contrase;a", text: $contra)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct txtConfcontra: View {
    @Binding var confcontra:String
    var body: some View {
        SecureField("Confirmar contra", text: $confcontra)
            .padding()
            .background(gris)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct btnRegistrar: View {
    var body: some View {
        Text("Registrar")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 40)
            .background(LinearGradient(gradient: .init(colors: [.orange,.red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(35.0)
            .padding(.bottom,20)
            
    }
}
