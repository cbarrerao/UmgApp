//
//  Suscripciones.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/9/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI

import Firebase

 var titulo:String = ""
 var mensaje:String = ""
 var suschechas: [String] = []


struct Suscripciones: View {
    @ObservedObject var suscripciones = getSusc()
    @State var alerta = false
    @State var escuela:String=""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                Text("Suscripciones")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Divider()
                    .frame(height: 3)
                    .background(Color.white)
                    
            }.padding()
                .background(fondonaranja)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Agroindustrial"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("agroindustrial")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Agroindustrial")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.escuela="Alimentos"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("alimentos")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Alimentos")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Biomedica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("biomedica")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Biomédica")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.escuela="Civil"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("civil")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Civil")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Civil"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("compu")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Computación")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.escuela="Electrica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("electrica")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Eléctrica")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Electronica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("electronica")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Electrónica")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.escuela="Fisica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("fisica")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Física")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Industrial"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("industrial")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Industrial")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.escuela="Matematica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("mate")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Matemática")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Mecanica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("mec")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Mecánica")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Button(action: {
                        self.escuela="Quimica"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("quimica")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Química")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        self.escuela="Sistemas"
                        btnssuscs(listapropia: suschechas, listausuario: self.suscripciones.suscripciones, escuela: self.escuela)
                        self.alerta.toggle()
                    }){
                        VStack{
                            Image("sistemas")
                                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Sistemas")
                                .foregroundColor(.black)
                        }.frame(width: 140, height: 140)
                            .background(gris)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    
                }
            }.padding()
            .alert(isPresented: $alerta){
                Alert(title:Text(titulo), message: Text(mensaje))
            }.padding(.bottom, 10)
        
        }.navigationBarTitle("Suscripciones")
        
    }
}

struct Suscripciones_Previews: PreviewProvider {
    static var previews: some View {
        Suscripciones()
    }
}

func registrosusc(escuela:String) {
    let db = Firestore.firestore()
    
    db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
        if err != nil{
            print("Error getting documents: ")
            print((err?.localizedDescription)!)
            return
        }
        let susc = snap?.get("Suscripciones") as! String
        
        db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").setData(["Suscripciones": susc+","+escuela], merge: true){
            err in
            if let err = err{
                print(err)
            }else{
                print("Se agrego la susc")
            }
        }
        
    }
}

func fncexiste(lista:[Suscripcion],escuela:String)->Bool{
    lista.contains{ susc in
        if( susc.nombre == escuela){
            return true
        }else{
            return false
        }
    }
}

func fncexiste2(lista:[String],escuela:String)->Bool{
    lista.contains{ susc in
        if( susc == escuela){
            return true
        }else{
            return false
        }
    }
}

func btnssuscs(listapropia:[String],listausuario:[Suscripcion],escuela:String){
    let existe = fncexiste(lista: listausuario, escuela: escuela)
    let existe2 = fncexiste2(lista: listapropia, escuela: escuela)
    if( existe == false && existe2 == false){
        suschechas.append(escuela)
        titulo = "SUSCRIPCIÓN EXITOSA"
        mensaje = "La suscripción de \(escuela) se realizó con éxito y ahora podrá ver los anuncios de esta categoría en el apartado de Anuncios"
        registrosusc(escuela: escuela)
        
    }else{
        titulo = "SUSCRIPCIÓN REPETIDA"
        mensaje = "La suscripción de \(escuela) no se realizó con éxito ya que ya existe"
    }
}
