//
//  Perfil.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/9/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI

import Firebase


struct Clase: Identifiable {
    var id: String
    let clase,tipo:String
    let horario: [String]
    let dia: [String]
}

struct Perfil: View {
    //@ObservedObject var suscripciones = getSusc()
    @ObservedObject var clases = getClases()
    @State var existe: Int = 0
    @State var expandidoMat: Bool = false
    @State var expandidoVes: Bool = false
    @State var expandidoMix: Bool = false
    @State var contador: Int = 0
        //@State var color = 0
    var body: some View {
        VStack{
            
            
            if self.clases.clases.count != 0{
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        
                        Text("Carga Académica")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        Divider()
                            .frame(height: 3)
                            .background(Color.white)
                            
                        VStack(alignment: .leading, spacing: 6){
                            HStack{
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                                Spacer()
                                VStack{
                                    HStack{
                                        Text("Nombre:").bold()
                                        Text("\(self.clases.nombre) \(self.clases.apellido)")
                                        Spacer()
                                    }.padding()
                                        .background(gris)
                                        
                                    HStack{
                                        Text("Título:").bold()
                                        Text("\(self.clases.titulo)")
                                        Spacer()
                                    }.padding()
                                    HStack{
                                        Text("Código:").bold()
                                        Text("\(String(self.clases.id))")
                                        Spacer()
                                    }.padding()
                                        .background(gris)
                                        
                                }
                            }
                        }.padding()
                            .background(Color.white)
                            .cornerRadius(5.0)
                            .padding(.bottom, 10)
                            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                            .shadow(radius: 8)
                    }.padding()
                        .background(fondonaranja)
                        .edgesIgnoringSafeArea(.all)
                    
                    
                    VStack{
                        if (self.clases.mat == 1){
                            VStack(alignment: .leading, spacing: 6){
                                HStack{
                                    Image("matutino")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.black)
                                        .padding(.horizontal)
                                    Text("Matutino")
                                    Spacer()
                                    Button(action: {
                                            self.expandidoMat.toggle()
                                        }){
                                            Image(systemName: "chevron.down")
                                            .resizable()
                                                .frame(width: 15, height: 10)
                                                .foregroundColor(.black)
                                                .padding(.horizontal)
                                        }
                                }
                                if self.expandidoMat{
                                    ForEach(self.clases.clases){ i in
                                        if(i.tipo.elementsEqual("Matutino")){
                                            VStack{
                                                HStack(alignment: .top){
                                                    Text(i.clase).frame(maxHeight: .infinity, alignment: .top)
                                                    Spacer()
                                                    VStack(alignment: .leading){
                                                        ForEach(0 ..< i.horario.count){
                                                            Text(i.dia[$0]).fontWeight(.bold)
                                                            Text(i.horario[$0]).padding(.bottom,2)
                                                        }
                                                    }
                                                }
                                            }.padding()
                                        }
                                    }
                                }
                            }.padding()
                                .background(Color.white)
                                .cornerRadius(5.0)
                                .padding(.bottom, 20)
                                
                                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                        }
                        if (self.clases.ves == 1){
                            VStack(alignment: .leading, spacing: 6){
                                HStack{
                                    Image("vespertino")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        
                                        .padding(.horizontal)
                                    Text("Vespertino")
                                    Spacer()
                                    Button(action: {
                                            self.expandidoVes.toggle()
                                        }){
                                            Image(systemName: "chevron.down")
                                            .resizable()
                                                .frame(width: 15, height: 10)
                                                .foregroundColor(.black)
                                                .padding(.horizontal)
                                        }
                                }
                                if self.expandidoVes{
                                    ForEach(self.clases.clases){ i in
                                        if(i.tipo.elementsEqual("Vespertino")){
                                            VStack{
                                                HStack(alignment: .top){
                                                    Text(i.clase).frame(maxHeight: .infinity, alignment: .top)
                                                    Spacer()
                                                    VStack(alignment: .leading){
                                                        ForEach(0 ..< i.horario.count){
                                                            Text(i.dia[$0]).fontWeight(.bold)
                                                            Text(i.horario[$0]).padding(.bottom,2)
                                                        }
                                                    }
                                                }
                                            }.padding()
                                        }
                                    }
                                }
                                
                            }.padding()
                                .background(Color.white)
                                .cornerRadius(5.0)
                                .padding(.bottom, 20)
                                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                        }
                        if(self.clases.mix == 1){
                            VStack(alignment: .leading, spacing: 6){
                                HStack{
                                    Image("mixto")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        
                                        .padding(.horizontal)
                                    Text("Mixto")
                                    Spacer()
                                    Button(action: {
                                            self.expandidoMix.toggle()
                                        }){
                                            Image(systemName: "chevron.down")
                                            .resizable()
                                                .frame(width: 15, height: 10)
                                                .foregroundColor(.black)
                                                .padding(.horizontal)
                                        }
                                }
                                if self.expandidoMix{
                                    ForEach(self.clases.clases){ i in
                                        if(i.tipo.elementsEqual("Mixto")){
                                            VStack{
                                                HStack(alignment: .top){
                                                    Text(i.clase).frame(maxHeight: .infinity, alignment: .top)
                                                    Spacer()
                                                    VStack(alignment: .leading){
                                                        ForEach(0 ..< i.horario.count){
                                                            Text(i.dia[$0]).fontWeight(.bold)
                                                            Text(i.horario[$0]).padding(.bottom,2)
                                                        }
                                                    }
                                                }
                                            }.padding()
                                        }
                                    }
                                }
                                
                            }.padding()
                                .background(Color.white)
                                .cornerRadius(5.0)
                                .padding(.bottom, 10)
                                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                        }
                    }.padding()
                       
                }//.padding()
                .edgesIgnoringSafeArea(.bottom)
            }
        }.navigationBarTitle("PERFIL")
        
        
    }
}

