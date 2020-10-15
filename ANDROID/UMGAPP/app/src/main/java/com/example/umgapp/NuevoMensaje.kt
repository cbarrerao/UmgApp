package com.example.umgapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ArrayAdapter
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_nuevo_mensaje.*
import kotlinx.android.synthetic.main.activity_registro.*

class NuevoMensaje : AppCompatActivity() {
    val db= FirebaseFirestore.getInstance()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nuevo_mensaje)

        val lista = mutableListOf<String>("Seleccione el destinatario...")
        db.collection("usuarios").whereEqualTo("Cargo","1").get().addOnCompleteListener() {
            if(it.isSuccessful){
                for(documentos in it.result!!){
                    val codigo=documentos.get("Codigo")
                    var usuario=documentos.getString("Apellidos")+", "+documentos.getString("Nombres")+" -"+codigo
                    lista.add(usuario)
                }
            }
        }
        val arrayadapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, lista)
        cmbdestinatario.adapter = arrayadapter
    }
}