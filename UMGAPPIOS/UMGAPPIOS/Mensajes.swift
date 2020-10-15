//
//  Mensajes.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/14/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI
import Firebase



struct Mensajes: View {
    @ObservedObject var usuarios = getUsers()
    @ObservedObject var mensajes = getMensajes()
    @State var movnuevomensaje = false
    //@State var boleana:Bool
    var body: some View {
     
        VStack{
            VStack{
                HStack{
                    //Spacer()
                    Text("Mensajes")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    Spacer()
                    Button(action: {
                        self.movnuevomensaje.toggle()
                    }){
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                        Image(systemName: "message.fill")
                            .resizable()
                            .frame(width: 20, height: 20)	
                            .foregroundColor(.white)
                    }.sheet(isPresented: $movnuevomensaje){
                        NuevoMensaje()
                    }
                }
                Divider()
                    .frame(height: 3)
                    .background(Color.white)
            }.padding()
                .background(fondonaranja)
            NavigationView{
                List(self.mensajes.data1){ user in
                    
                    NavigationLink(destination: Conversacion(usuarioreceptor: user.id, usuarioemisor: self.mensajes.codigo, nombreconver: user.nombre)){
                        Text("\(user.nombre) \(user.cant)")
                    }
                
                }
            }.navigationBarHidden(true)
            
            /*if self.mensajes.data1.count != 0{
               ScrollView(.vertical, showsIndicators: false){
                    ForEach(self.mensajes.data1){ i in
                        Text("\(i.id) \(i.nombre)")
                        
                    }
                    ForEach(self.mensajes.data2){ j in
                        
                        Text("\(j.id) \(j.nombre)")
                    }
                }
            }*/
        }
    }
}

struct Mensajes_Previews: PreviewProvider {
    static var previews: some View {
        Mensajes()
    }
}

class getUsers: ObservableObject {
    @Published var data: [Usuario] = []
    @Published var codigo: Int = 0
    let db = Firestore.firestore()
    init(){
        self.db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            self.codigo = Int(snap?.get("Codigo") as! String) ?? 0
            let cargo = snap?.get("Cargo") as! String
            if (cargo == "1"){
                self.db.collection("usuarios").addSnapshotListener{ (snap,err) in
                    if err != nil{
                        print("Error getting documents: ")
                        print((err?.localizedDescription)!)
                        return
                    }
                    for i in snap!.documentChanges{
                        let codigo = Int(i.document.get("Codigo") as! String) ?? 0
                        let nombre = i.document.get("Nombres") as! String
                        let apellido = i.document.get("Apellidos") as! String
                        let nombrecomp = nombre+" "+apellido
                        self.data.append(Usuario(id: codigo, nombre: nombrecomp))
                    }
                }
            }else{
                self.db.collection("usuarios").whereField("Cargo", isEqualTo: "1").addSnapshotListener{ (snap,err) in
                    if err != nil{
                        print("Error getting documents: ")
                        print((err?.localizedDescription)!)
                        return
                    }
                    for i in snap!.documentChanges{
                        let codigo = Int(i.document.get("Codigo") as! String) ?? 0
                        let nombre = i.document.get("Nombres") as! String
                        let apellido = i.document.get("Apellidos") as! String
                        let nombrecomp = nombre+" "+apellido
                        self.data.append(Usuario(id: codigo, nombre: nombrecomp))
                    }
                }
            }
            //print("id \(self.data) ")
        }
        /*db.collection("usuarios").whereField("Cargo", isEqualTo: "1").addSnapshotListener{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return	
            }
            for i in snap!.documentChanges{
                let codigo = Int(i.document.get("Codigo") as! String) ?? 0
                let nombre = i.document.get("Nombres") as! String
                let apellido = i.document.get("Apellidos") as! String
                let nombrecomp = nombre+" "+apellido
                self.data.append(Usuario(id: codigo, nombre: nombrecomp))
            }
        }
        self.db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            self.codigo = Int(snap?.get("Codigo") as! String) ?? 0
            //print("id \(self.data) ")
        }*/
    }
}

