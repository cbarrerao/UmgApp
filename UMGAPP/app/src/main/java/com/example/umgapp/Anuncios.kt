package com.example.umgapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.lifecycle.MutableLiveData
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import com.google.firebase.firestore.QueryDocumentSnapshot
import kotlinx.android.synthetic.main.activity_anuncios.*
import kotlinx.android.synthetic.main.activity_registro.*

class Anuncios : AppCompatActivity() {

    var suscelegida:String =""
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_anuncios)

        val arrayList=ArrayList<ModeloCard>()
        val db= FirebaseFirestore.getInstance()
        var userid = FirebaseAuth.getInstance().currentUser?.uid
        val lista = mutableListOf<String>("Seleccione su escuela...")
        var susc:String = ""
        db.collection("usuarios").document(userid.toString()).addSnapshotListener{ snapshot, e ->
            if (e!= null){
                print("error en usuario anuncios")
            }
            susc = snapshot?.get("Suscripciones") as String
            var inicio: Int = 0
            for (i in 0..susc.length){
                if(i+1<=susc.length){
                    println(susc.substring(i,i+1))
                    if(susc.substring(i,i+1)==","){
                        lista.add(susc.substring(inicio,i))
                        inicio=i+1
                    }

                }else if(i==susc.length){
                    lista.add(susc.substring(inicio,i))
                }
            }
        }
        val arrayadapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, lista)
        cmbsusc.adapter = arrayadapter
        cmbsusc.onItemSelectedListener = object : AdapterView.OnItemSelectedListener{
            override fun onNothingSelected(parent: AdapterView<*>) {
                println("NO SE SELECCIONO NADA")

            }
            override fun onItemSelected(parent: AdapterView<*>, view: View?, position: Int, id: Long) {
                println("SI SE SELECCIONO "+ lista[position])
                suscelegida = lista[position]
                println("SEDE ELEGIDA " + suscelegida)
                if(suscelegida=="Civil"){
                    val adaptador=AdaptadorCarta(arrayList,this@Anuncios)
                    db.collection("Anuncios").orderBy("Fecha",Query.Direction.DESCENDING).get().addOnCompleteListener() {
                        if(it.isSuccessful){
                            arrayList.clear()
                            for(documentos in it.result!!){
                                val titulo=documentos.getString("Titulo")
                                val contenido=documentos.getString("Contenido")
                                var imagens:String? = documentos.getString("Imagen")
                                if (imagens.isNullOrEmpty()){
                                    imagens = ""
                                }
                                val tipoanuncio=documentos.getString("TipoAnuncio")
                                arrayList.add(ModeloCard(titulo!!,contenido!!,imagens!!,tipoanuncio!!))
                            }
                            adaptador.notifyDataSetChanged()
                        }

                    }
                    recyclerView.layoutManager=LinearLayoutManager(this@Anuncios)
                    recyclerView.adapter=adaptador
                }else if(suscelegida=="Sistemas"){
                    val adaptador=AdaptadorCarta(arrayList,this@Anuncios)
                    db.collection("Ingenieria").orderBy("Fecha",Query.Direction.DESCENDING).get().addOnCompleteListener() {
                        if(it.isSuccessful){
                            arrayList.clear()
                            for(documentos in it.result!!){
                                val titulo=documentos.getString("Titulo")
                                val contenido=documentos.getString("Contenido")
                                var imagens:String? = documentos.getString("Imagen")
                                if (imagens.isNullOrEmpty()){
                                    imagens = ""
                                }
                                val tipoanuncio=documentos.getString("TipoAnuncio")
                                arrayList.add(ModeloCard(titulo!!,contenido!!,imagens!!,tipoanuncio!!))
                            }
                            adaptador.notifyDataSetChanged()
                        }

                    }
                    recyclerView.layoutManager=LinearLayoutManager(this@Anuncios)
                    recyclerView.adapter=adaptador
                }
            }

        }


        //if(suscelegida=="Civil"){




        }

    //}

}

