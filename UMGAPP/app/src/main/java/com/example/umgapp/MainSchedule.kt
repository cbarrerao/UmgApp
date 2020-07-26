package com.example.umgapp

import android.content.Intent
import android.opengl.Visibility
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.core.view.isVisible
import kotlinx.android.synthetic.main.activity_cursos.*
import kotlinx.android.synthetic.main.activity_main_schedule.*
import kotlinx.android.synthetic.main.activity_profile.*

class MainSchedule : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main_schedule)

        //MATUTINO
        btnMatutina.setOnClickListener{
            if(txtMatutina.visibility == View.GONE){
                txtMatutina.setVisibility(View.VISIBLE)
            }else if (txtMatutina.visibility == View.VISIBLE){
                txtMatutina.setVisibility(View.GONE)
            }
        }

        //VESPERTINO
        btnVespertina.setOnClickListener{
            if(txtVespertina.visibility == View.GONE){
                txtVespertina.setVisibility(View.VISIBLE)
            }else if (txtVespertina.visibility == View.VISIBLE){
                txtVespertina.setVisibility(View.GONE)
            }
        }

        //NOCTURNO
        btnMixta.setOnClickListener{
            if(txtMixta.visibility == View.GONE){
                txtMixta.setVisibility(View.VISIBLE)
            }else if (txtMixta.visibility == View.VISIBLE){
                txtMixta.setVisibility(View.GONE)
            }
        }






    }

}