class getMensajes: ObservableObject {
    @Published var data1: [UsuarioConv] = []
    //@Published var data2: [Usuario] = []
    @Published var codigo: Int = 0
    let db = Firestore.firestore()
    init(){
        db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            self.codigo = Int(snap?.get("Codigo") as! String) ?? 0
            self.db.collection("Mensajes").addSnapshotListener{ (snap,err) in
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    let codreceptor = i.document.get("Receptor") as! Int 
                    let codemisor = i.document.get("Emisor") as! Int
                    if (codreceptor == self.codigo || codemisor == self.codigo){
                        var buscarusuario = 0
                        if (codemisor == self.codigo){
                            buscarusuario = codreceptor
                        }else if (codreceptor == self.codigo){
                            buscarusuario = codemisor
                        }
                        
                        self.db.collection("usuarios").whereField("Codigo", isEqualTo: String(buscarusuario)).addSnapshotListener{ (snap2,err2) in
                            if err2 != nil{
                                print("Error getting documents: ")
                                print((err?.localizedDescription)!)
                                return
                            }
                            for j in snap2!.documentChanges{
                                let nombremensaje = j.document.get("Nombres") as! String
                                let apellidomensaje = j.document.get("Apellidos") as! String
                                var nuevousuario = UsuarioConv(id: buscarusuario, nombre: nombremensaje+" "+apellidomensaje, cant: 0)
                                if (userAgregado(lista: self.data1, usuario: nuevousuario) == false ){
                                    
                                    self.db.collection("Mensajes").whereField("Emisor", isEqualTo: nuevousuario.id).whereField("Receptor", isEqualTo: self.codigo).whereField("Estado", isEqualTo: 0).addSnapshotListener{ (snap3,err3) in
                                        if err3 != nil{
                                            print("Error getting documents: ")
                                            print((err?.localizedDescription)!)
                                            return
                                        }
                                        for _ in snap3!.documentChanges{
                                            nuevousuario.cant += 1
                                            print("si entro")
                                        }
                                    }
                                    self.data1.append(nuevousuario)
                                }
                                
                            }
                        }
                        
                    }
                    
                    
                    //print("si se va agregar")
                    /*self.db.collection("usuarios").whereField("Codigo", isEqualTo: String(codreceptor)).addSnapshotListener{ (snap2,err2) in
                        if err2 != nil{
                            print("Error getting documents: ")
                            print((err?.localizedDescription)!)
                            return
                        }
                        for i in snap2!.documentChanges{
                            let nombremensaje = i.document.get("Nombres") as! String
                            let apellidomensaje = i.document.get("Apellidos") as! String
                            let nuevousuario = Usuario(id: codreceptor, nombre: nombremensaje+" "+apellidomensaje)
                            if (userAgregado(lista: self.data1, usuario: nuevousuario) == false ){
                                self.data1.append(nuevousuario)
                            }
                            
                        }
                    }
                    print("id \(self.codigo) \(self.data1.count)")*/
                    
                }
                
            }
            /*self.db.collection("Mensajes").whereField("Receptor", isEqualTo: self.codigo).addSnapshotListener{ (snap,err) in
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    let codemisor = i.document.get("Emisor") as! Int
                    print("si se va agregar")
                    self.db.collection("usuarios").whereField("Codigo", isEqualTo: String(codemisor)).addSnapshotListener{ (snap2,err2) in
                        if err2 != nil{
                            print("Error getting documents: ")
                            print((err?.localizedDescription)!)
                            return
                        }
                        for i in snap2!.documentChanges{
                            let nombremensaje = i.document.get("Nombres") as! String
                            let apellidomensaje = i.document.get("Apellidos") as! String
                            print("si se va agregar 2")
                            self.data2.append(Usuario(id: codemisor, nombre: nombremensaje+" "+apellidomensaje))
                        }
                    }
                    print("id \(self.codigo) \(self.data1.count)")
                    
                }
            }*/
            
        }
                
    }
}

func userAgregado(lista:[UsuarioConv],usuario:UsuarioConv)->Bool{
    
    lista.contains{ user1 in
        if( user1.id == usuario.id){
            return true
        }else{
            return false
        }
    }
}
