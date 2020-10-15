
const logout = document.querySelector('#logout');

logout.addEventListener('click', e =>{
  e.preventDefault();
  auth.signOut().then(()=>{
    console.log('sign out')
  })
})

//Events
//list for auth state changes
auth.onAuthStateChanged(user => {
  if(user){
    console.log('Auth: sign in')
  }else{
    console.log('Auth: sign out')
    window.location.href ='Index.html';
  }
});
//Agregar documentos
function guardarUsuario(){
    var nombres = document.getElementById('nombre').value;
    var apellidos = document.getElementById('apellido').value;
    var codigocat = document.getElementById('codigocat').value;
    var titulocat = document.getElementById('titulocat').value;
    
    db.collection("usuarios").add({
        Nombres: nombres,
        Apellidos: apellidos,
        Codigo: codigocat,
        Titulo: titulocat
    })
    .then(function(docRef) {
        console.log("Document written with ID: ", docRef.id);
        document.getElementById('nombre').value = '';
        document.getElementById('apellido').value = '';
        document.getElementById('codigocat').value = '';
        document.getElementById('titulocat').value = '';
    })
    .catch(function(error) {
        console.error("Error adding document: ", error);
    });
}

//Leer documentos
var tabla = document.getElementById('tablaUsuarios')
db.collection("usuarios").onSnapshot((querySnapshot) => {
    tabla.innerHTML = ''
    querySnapshot.forEach((doc) => {
        console.log(`${doc.id} => ${doc.data().Nombres}`);
        tabla.innerHTML +=  `
        <tr>
            <th scope="row">${doc.data().Codigo}</th>
            <td>${doc.data().Nombres}</td>
            <td>${doc.data().Apellidos}</td>
            <td>${doc.data().Titulo}</td>
            <td><button class="btn btn-danger" onclick="eliminarUsuario('${doc.id}')">Eliminar</button></td>
            <td><button class="btn btn-warning" onclick="editarUsuario('${doc.id}','${doc.data().Nombres}','${doc.data().Apellidos}','${doc.data().Codigo}','${doc.data().Titulo}')">Editar</button></td>
        </tr>
  `;
    });
});

//Borrar documentos
function eliminarUsuario(idEliminacion){
    db.collection("usuarios").doc(idEliminacion).delete().then(function(){
        console.log("Document successfully deleted!");
    }).catch(function(error){
        console.error("Error removing document: ", error);
    })
}

//Actualizar Documento

function editarUsuario(idElim,nombresusu,apellidosusu,codigocatusu,titulocatusu){
    
    document.getElementById('nombre').value = nombresusu;
    document.getElementById('apellido').value = apellidosusu;
    document.getElementById('codigocat').value = codigocatusu;
    document.getElementById('titulocat').value = titulocatusu;
    var boton = document.getElementById('boton');
    boton.innerHTML='Editar';

    boton.onclick = function(){

        var washingtonRef = db.collection("usuarios").doc(idElim);
        // Set the "capital" field of the city 'DC'

        var nombreusuario = document.getElementById('nombre').value
        var apellidousuario = document.getElementById('apellido').value
        var codigocatusuario = document.getElementById('codigocat').value
        var titulocatusuario = document.getElementById('titulocat').value

            return washingtonRef.update({
                Nombres: nombreusuario,
                Apellidos: apellidousuario,
                Codigo: codigocatusuario,
                Titulo: titulocatusuario
            })
            .then(function() {
                console.log("Document successfully updated!");
                boton.innerHTML='Guardar';
            })
            .catch(function(error) {
                // The document probably doesn't exist.
                console.error("Error updating document: ", error);
            });
    }


}