//
//  ModeloMensajes.swift
//  UMGAPPIOS
//
//  Created by Administrador SSIN3 on 9/24/20.
//  Copyright © 2020 Administrador SSIN3. All rights reserved.
//

import SwiftUI
import Firebase

class ModeloMensajes : ObservableObject{
    @Published var mensajesnuevos = 0
    @Published var mensajes: [Mensaje] = []
    @Published var mensajesprueba : [Mensaje] = []
    let db = Firestore.firestore()
    var cant:Int = 0
    init(){
        leerMensajes()
    }
    
    func leerMensajes(){
        print("*********")
        //self.mensajesnuevos = 0
        db.collection("usuarios").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (snap,err) in
            if err != nil{
                print("Error getting documents: ")
                print((err?.localizedDescription)!)
                return
            }
            let id = Int(snap?.get("Codigo") as! String) ?? 0
            
            self.db.collection("Mensajes").order(by: "Fecha").addSnapshotListener{ (snap,err) in
                //self.mensajesnuevos = 0
                if err != nil{
                    print("Error getting documents: ")
                    print((err?.localizedDescription)!)
                    return
                }
                guard let data = snap else {return}
                data.documentChanges.forEach{ (doc) in
                    
                    //if doc.type == .added{
                        
                        DispatchQueue.main.async {
                            if (doc.document.get("Receptor")as! Int == id && doc.document.get("Estado")as! Int == 0){
                                self.mensajesnuevos += 1
                            }
                            self.mensajes.append(Mensaje(id: self.cant, mensaje: doc.document.get("Mensaje") as! String, emisor: doc.document.get("Emisor") as! Int, receptor: doc.document.get("Receptor") as! Int, Fecha: (doc.document.get("Fecha") as! Timestamp).dateValue()))
                            self.cant += 1
                            /*else if (doc.document.get("Receptor")as! Int == id && doc.document.get("Estado")as! Int == 1){
                                self.mensajesnuevos = self.cant - 1
                            }*/
                            print("\(self.mensajesnuevos)")
                            
                            if(self.cant == data.count && self.mensajesnuevos == 0){
                                self.mensajesnuevos += 1
                                /*self.mensajes.append(Mensaje(id: self.cant, mensaje: doc.document.get("Mensaje") as! String, emisor: doc.document.get("Emisor") as! Int, receptor: doc.document.get("Receptor") as! Int, Fecha: (doc.document.get("Fecha") as! Timestamp).dateValue()))*/
                                print("llego al final con :\(self.mensajesnuevos)")
                            }
                            
                       }
                    //}
                    print(" salida \(self.mensajesnuevos)")
                }
                
            }
        }
        
        
    }
}