struct Perfil_Previews: PreviewProvider {
    static var previews: some View {
        Perfil()
    }
}





class getClases: ObservableObject {
    @Published var clases = [Clase]()
    var clas:String = ""
    var div: [Substring] = []
    var horarioclase:[String] = []
    var diaclase:[String] = []
    var id:Int = 0
    var apellido:String = ""
    var nombre: String = ""
    var titulo:String = ""
    var mat: Int = 0
    var ves: Int = 0
    var mix: Int = 0
    let db = Firestore.firestore()
    init(){
        db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            self.id = Int(snap?.get("Codigo") as! String) ?? 0
            self.nombre = snap?.get("Nombres") as! String
            self.apellido = snap?.get("Apellidos") as! String
            self.titulo = snap?.get("Titulo") as! String
            if(snap?.get("Suscripciones")as! String == "Gen"){
                self.db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").setData(["Suscripciones": "General"], merge: true){
                    err in
                    if let err = err{
                        print(err)
                    }
                }
            }
            self.db.collection("Asignacion").whereField("Catedratico", isEqualTo: self.id).addSnapshotListener { (snap, err) in
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documentChanges{
                    let id = i.document.documentID
                    let clase = i.document.get("Curso") as! String
                    let tipohorario = i.document.get("TipoHorario") as! String
                    if (tipohorario.elementsEqual("Matutino") && self.mat == 0){
                        self.mat = 1
                    }
                    if (tipohorario.elementsEqual("Vespertino") && self.ves == 0){
                        self.ves = 1
                    }
                    if (tipohorario.elementsEqual("Mixto") && self.mix == 0){
                        self.mix = 1
                    }
                    self.clas = i.document.get("Hora") as? String ?? ""
                    self.div = self.clas.split(separator: ";")
                    self.div.forEach({
                        self.horarioclase.append(String($0))
                        print($0)
                    })
                    self.clas = i.document.get("Dia") as? String ?? ""
                    self.div = self.clas.split(separator: ";")
                    self.div.forEach({
                        self.diaclase.append(String($0))
                        print($0)
                    })
                    self.clases.append(Clase(id: id, clase: clase, tipo: tipohorario, horario: self.horarioclase, dia: self.diaclase))
                    self.horarioclase.removeAll()
                }
                     
            }
        }
    }
}
