package com.example.umgapp


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
        holder.Curso.text=lista[position].Curso
        holder.Dia.text=lista[position].Dia
        holder.Hora.text=lista[position].Hora

    }

    class ViewHolder(val view:View) : RecyclerView.ViewHolder(view){
        val Curso = view.txtCurso
        val Dia = view.txtDia
        val Hora = view.txtHora

    }

}