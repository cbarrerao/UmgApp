//
//  NuevoMensaje.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/14/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI
import Firebase

struct Usuario: Identifiable {
    var id: Int
    
    let nombre : String
    
}

struct UsuarioConv: Identifiable {
    var id: Int
    
    let nombre : String
    var cant: Int
}


struct NuevoMensaje: View {
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var obj : observed
    @ObservedObject var usuarios = getUsers()
    @State var codigousuario: Int = 0
    @State var userelegido:Int = 0
    @State var mensaje:String = ""
    let db = Firestore.firestore()
    var body: some View {
        ZStack{
            fondogris.edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical){
                VStack{
                    Text("Nuevo Mensaje")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    Divider()
                        .frame(height: 3)
                        .background(Color.white)
                        
                }.padding()
                    .background(fondonaranja)
            }
            VStack{
                HStack{
                    Text("Elija Destinatario")
                    Spacer()
                }.padding()
                    .background(gris)
                    .foregroundColor(grisclaro)
                    .cornerRadius(5.0)
                    .padding(.bottom,-20)
                
                Picker(selection: $userelegido, label: Text("")){
                    ForEach(self.usuarios.data){i in
                        Text(i.nombre).tag(i.id)
                        
                    }
                }.background(gris)
                    .cornerRadius(5.0)
                    .padding(.bottom,5)
                HStack{
                    MultiLineTextField(texto: $mensaje)
                        .frame(height: self.obj.tamano < 150 ? self.obj.tamano : 150)
                        .padding(.all,2)
                        .background(gris)
                        .cornerRadius(5.0)
                        .padding(.bottom, 5)
                    Button(action: {
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
                                                                          "Emisor": self.usuarios.codigo ,
                                                                          "Receptor": self.userelegido,
                                                                          "Fecha": fecha,
                                                                          "Estado": 0]) { (er) in
                            if(er != nil){
                                //self.mensaje = "Error al guardar datos del usuario"
                                //self.alerta = true
                            }else{
                                //self.mensaje = "SE GUARGO BIEN"
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }){
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.orange)
                    }
                    
                }.padding()
                
            }
        }
        
    }
}

struct MultiLineTextField:UIViewRepresentable {
    @Binding var texto: String
    func makeCoordinator() -> Coordinator {
        return MultiLineTextField.Coordinator(parent1: self)
    }
    
    
    @EnvironmentObject var obj : observed
    func makeUIView(context: UIViewRepresentableContext<MultiLineTextField>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 15)
        view.text = "Escriba su mensaje..."
        view.textColor = UIColor.black.withAlphaComponent(0.35)
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        self.obj.tamano = view.contentSize.height
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTextField>) {
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent:MultiLineTextField
        init(parent1: MultiLineTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .black
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.texto = textView.text
            self.parent.obj.tamano = textView.contentSize.height
        }
    }
}



class observed: ObservableObject {
    @Published var tamano : CGFloat = 0
}

