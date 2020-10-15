//
//  AnunciosIng.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/9/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
//import FirebaseFirestore


struct Anuncio: Identifiable {
    var id: String
    
    let titulo, mensaje,  imagen, fecha, icono : String
}

struct Suscripcion: Identifiable {
    var id: String
    
    let nombre : Substring
}
        
struct AnunciosIng: View {
    @ObservedObject var suscripciones = getSusc()
    @State var suscelegida = ""
    @ObservedObject var anuncios = getAnuncios(ruta: "Anuncios")
    @ObservedObject var anunciosing = getAnuncios(ruta: "Ingenieria")
    //@State var contador: Int = 0
    
    
    var body: some View {
        //NavigationView{
        VStack{
            if self.anuncios.data.count != 0{
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        Text("Anuncios")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        Divider()
                            .frame(height: 3)
                            .background(Color.white)
                            
                    }.padding()
                        .background(fondonaranja)
                        .edgesIgnoringSafeArea(.all)
                        
                    VStack{
                        Text("Elija escuela")
                        //.padding()
                            .padding(.top,10)
                            .foregroundColor(grisclaro)
                        ScrollView(.horizontal){
                            Picker(selection: $suscelegida, label: Text("")){
                                ForEach(self.suscripciones.suscripciones){i in
                                    
                                    Text(i.nombre).tag(i.id)
                                    
                                }
                            }//.padding()
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.bottom,20)
                            
                        }
                    }.background(gris)
                        .cornerRadius(5.0)
                        .padding()
                    if(self.suscelegida == "Civil"){
                        //Text("Civil")
                        //VStack/*(spacing: 15)*/{
                            ForEach(self.anuncios.data){ i in
                            VStack(alignment: .leading, spacing: 6){
                                HStack{
                                    Image(imgicon(icono: i.icono))
                                        .resizable()
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .clipShape(Circle())
                                    
                                    //.border(Color.black,width: 3.0)
                                    VStack(alignment: .leading, spacing: 6){
                                        
                                        Text(i.titulo).font(.title)
                                        Text(i.fecha).font(.footnote)
                                        //Spacer()
                                    }
                                    Spacer()
                                    //Spacer()
                                    
                                }.padding(.bottom,10)
                                //Spacer()
                                
                                Text(i.mensaje)
                                    .font(.body)
                                    //.frame( maxHeight: .infinity, alignment: .leading)
                                    /*.lineLimit(nil)
                                    .allowsTightening(true)*/
                                    //.frame(maxHeight: .infinity, alignment: .top)
                                //.aspectRatio(contentMode: .fill)
                                if(i.imagen != ""){
                                    WebImage(url: URL(string: i.imagen)).resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(5.0)
                                }
                                    
                            }.padding()
                                .padding(.bottom,10)
                            Divider()
                                .frame(height: 1)
                                .background(Color.black)
                                //}
                            }
                        //}
                    }else if(self.suscelegida == "Sistemas"){
                        //VStack/*(spacing: 15)*/{
                            ForEach(self.anunciosing.data){ i in
                                VStack(alignment: .leading, spacing: 6){
                                    HStack{
                                        Image(imgicon(icono: i.icono))
                                            .resizable()
                                            .frame(width: 60, height: 60, alignment: .center)
                                            .clipShape(Circle())
                                        
                                        //.border(Color.black,width: 3.0)
                                        VStack(alignment: .leading, spacing: 6){
                                            
                                            Text(i.titulo).font(.title)
                                            Text(i.fecha).font(.footnote)
                                            //Spacer()
                                        }
                                        Spacer()
                                        //Spacer()
                                        
                                    }
                                    //Spacer()
                                    Text(i.mensaje).font(.body)
                                        //.frame(maxHeight: .infinity, alignment: .top)
                                    if(i.imagen != ""){
                                        WebImage(url: URL(string: i.imagen)).resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(5.0)
                                    }
                                        
                                }.padding()
                                    .padding(.bottom,10)
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.black)
                            //}
                        }
                    }
                    
                }
            }
        }//.padding()
        //.padding(.leading,-10)
            //.padding(.horizontal,-10)
            .navigationBarTitle("Anuncios")
            
    }
}

struct AnunciosIng_Previews: PreviewProvider {
    static var previews: some View {
        AnunciosIng()
    }
}



struct navCerrarSesion: View {
    var body: some View {
        HStack{
            Image("icon-back")
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.blue)
            Text("Cerrar Sesion")
                .foregroundColor(.blue)
                .padding(.horizontal,-10)
        }//.padding(.bottom,20)
            .padding(.horizontal,-25)
    }
}

func imgicon(icono:String)->String {
    var iconoreal:String = ""
    if icono == "Reunión" {
        iconoreal = "reunion"
    }else if icono == "Capacitación" {
        iconoreal = "capacitacion"
    }else if icono == "Exámenes" {
        iconoreal = "exams"
    }else{
        iconoreal = "vacas"
    }
    return iconoreal
}

class getSusc: ObservableObject {
    @Published var suscripciones = [Suscripcion]()
    //@Published var clases = [Suscripcion]()
    var susc:String = ""
    var div: [Substring] = []
    var id:Int = 0
    let db=Firestore.firestore()
    init(){
               
        db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            self.id = Int(snap?.get("Codigo") as! String) ?? 0
            self.susc = snap?.get("Suscripciones") as? String ?? ""
            if self.susc != "" {
                self.div = self.susc.split(separator: ",")
                self.div.forEach({
                    self.suscripciones.append(Suscripcion(id: String($0), nombre: $0))
                    print("id\($0) nombre \($0)")
                })
                print("id encontrado \(self.id)")
            }
        }
    }
}

class getAnuncios:ObservableObject{
    @Published var data = [Anuncio]()
    let db = Firestore.firestore()
    let ruta:String
    init(ruta:String){
        self.ruta = ruta
        db.collection(self.ruta).order(by: "Fecha",descending: true).addSnapshotListener{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                let id = i.document.documentID
                let titulo = i.document.get("Titulo") as! String
                let mensaje = i.document.get("Contenido")as! String
                let imagen = i.document.get("Imagen")as? String ?? ""
                let icono = i.document.get("TipoAnuncio") as! String
                guard let fechabuena = i.document.get("Fecha") as? Timestamp else{
                    return
                }
                let date = fechabuena.dateValue()
                let formatofecha = DateFormatter()
                formatofecha.locale = Locale(identifier: "es_GT")
                formatofecha.dateStyle = .long
                self.data.append(Anuncio(id: id, titulo: titulo, mensaje: mensaje, imagen: imagen, fecha: formatofecha.string(from: date), icono: icono))
            }
        }
    }
}
