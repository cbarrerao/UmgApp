package com.example.umgapp

import android.content.Intent
import android.opengl.Visibility
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.core.view.isVisible
import androidx.recyclerview.widget.GridLayoutManager
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.QueryDocumentSnapshot
import io.grpc.NameResolver
import kotlinx.android.synthetic.main.activity_main_schedule.*
import kotlinx.android.synthetic.main.activity_main_schedule.recyclerMatutina
import kotlinx.android.synthetic.main.activity_principal.*
import kotlinx.android.synthetic.main.view_asignaciones.*
import kotlin.math.log


class MainSchedule : AppCompatActivity() {

    private val lista:ArrayList<Asignacion> = ArrayList()
    private val listaVespertina:ArrayList<Asignacion> = ArrayList()
    private val listaMixta:ArrayList<Asignacion> = ArrayList()
    private val adapterAsignacion = AdapterAsignacion(lista,this)
    private val adapterAsignacionVes = AdapterAsignacion(listaVespertina,this)
    private val adapterAsignacionMix = AdapterAsignacion(listaMixta,this)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main_schedule)


        recyclerMatutina.layoutManager = GridLayoutManager(this,1)
        recyclerMatutina.adapter = adapterAsignacion

        recyclerVespertina.layoutManager = GridLayoutManager(this,1)
        recyclerVespertina.adapter = adapterAsignacionVes

        recyclerMixto.layoutManager = GridLayoutManager(this,1)
        recyclerMixto.adapter = adapterAsignacionMix

        //Declaración de la instancia de Firestone
        val db = FirebaseFirestore.getInstance()
        var userid = FirebaseAuth.getInstance().currentUser?.uid
        var codigoraro=""

        db.collection("usuarios").document(userid.toString()).addSnapshotListener{ snapshot, e ->
            if (e!= null){
                print("error en codigo usuario")
            }
            codigoraro = snapshot?.get("Codigo") as String
            val Nombres=snapshot?.get("Nombres") as String
            val Apellidos=snapshot?.get("Apellidos") as String
            val Codigo = snapshot?.get("Codigo") as String
            val Titulo = snapshot?.get("Titulo") as String
            txtTitNombre.setText("Titulo ")
            txtNombre.setText("$Nombres " + "$Apellidos")
            txtTitTitulo.setText("Titulo ")
            txtTitulo.setText("$Titulo")
            txtTitCodigo.setText("Código ")
            txtCodigo.setText("$Codigo")
            println("CODIGOOOOOOOOOOOOOOOOOOOOOOOOO: $codigoraro")
            //proofcode.setText(codigoraro)

        }



        //MATUTINO
        btnMatutina.setOnClickListener{

            if(txtMatutina.visibility == View.GONE){
                txtMatutina.setVisibility(View.VISIBLE)
                db.collection("Asignacion").whereEqualTo("Catedratico",codigoraro.toInt()).whereEqualTo("TipoHorario","Matutino").get().addOnCompleteListener {
                    if (it.isSuccessful) {
                        lista.clear()
                        for (documentos: QueryDocumentSnapshot in it.result!!) {
                            Log.d("Documento Query: ", "${documentos.data}")
                            val Curso: String? = documentos.getString("Curso")
                            val Dia: String? = documentos.getString("Dia")
                            val Hora: String? = documentos.getString("Hora")
                           // var diaLista = Dia?.split(",")
                            //println("SAFEEEEEEEEEEEEEEEEEEEEE:"+diaLista?.get(0))
                            //txtVistaDia.setText(diaLista?.get(0))
                            if (Curso != null && Dia != null && Hora != null) {
                                lista.add(Asignacion(Curso, Dia, Hora))
                            }
                            adapterAsignacion.notifyDataSetChanged()
                        }
                    }
                }
                recyclerMatutina.setVisibility(View.VISIBLE)
            }else if (txtMatutina.visibility == View.VISIBLE){
                txtMatutina.setVisibility(View.GONE)
                recyclerMatutina.setVisibility(View.GONE)
            }
        }

        //VESPERTINO
        btnVespertina.setOnClickListener{
            if(txtVespertina.visibility == View.GONE){
                txtVespertina.setVisibility(View.VISIBLE)
                db.collection("Asignacion").whereEqualTo("Catedratico",codigoraro.toInt()).whereEqualTo("TipoHorario","Vespertino").get().addOnCompleteListener {
                    if (it.isSuccessful) {
                        listaVespertina.clear()
                        for (documentos: QueryDocumentSnapshot in it.result!!) {
                            Log.d("Documento Query: ", "${documentos.data}")
                            val Curso: String? = documentos.getString("Curso")
                            val Dia: String? = documentos.getString("Dia")
                            val Hora: String? = documentos.getString("Hora")

                            if (Curso != null && Dia != null && Hora != null) {
                                listaVespertina.add(Asignacion(Curso, Dia, Hora))
                            }
                            adapterAsignacionVes.notifyDataSetChanged()
                        }
                    }
                }
                recyclerVespertina.setVisibility(View.VISIBLE)
            }else if (txtVespertina.visibility == View.VISIBLE){
                txtVespertina.setVisibility(View.GONE)
                recyclerVespertina.setVisibility(View.GONE)
            }
        }

        //MIXTO
        btnMixta.setOnClickListener{
            if(txtMixta.visibility == View.GONE){
                txtMixta.setVisibility(View.VISIBLE)
                db.collection("Asignacion").whereEqualTo("Catedratico",codigoraro.toInt()).whereEqualTo("TipoHorario","Mixto").get().addOnCompleteListener {
                    if (it.isSuccessful) {
                        listaMixta.clear()
                        for (documentos: QueryDocumentSnapshot in it.result!!) {
                            Log.d("Documento Query: ", "${documentos.data}")
                            val Curso: String? = documentos.getString("Curso")
                            val Dia: String? = documentos.getString("Dia")
                            val Hora: String? = documentos.getString("Hora")

                            if (Curso != null && Dia != null && Hora != null) {
                                listaMixta.add(Asignacion(Curso, Dia, Hora))
                            }
                            adapterAsignacionMix.notifyDataSetChanged()
                        }
                    }
                }
                recyclerMixto.setVisibility(View.VISIBLE)
            }else if (txtMixta.visibility == View.VISIBLE){
                txtMixta.setVisibility(View.GONE)
                recyclerMixto.setVisibility(View.GONE)
            }
        }




        }

    }