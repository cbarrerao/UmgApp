package com.example.umgapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.animation.AnimationUtils
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
import kotlinx.android.synthetic.main.activity_main_schedule.*
import kotlinx.android.synthetic.main.activity_registro.*

class Anuncios : AppCompatActivity() {
    var extendida = false
    var suscelegida:String =""
    val db= FirebaseFirestore.getInstance()
    val arrayList=ArrayList<ModeloCard>()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_anuncios)
        val barraabierta= AnimationUtils.loadAnimation(this,R.anim.barra_extendida)
        val barracerrada= AnimationUtils.loadAnimation(this,R.anim.barra_cerrada)
        btnexpandirbarraan.setOnClickListener{
            btnexpandirbarraan.startAnimation(barracerrada)
            contbarraan.startAnimation(barraabierta)
            extendida=true
            contbarraan.isClickable=true
            btnbarraexp1an.isClickable=true
            btnbarraexp2an.isClickable=true
            btnbarraexp4an.isClickable=true
            btnbarraexp3an.isClickable=true
            btnexpandirbarraan.isClickable=false
        }
        contbarraan.setOnClickListener{
            contbarraan.startAnimation(barracerrada)
            btnexpandirbarraan.startAnimation(barraabierta)
            contbarraan.isClickable=false
            btnbarraexp1an.isClickable=false
            btnbarraexp2an.isClickable=false
            btnbarraexp4an.isClickable=false
            btnbarraexp3an.isClickable=false
            btnexpandirbarraan.isClickable=true
            extendida=false
        }
        btnbarraexp1an.setOnClickListener{
            startActivity(Intent(this, MainSchedule::class.java))
        }
        btnbarraexp2an.setOnClickListener{
            startActivity(Intent(this, Anuncios::class.java))
        }
        btnbarraexp3an.setOnClickListener{
            startActivity(Intent(this, Suscripciones::class.java))
        }
        btnbarraexp4an.setOnClickListener{
            FirebaseAuth.getInstance().signOut()
            startActivity(Intent(this, Inicio::class.java))
        }
        
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
                    ponerAnuncios("Anuncios")
                }else if(suscelegida=="Sistemas"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Agroindustrial"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Alimentos"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Biomedica"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Computacion"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Electrica"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Electronica"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Fisica"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Industrial"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Matematica"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Mecanica"){
                    ponerAnuncios("Ingenieria")
                }else if(suscelegida=="Quimica"){
                    ponerAnuncios("Ingenieria")
                }
            }

        }
    }

    private fun ponerAnuncios(coleccion:String) {
        val adaptador=AdaptadorCarta(arrayList,this@Anuncios)
        db.collection(coleccion).orderBy("Fecha", Query.Direction.DESCENDING).get()
            .addOnCompleteListener() {
                if (it.isSuccessful) {
                    arrayList.clear()
                    for (documentos in it.result!!) {
                        val titulo = documentos.getString("Titulo")
                        val contenido = documentos.getString("Contenido")
                        var imagens: String? = documentos.getString("Imagen")
                        if (imagens.isNullOrEmpty()) {
                            imagens = ""
                        }
                        val tipoanuncio = documentos.getString("TipoAnuncio")
                        arrayList.add(ModeloCard(titulo!!, contenido!!, imagens!!, tipoanuncio!!))
                    }
                    adaptador.notifyDataSetChanged()
                }
            }
        recyclerView.layoutManager=LinearLayoutManager(this@Anuncios)
        recyclerView.adapter=adaptador
    }

}

