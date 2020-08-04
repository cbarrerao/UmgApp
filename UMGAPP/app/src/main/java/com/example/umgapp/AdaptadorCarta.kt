package com.example.umgapp

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide

import kotlinx.android.synthetic.main.fila.view.*


class AdaptadorCarta(val arrayList: ArrayList<ModeloCard>, val context: Context):
    RecyclerView.Adapter<AdaptadorCarta.ViewHolder>() {
    class ViewHolder(itemView: View):RecyclerView.ViewHolder(itemView){

        fun bindItems(modeloCard: ModeloCard){
            itemView.txtNombre.text=modeloCard.titulo
            //itemView.descripcionIV.text=modeloCard.descripcion
            itemView.txtMensajeAn.text=modeloCard.descripcion
            if (modeloCard.tipoanuncio == "Reunión"){
                itemView.imgIcnAn.setImageResource(R.drawable.reunion)
            }else if (modeloCard.tipoanuncio == "Capacitación"){
                itemView.imgIcnAn.setImageResource(R.drawable.capacitacion)
            }else if (modeloCard.tipoanuncio == "Exámenes"){
                itemView.imgIcnAn.setImageResource(R.drawable.fecha_examenes)
            }else{
                itemView.imgIcnAn.setImageResource(R.drawable.vacaciones)
            }
            Glide.with(itemView).load(modeloCard.image).into(itemView.imgAn)

            //Glide.with(itemView).load(modeloCard.image).into(itemView.imageIV)

        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {

        val v=LayoutInflater.from(parent.context).inflate(R.layout.fila,parent, false)
        return ViewHolder(v)
    }

    override fun getItemCount(): Int {
        return arrayList.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bindItems(arrayList[position])
        holder.itemView.setOnClickListener{
            val modelo=arrayList.get(position)

        }
    }
}