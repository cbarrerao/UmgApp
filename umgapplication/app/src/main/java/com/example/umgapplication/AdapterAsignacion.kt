package com.example.umgapplication

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import kotlinx.android.synthetic.main.view_asignaciones.view.*

class AdapterAsignacion (val lista:ArrayList<Asignacion>, val context: Context) :
        RecyclerView.Adapter<AdapterAsignacion.ViewHolder>(){

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ViewHolder{
        return ViewHolder(LayoutInflater.from(context).inflate(R.layout.view_asignaciones,parent,false))
    }

    override fun getItemCount(): Int {
        return lista.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.Dias.text=lista[position].Dias
        holder.HoraInico.text=lista[position].HoraInicio
        holder.HoraFin.text=lista[position].HoraFin
        holder.IdCurso.text=lista[position].IdCurso
        holder.Salon.text=lista[position].Salon
        holder.Seccion.text=lista[position].Seccion
    }

    class ViewHolder(val view:View) : RecyclerView.ViewHolder(view){
        val Dias = view.textViewDias
        val HoraInico = view.textViewHoraInicio
        val HoraFin = view.textViewHoraFin
        val IdCurso = view.textViewCurso
        val Salon = view.textViewSalon
        val Seccion = view.textViewSeccion
    }

}