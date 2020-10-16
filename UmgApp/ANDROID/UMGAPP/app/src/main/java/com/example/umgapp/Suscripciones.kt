package com.example.umgapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.animation.AnimationUtils
import android.widget.Toast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.SetOptions
import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.android.synthetic.main.activity_anuncios.*
import kotlinx.android.synthetic.main.activity_main_schedule.*
import kotlinx.android.synthetic.main.activity_suscripciones.*

class Suscripciones : AppCompatActivity() {
    var extendida = false
    val lista = mutableListOf<String>("Seleccione su escuela...")
    var susc:String = ""
    val db= FirebaseFirestore.getInstance()
    var userid = FirebaseAuth.getInstance().currentUser?.uid
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_suscripciones)
        val barraabierta= AnimationUtils.loadAnimation(this,R.anim.barra_extendida)
        val barracerrada= AnimationUtils.loadAnimation(this,R.anim.barra_cerrada)
        btnexpandirbarrasusc.setOnClickListener{
            btnexpandirbarrasusc.startAnimation(barracerrada)
            contbarrasusc.startAnimation(barraabierta)
            extendida=true
            contbarrasusc.isClickable=true
            btnbarraexp1susc.isClickable=true
            btnbarraexp2susc.isClickable=true
            btnbarraexp4susc.isClickable=true
            btnbarraexp3susc.isClickable=true
            btnexpandirbarrasusc.isClickable=false
        }
        contbarrasusc.setOnClickListener{
            contbarrasusc.startAnimation(barracerrada)
            btnexpandirbarrasusc.startAnimation(barraabierta)
            contbarrasusc.isClickable=false
            btnbarraexp1susc.isClickable=false
            btnbarraexp2susc.isClickable=false
            btnbarraexp4susc.isClickable=false
            btnbarraexp3susc.isClickable=false
            btnexpandirbarrasusc.isClickable=true
            extendida=false
        }
        btnbarraexp1susc.setOnClickListener{
            startActivity(Intent(this, NuevoMensaje::class.java))
        }
        btnbarraexp2susc.setOnClickListener{
            startActivity(Intent(this, Anuncios::class.java))
        }
        btnbarraexp3susc.setOnClickListener{
            startActivity(Intent(this, Suscripciones::class.java))
        }
        btnbarraexp4susc.setOnClickListener{
            FirebaseAuth.getInstance().signOut()
            startActivity(Intent(this, Inicio::class.java))
        }

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
        lyagro.setOnClickListener{
            buscar("Agroindustrial")
        }
        lyalimentos.setOnClickListener{
            buscar("Alimentos")
        }
        lybiomedics.setOnClickListener{
            buscar("Biomedica")
        }
        lycivil.setOnClickListener{
            buscar("Civil")
        }
        lycomputacion.setOnClickListener{
            buscar("Computacion")
        }
        lyelectrica.setOnClickListener{
            buscar("Electrica")
        }
        lyelectronica.setOnClickListener{
            buscar("Electronica")
        }
        lyfisica.setOnClickListener{
            buscar("Fisica")
        }
        lyindustrial.setOnClickListener{
            buscar("Industrial")
        }
        lymate.setOnClickListener{
            buscar("Matematica")
        }
        lymec.setOnClickListener{
            buscar("Mecanica")
        }
        lyquimica.setOnClickListener{
            buscar("Quimica")
        }
        lysistemas.setOnClickListener{
            buscar("Sistemas")
        }
    }

    private fun buscar(suscripcion:String) {
        if (lista.count { it == suscripcion } >= 1) {
            Toast.makeText(this, "Esta escuela ya existe dentro de las opciones", Toast.LENGTH_SHORT).show()
        } else {
            susc = susc + ","+suscripcion
            lista.add(suscripcion)
            db.collection("usuarios").document(userid.toString())
                .addSnapshotListener { snapshot, e ->
                    if (e != null) {
                        print("error en codigo usuario")
                    }
                    val data = hashMapOf("Suscripciones" to susc)
                    db.collection("usuarios").document(userid.toString())
                        .set(data, SetOptions.merge())
                        .addOnSuccessListener {
                            Toast.makeText(this, "Escuela añadida, puede encontrarla en el apartado de anuncios.", Toast.LENGTH_SHORT).show()
                            FirebaseMessaging.getInstance().subscribeToTopic(suscripcion)
                    }

            }
        }
    }
}