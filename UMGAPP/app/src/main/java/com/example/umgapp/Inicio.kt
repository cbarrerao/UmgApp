package com.example.umgapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.animation.AnimationUtils
import android.widget.Toast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_login.*
import kotlinx.android.synthetic.main.activity_principal.*


class Inicio : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        val currentuser = FirebaseAuth.getInstance().currentUser
        if(currentuser!=null){
            Toast.makeText(this, "hay usuario dentro", Toast.LENGTH_SHORT).show()
            startActivity(Intent(this, MainSchedule::class.java))

        }else{
            Toast.makeText(this, "no hay usuario dentro", Toast.LENGTH_SHORT).show()
        }

        setup()
    }

    private fun setup() {
        title = "Iniciar sesión"
        //var lista = getUserNames()

        btningresologin.setOnClickListener {
            if (txtcorreologin.text.isNotEmpty() && txtcontralogin.text.isNotEmpty()) {
                FirebaseAuth.getInstance()
                    .signInWithEmailAndPassword(
                        txtcorreologin.text.toString(),
                        txtcontralogin.text.toString()
                    ).addOnCompleteListener {

                        if (it.isSuccessful) {
                            startActivity(Intent(this, MainSchedule::class.java).apply {
                                putExtra("correo", txtcorreologin.text.toString())
                            })
                        } else {
                            Toast.makeText(this, "Error al autenticar usuario", Toast.LENGTH_SHORT)
                                .show()
                        }
                    }
            } else {
                Toast.makeText(this, "Falta ingresar datos", Toast.LENGTH_SHORT).show()
            }
        }

        btncontraolvidada.setOnClickListener {
            if (txtcorreologin.text.isNotBlank()) {
                FirebaseAuth.getInstance().sendPasswordResetEmail(txtcorreologin.text.toString())
                    .addOnCompleteListener(this) { task ->
                        if (task.isSuccessful) {
                            Toast.makeText(
                                this,
                                "Correo de restablecer contraseña enviado",
                                Toast.LENGTH_SHORT
                            ).show()
                        } else {
                            Toast.makeText(
                                this,
                                "Error al enviar correo de restablecimiento de contraseña",
                                Toast.LENGTH_SHORT
                            ).show()
                        }
                    }
            } else {
                Toast.makeText(this, "Debe de ingresar un correo", Toast.LENGTH_SHORT).show()
            }
        }

        btnRegistro.setOnClickListener {
            print("prueba en inicio")
            //print(getUserNames())
            print("prueba en inicio2")
            //print(lista)
            startActivity(Intent(this, Registro::class.java))
        }
    }

    /*fun getUserNames(): List<String> {
        val sedes = ArrayList<String>()
        db.collection("Sedes").get().addOnCompleteListener() {
            if(it.isSuccessful){
                for(documentos in it.result!!){
                    val nombre=documentos.getString("Nombre")

                    sedes.add(nombre!!)
                }
            }

        }
        println("final $sedes")
        return sedes
    }*/

    class mySedes{

        companion object{
            fun getUserNames(): ArrayList<String> {
                val db= FirebaseFirestore.getInstance()
                val sedes = ArrayList<String>()
                db.collection("Sedes").get().addOnCompleteListener() {
                    if(it.isSuccessful){
                        for(documentos in it.result!!){
                            val nombre=documentos.getString("Nombre")

                            sedes.add(nombre!!)
                        }
                    }

                }
                println("final $sedes")
                return sedes
            }
        }
    }
}