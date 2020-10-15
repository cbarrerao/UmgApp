auth.onAuthStateChanged(user => {
    if(user){
      console.log('Auth: sign in')
    }else{
      console.log('Auth: sign out')
      window.location.href ='Index.html';
    }
  });

  const logout = document.querySelector('#logout');

  logout.addEventListener('click', e =>{
    e.preventDefault();
    auth.signOut().then(()=>{
      console.log('sign out')
    })
  })

//Agregar documentos
function guardarUsuario(){
    var codigocate = document.getElementById('codigocatedratico').value;
    var cargo = document.getElementById('cargo').value;
   
    
    db.collection("codigoscat").add({
        codigo: Number(codigocate),
        cargo: Number(cargo)        
    })
    .then(function(docRef) {
        console.log("Document written with ID: ", docRef.id);
        document.getElementById('codigocatedratico').value = '';
        document.getElementById('cargo').value = '';
    })
    .catch(function(error) {
        console.error("Error adding document: ", error);
    });
}

//Leer documentos
var tabla = document.getElementById('tablaUsuarios')
db.collection("codigoscat").onSnapshot((querySnapshot) => {
    tabla.innerHTML = ''
    querySnapshot.forEach((doc) => {
        console.log(`${doc.id} => ${doc.data().codigo}`);
        tabla.innerHTML +=  `
        <tr>
            <th scope="row">${doc.data().codigo}</th>
            <td>${doc.data().cargo}</td>
            <td><button class="btn btn-danger" onclick="eliminarUsuario('${doc.id}')">Eliminar</button></td>
            <td><button class="btn btn-warning" onclick="editarUsuario('${doc.id}','${doc.data().codigo}','${doc.data().cargo}')">Editar</button></td>
        </tr>
  `;
    });
});

//Borrar documentos
function eliminarUsuario(idEliminacion){
    db.collection("codigoscat").doc(idEliminacion).delete().then(function(){
        console.log("Document successfully deleted!");
    }).catch(function(error){
        console.error("Error removing document: ", error);
    })
}

//Actualizar Documento

function editarUsuario(idElim,codigocated, cargocate){
    
    document.getElementById('codigocatedratico').value = codigocated;
    document.getElementById('cargo').value = cargocate;
    
    var boton = document.getElementById('boton');
    boton.innerHTML='Editar';

    boton.onclick = function(){

        var washingtonRef = db.collection("codigoscat").doc(idElim);
        // Set the "capital" field of the city 'DC'

        var codcat = document.getElementById('codigocatedratico').value
        var cargocat = document.getElementById('cargo').value
      
            return washingtonRef.update({
                codigo: Number(codcat),
                cargo: Number(cargocat)                
            })
            .then(function() {
                console.log("Document successfully updated!");
                boton.innerHTML='Guardar';
                document.getElementById('codigocatedratico').value = '';
                document.getElementById('cargo').value = '';
            })
            .catch(function(error) {
                // The document probably doesn't exist.
                console.error("Error updating document: ", error);
            });
    }


}