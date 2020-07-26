package com.example.umgapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.recyclerview.widget.GridLayoutManager
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.QueryDocumentSnapshot
import kotlinx.android.synthetic.main.activity_profile.*

class Profile : AppCompatActivity() {
    private val lista:ArrayList<Asignacion> = ArrayList()
    private val adapterAsignacion = AdapterAsignacion(lista,this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)

        var codigoraro = 12345
        recyclerAsignProfile.layoutManager = GridLayoutManager(this,1)
        recyclerAsignProfile.adapter = adapterAsignacion

        //Declaración de la instancia de Firestone
        val db = FirebaseFirestore.getInstance()

        db.collection("usuarios").whereEqualTo("Codigo",codigoraro.toString()).get().addOnCompleteListener{
            if (it.isSuccessful){
                for(datosCatedratico: QueryDocumentSnapshot in it.result!!){
                    val Nombres:String?=datosCatedratico.getString("Nombres")
                    val Apellidos:String?=datosCatedratico.getString("Apellidos")
                    val Codigo:String?=datosCatedratico.getString("Codigo")
                    val Titulo:String? = datosCatedratico.getString("Titulo")
                    textView.setText("Nombres: $Nombres")
                    textView2.setText("Apellidos: $Apellidos")
                    textView3.setText("Código: $Codigo")
                    textView6.setText("Titulo Académico: $Titulo")

                }
            }
        }



        db.collection("Asignacion").whereEqualTo("IdMaestro",codigoraro).get().addOnCompleteListener{
            if(it.isSuccessful){
                lista.clear()
                for (documentos: QueryDocumentSnapshot in it.result!!){
                    Log.d("Documento Query: ","${documentos.data}")
                    val Dias:String? = documentos.getString("Dias")
                    val HoraInicio:String? = documentos.getString("HoraInicio")
                    val HoraFin:String? = documentos.getString("HoraFin")
                    val IdCurso:String? = documentos.getString("IdCurso")
                    val Salon:String? = documentos.getString("Salon")
                    val Seccion:String? = documentos.getString("Seccion")

                    if(Dias != null && HoraInicio != null && HoraFin != null && IdCurso != null && Salon != null && Seccion != null){
                        lista.add(Asignacion("Dias: $Dias","Hora de Inicio: $HoraInicio","HoraFin: $HoraFin","Curso: $IdCurso","Salon: $Salon","Seccion $Seccion"))
                    }
                    adapterAsignacion.notifyDataSetChanged()
                }
            }

        }




    }
}