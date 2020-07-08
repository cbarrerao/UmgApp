package com.example.umgapplication

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.FirestoreRegistrar
import com.google.firebase.firestore.QueryDocumentSnapshot
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.view_asignaciones.*

class MainActivity : AppCompatActivity() {

    private val lista:ArrayList<Asignacion> = ArrayList()
    private val adapterAsignacion = AdapterAsignacion(lista,this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //Este mini bloque es para cambiar entre actividades
            btnSiguiente.setOnClickListener{
                val intent:Intent = Intent(this,Profile::class.java)
                startActivity(intent)
            }

        recyclerAsignacion.layoutManager = GridLayoutManager(this,1)
        recyclerAsignacion.adapter = adapterAsignacion

        //Declaración de la instancia de Firestone
        val db = FirebaseFirestore.getInstance()
        //Se agregan valores al spinner
        val list:MutableList<String> = ArrayList()
        list.add("")
        list.add("Matutino")
        list.add("Vespertino")
        list.add("Nocturno")

        val adapter=ArrayAdapter(this, R.layout.support_simple_spinner_dropdown_item, list)
        spinTest.adapter = adapter
        //De esta manera puedo tomar el indice del item
        spinTest.onItemSelectedListener = object : AdapterView.OnItemSelectedListener{
            override fun onNothingSelected(parent: AdapterView<*>?) {}
            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
               val item = list[position]
                println("POSICION DEL SPINNER: $position")

                db.collection("Asignacion").whereEqualTo("IdHorario",position).whereEqualTo("IdMaestro",67890).get().addOnCompleteListener{
                    if(it.isSuccessful){
                        lista.clear()
                        for (documentos:QueryDocumentSnapshot in it.result!!){
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
                    }else{
                        lista.clear()
                        lista.add(Asignacion("No hay Cursos asignados a este horario:","","","","",""))
                        adapterAsignacion.notifyDataSetChanged()
                    }

                }
                Toast.makeText(this@MainActivity,"Horario $item seleccionado", Toast.LENGTH_SHORT).show()
            }
        }
    }



}