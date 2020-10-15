package com.example.umgapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.animation.AnimationUtils
import android.widget.Toast
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.android.synthetic.main.activity_principal.*

class Principal : AppCompatActivity() {
    var extendida = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_principal)
        val bundle: Bundle?=intent.extras
        val correo: String?= bundle?.getString("correo")
        val barraabierta= AnimationUtils.loadAnimation(this,R.anim.barra_extendida)
        val barracerrada= AnimationUtils.loadAnimation(this,R.anim.barra_cerrada)
        /*btnexpandirbarraperfil.setOnClickListener{
            btnexpandirbarra.startAnimation(barracerrada)
            btnbarra1.startAnimation(barraabierta)
            btnbarra2.startAnimation(barraabierta)

            btncerrarbarra.startAnimation(barraabierta)
            btncerrarbarra.isClickable = true
            btnbarra1.isClickable = true
            btnbarra2.isClickable = true
            btnexpandirbarra.isClickable = false
            extendida = true
            btnbarra3.setImageResource(R.drawable.icforwardarrownaranja)

        }
        btncerrarbarra.setOnClickListener{
            btnexpandirbarra.startAnimation(barraabierta)
            btnbarra1.startAnimation(barracerrada)
            btnbarra2.startAnimation(barracerrada)
            btncerrarbarra.startAnimation(barracerrada)
            btncerrarbarra.isClickable = false
            btnbarra1.isClickable = false
            btnbarra2.isClickable = false
            btnexpandirbarra.isClickable = true
            extendida = false
            btnbarra3.setImageResource(R.drawable.icforwardarrow)
        }
        btnve.setOnClickListener{
            val intent:Intent = Intent(this,MainSchedule::class.java)
            startActivity(intent)
        }
        btnbarra1.setOnClickListener{
            Toast.makeText(this, "se apacho botton barrra", Toast.LENGTH_SHORT).show()
        }*/
        setup(correo ?: "")

    }

    private fun setup(correo: String){
        title="INICIO"
        txtcorreo2.text=correo

        btncerrar.setOnClickListener{
            FirebaseAuth.getInstance().signOut()
            onBackPressed()
        }
        btnsuscribir.setOnClickListener{
            FirebaseMessaging.getInstance().subscribeToTopic("Ingenieria")
                .addOnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        Toast.makeText(this, "SUSCRIPCION mala", Toast.LENGTH_SHORT).show()
                    }else{
                        Toast.makeText(this, "SUSCRIPCION HECHA", Toast.LENGTH_SHORT).show()
                    }
                }
        }

        btnrecycler.setOnClickListener{

            startActivity(Intent(this,Anuncios::class.java))
        }
    }
}