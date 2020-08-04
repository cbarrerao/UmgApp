package com.example.umgapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.animation.AnimationUtils
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.activity_anuncios.*
import kotlinx.android.synthetic.main.activity_main_schedule.*
import kotlinx.android.synthetic.main.activity_suscripciones.*

class Suscripciones : AppCompatActivity() {
    var extendida = false
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
            startActivity(Intent(this, MainSchedule::class.java))
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

    }
}