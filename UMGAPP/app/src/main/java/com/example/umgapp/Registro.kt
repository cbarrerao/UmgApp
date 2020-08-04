package com.example.umgapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import android.widget.Toast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import kotlinx.android.synthetic.main.activity_registro.*

class Registro : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth
    val db= FirebaseFirestore.getInstance()
    var idsede:String = ""
    override fun onCreate(savedInstanceState: Bundle?) {
        auth= FirebaseAuth.getInstance()


        //var lista=Inicio.mySedes.getUserNames()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_registro)
       /* print("hola lista")
        print(lista)*/

        val lista = mutableListOf<String>("Seleccione su sede principal...")
        db.collection("Sedes").get().addOnCompleteListener() {
            if(it.isSuccessful){
                for(documentos in it.result!!){
                    val nombre=documentos.getString("Nombre")

                    lista.add(nombre!!)
                }
            }

        }
        val arrayadapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, lista)

        cmbsedes.adapter = arrayadapter
        /*val sedes= mutableListOf<String>("HOla","adios")
        sedes.add("bye")

        val adaptador = ArrayAdapter(this,android.R.layout.simple_spinner_item,sedes)
        cmbsedes.adapter = adaptador*/
        cmbsedes.onItemSelectedListener = object : AdapterView.OnItemSelectedListener{
            override fun onNothingSelected(parent: AdapterView<*>) {
                println("NO SE SELECCIONO NADA")

            }

            override fun onItemSelected(parent: AdapterView<*>, view: View?, position: Int, id: Long) {
                println("SI SE SELECCIONO "+ lista[position])
                var sede = lista[position]
                db.collection("Sedes").whereEqualTo("Nombre",sede ).get().addOnCompleteListener() {
                    if(it.isSuccessful){
                        //arrayList.clear()

                        for(documentos in it.result!!) {
                            idsede = documentos.id
                        }
                    }
                }
            }

        }

        setup()
    }

    private fun setup(){
        title= "Registro"

        btnregistrar.setOnClickListener(){


            if(txtapellidos.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar apellidos $idsede", Toast.LENGTH_SHORT).show()
                txtapellidos.requestFocus()
            }else if(txtcorreo.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar correo electrónico", Toast.LENGTH_SHORT).show()
                txtcorreo.requestFocus()
            }else if(txtnombres.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar nombre", Toast.LENGTH_SHORT).show()
                txtnombres.requestFocus()
            }else if(txtcontra.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar contraseña", Toast.LENGTH_SHORT).show()
                txtcontra.requestFocus()
            }else if(txttitulo.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar el titulo", Toast.LENGTH_SHORT).show()
                txttitulo.requestFocus()
            }else if(txtconfcontra.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar la confirmación de contraseña", Toast.LENGTH_SHORT).show()
                txtconfcontra.requestFocus()
            }else if(txtcodcat.text.isEmpty()){
                Toast.makeText(this, "Falta ingresar el codigo de catedratico", Toast.LENGTH_SHORT).show()
                txtcodcat.requestFocus()
            }else if(idsede == ""){
                Toast.makeText(this, "Falta seleccionar su sede principal", Toast.LENGTH_SHORT).show()
            }else{
                if(txtcorreo.text.endsWith("@miumg.edu.gt")){
                    if(txtcontra.text.length>=6){
                        if(txtconfcontra.text.toString()==txtcontra.text.toString()){
                            var resultado=""
                            FirebaseFirestore.getInstance()
                                .collection("codigoscat")
                                .whereEqualTo("codigo",txtcodcat.text.toString().toInt())
                                .get().addOnSuccessListener { querySnapshot ->
                                    //println(querySnapshot.documents)
                                    resultado = querySnapshot.documents.toString()
                                    if (resultado == "[]") {
                                        Toast.makeText(
                                            this,
                                            "El código de catedrático ingresado no existe",
                                            Toast.LENGTH_SHORT
                                        ).show()
                                    } else {
                                        //codigo si existe
                                        FirebaseAuth.getInstance()
                                            .createUserWithEmailAndPassword(txtcorreo.text.toString(),
                                                txtcontra.text.toString()).addOnCompleteListener{

                                                if(it.isSuccessful){
                                                    val user: FirebaseUser?=auth.currentUser
                                                    verificacionEmail(user)
                                                    val usuario = hashMapOf(
                                                        "Nombres" to txtnombres.text.toString(),
                                                        "Apellidos" to txtapellidos.text.toString(),
                                                        "Codigo" to txtcodcat.text.toString(),
                                                        "Titulo" to txttitulo.text.toString(),
                                                        "Sede" to idsede,
                                                        "Suscripciones" to "Gen"
                                                    )
                                                    val db= FirebaseFirestore.getInstance()
                                                    db.collection("usuarios").document(user?.uid.toString()).set(usuario).addOnSuccessListener { documentReference ->
                                                        Toast.makeText(this, "Usuario Registrado correctamente", Toast.LENGTH_SHORT).show()
                                                        startActivity(Intent(this,Inicio::class.java))
                                                    }
                                                        .addOnFailureListener { e ->
                                                            //Log.w(TAG, "Error adding document", e)
                                                        }
                                                }else{
                                                    Toast.makeText(this, "Hubo un error en el registro", Toast.LENGTH_SHORT).show()
                                                }
                                            }
                                    }
                                }
                        }else{
                            Toast.makeText(this, "Las contraseñas no coinciden", Toast.LENGTH_SHORT).show()
                            txtcontra.requestFocus()
                        }
                    }else{
                        Toast.makeText(this, "La contraseña debe tener al menos 6 caracteres", Toast.LENGTH_SHORT).show()
                        txtcontra.requestFocus()
                    }
                }else{
                    Toast.makeText(this, "Debe ingresar un correo de la universidad", Toast.LENGTH_SHORT).show()
                    txtcorreo.requestFocus()
                }
            }
        }
    }

    private fun verificacionEmail(user: FirebaseUser?){
        user?.sendEmailVerification()
            ?.addOnCompleteListener(this){
                    task ->
                if(task.isComplete){
                    //Toast.makeText(this, "Email de verificacion enviado", Toast.LENGTH_SHORT).show()
                }else{
                    Toast.makeText(this, "Error al enviar email de verificacion", Toast.LENGTH_SHORT).show()
                }
            }
    }

    fun getUserNames(): MutableList<String> {
        val sedes = mutableListOf<String>()
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