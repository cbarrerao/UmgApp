//
//  Conversacion.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/18/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI
import Firebase

struct Mensaje: Codable,Identifiable, Hashable {
    var id:Int
    let mensaje:String
    let emisor: Int
    let receptor:Int
    let Fecha: Date
}


struct Conversacion: View {
    @EnvironmentObject var obj : observed
    let usuarioreceptor: Int
    let usuarioemisor: Int
    let nombreconver: String
    @State var cantidad: Int = 0
    @State var mensajes: [Mensaje] = []
    @State var mensaje: String = "" 
    let db = Firestore.firestore()
    @StateObject var dataMensajes = ModeloMensajes()
    var body: some View {
        VStack{
            //Text(String(usuarioreceptor))
            if(mensajes.count != 0){
                ScrollViewReader{ reader in
                    
                    ScrollView{
                        /*ScrollViewReader{value in
                            ForEach(mensajes){mens in
                                Text(mens.mensaje)
                            }
                        }*/
                        /*ForEach(mensajes){mens in
                            HStack{
                                if mens.emisor != self.usuarioemisor{
                                    HStack{
                                        Text(mens.mensaje)
                                            .padding()
                                            //.foregroundColor(Color.white)
                                            
                                    }.background(naranjamensajes)
                                    .cornerRadius(7.0)
                                    .padding(5)
                                    Spacer()
                                }else{
                                    Spacer()
                                    HStack{
                                        Text(mens.mensaje)
                                            .padding()
                                            //.foregroundColor(Color.white)
                                            
                                    }.background(naranjaclaromensajes)
                                    .cornerRadius(7.0)
                                    .padding(5)
                                    
                                }
                                
                            }
                            
                        }*/
                        ForEach (dataMensajes.mensajes){ msg in
                            HStack{
                                if msg.emisor == self.usuarioemisor && msg.receptor == self.usuarioreceptor{
                                    Spacer()
                                    HStack{
                                        Text(msg.mensaje)
                                            .padding()
                                            .foregroundColor(Color.white)
                                            
                                    }.background(naranjamensajes)
                                    .cornerRadius(7.0)
                                    .padding(5)
                                    
                                }else if msg.receptor == self.usuarioemisor && msg.emisor == self.usuarioreceptor{
                                    
                                    HStack{
                                        Text(msg.mensaje)
                                            .padding()
                                            .foregroundColor(Color.white)
                                            
                                    }.background(naranjaclaromensajes)
                                    .cornerRadius(7.0)
                                    .padding(5)
                                    Spacer()
                                    
                                }
                                    
                            }/*.background(naranjamensajes)
                            .cornerRadius(7.0)
                            .padding(5)*/
                            
                        }.onChange(of: dataMensajes.mensajes, perform: {value in
                            reader.scrollTo(dataMensajes.mensajes.last!.id, anchor: .bottom)
                        })
                        Spacer()
                    }
                }
                
                /*TextField("hola", text: $mensaje)
                    .modifier(limpiar(text: $mensaje))*/
            }
            HStack{
                
                MultiLineTextField(texto: $mensaje)
                    //.modifier(limpiar(text: $mensaje))
                    .frame(height: self.obj.tamano < 150 ? self.obj.tamano : 150)
                    .padding(.all,2)
                    .background(gris)
                    .cornerRadius(5.0)
                    .padding(.bottom, 5)
                Button(action: {
                    //self.mensaje = ""
                    //print(self.mensaje)
                    let fecha:Timestamp = Timestamp()
                    //let nuevomensaje:Mensaje=Mensaje(mensaje: self.mensaje, emisor:self.usuarios.codigo, receptor: self.userelegido, Fecha: fecha)
                    /*let nuevo = [
                        "Emisor": self.usuarios.codigo,
                        "Receptor": self.nombre,
                        "Fecha": self.apellido,
                        "Mensaje": self.titulo
                    ]*/
                    self.db.collection("Mensajes").addDocument(data: ["Mensaje":self.mensaje,
                                                                      "Emisor": self.usuarioemisor ,
                                                                      "Receptor": self.usuarioreceptor,
                                                                      "Fecha": fecha,
                                                                      "Estado": 0]) { (er) in
                        if(er != nil){
                            //self.mensaje = "Error al guardar datos del usuario"
                            //self.alerta = true
                        }else{
                            
                        }
                    }
                }){
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.orange)
                }
                
            }.padding()
            
        }.navigationBarTitle(String(self.nombreconver))
        .onAppear(perform: {
            db.collection("Mensajes").whereField("Receptor", isEqualTo: self.usuarioemisor).whereField("Emisor", isEqualTo: self.usuarioreceptor).order(by: "Fecha").addSnapshotListener{ (snap,err) in
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    /*self.cantidad += 1
                    let texto = i.document.get("Mensaje") as! String
                    let emisorlista = i.document.get("Emisor") as! Int
                    let receptorlista = i.document.get("Receptor") as! Int
                    let fechalista = i.document.get("Fecha") as! Timestamp
                    //print(fechalista.dateValue())
                    self.mensajes.append(Mensaje(id: self.cantidad, mensaje: texto, emisor: emisorlista,receptor: receptorlista, Fecha: fechalista.dateValue()))*/
                    if (i.document.get("Estado") as! Int == 0){
                        self.db.collection("Mensajes").document(i.document.documentID).setData(["Estado": 1], merge: true){
                            err in
                            if let err = err{
                                print(err)
                            }
                        }
                    }
                }
            }
            //print("usuario recibido \(self.usuario)")
            db.collection("Mensajes").whereField("Receptor", isEqualTo: self.usuarioreceptor).whereField("Emisor", isEqualTo: self.usuarioemisor).order(by: "Fecha").addSnapshotListener{ (snap,err) in
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    self.cantidad += 1
                    let texto = i.document.get("Mensaje") as! String
                    let emisorlista = i.document.get("Emisor") as! Int
                    let receptorlista = i.document.get("Receptor") as! Int
                    let fechalista = i.document.get("Fecha") as! Timestamp
                    //print(fechalista.dateValue())
                    self.mensajes.append(Mensaje(id: self.cantidad, mensaje: texto, emisor: emisorlista,receptor: receptorlista, Fecha: fechalista.dateValue()))
                }
            }
            db.collection("Mensajes").whereField("Emisor", isEqualTo: self.usuarioreceptor).whereField("Receptor", isEqualTo: self.usuarioemisor).order(by: "Fecha").addSnapshotListener{ (snap,err) in
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    self.cantidad += 1
                    let texto = i.document.get("Mensaje") as! String
                    let emisorlista = i.document.get("Emisor") as! Int
                    let receptorlista = i.document.get("Receptor") as! Int
                    let fechalista = i.document.get("Fecha") as! Timestamp
                    self.mensajes.append(Mensaje(id: self.cantidad, mensaje: texto, emisor: emisorlista,receptor: receptorlista, Fecha: fechalista.dateValue()))
                    self.mensajes.sort(by: { $0.Fecha < $1.Fecha }    )
                }
            }
            
        })
        
        
    }
}



/*class getConversaciones: ObservableObject {
    @Published var data1: [String] = []
    //@Published var data2: [Usuario] = []
    @Published var codigo: Int = 0
    let db = Firestore.firestore()
    init(){
        
    }
}
*/

/*struct Conversacion_Previews: PreviewProvider {
    static var previews: some View {
        Conversacion(usuario: user.id)
    }
}*/

struct limpiar: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        HStack{
            content
            Button(action: {
                self.text = ""
            }){
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.orange)
            }
        }
    }
}
