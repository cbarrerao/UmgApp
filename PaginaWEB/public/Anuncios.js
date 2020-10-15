//Sección de LOGOUT
const logout = document.querySelector('#logout');

logout.addEventListener('click', e =>{
  e.preventDefault();
  auth.signOut().then(()=>{
    console.log('sign out')
  })
})

//Listener Login de la Página
auth.onAuthStateChanged(user => {
  if(user){
    console.log('Auth: sign in')
  }else{
    console.log('Auth: sign out')
    window.location.href ='Index.html';
  }
});

//INICIO DE SUBIDA
window.onload = inicializar;
var fichero;
var variableRuta;

function inicializar(){
    fichero = document.getElementById("fileArchivo");
    fichero.addEventListener("change",subirImagenAFirebase,false);    
    mostrarImagenesDeFirebase();

}


function mostrarImagenesDeFirebase(){

}

function subirImagenAFirebase(){
    //alert("Subir imagen a irebase");
    var imagenASubir = fichero.files[0];
    var uploadTask = storageRef.child(imagenASubir.name).put(imagenASubir);
    showOp();
    uploadTask.on('state_changed',
    function(snapshot){
        //se va mostrando el progreso de la subida de la imagen
        var barraProgreso = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        document.getElementById("barraProgresista").style.width = barraProgreso + "%";
    }, function(error){
        //Gestionar el error si se produce
        alert('Ha habido un error');
    }, function(){        
        //cuando se ha subido exitosamente la imagen
        storageRef.child(imagenASubir.name).getDownloadURL().then(function(url) {
            // Or inserted into an <img> element:
            var img = document.getElementById('Imagen-de-firebase');
            img.src = url;           
            variableRuta = url;
            //alert('SE SUBIÓ LA IMAGEN, direccion Imagen: ' + url);
            console.log(url);
            hideOp();
            
        }).catch(function(error) {
            // Handle any errors
        });

    });
}

function hideOp(){
    var barrita = document.getElementById('barrasNestle');   
    barrita.style="visibility: hidden" 
}

function showOp(){
    var barrita = document.getElementById('barrasNestle');
    barrita.style="visibility: visible"
}

function guardarAnuncio(){

  if(document.getElementById("cmbTipoAnuncio").options.selectedIndex != 0 && document.getElementById("cmbCarreras").options.selectedIndex != 0 &&
  document.getElementById("txtTitulo").value!='' && document.getElementById("txtContenido").value!=''){
    
  var guardarImagen = document.getElementById('addImagen').checked;
  var noGuardarImagen = document.getElementById('noAddImagen').checked;
  //SI ELIGIÓ GUARDAR IMAGEN
  if(guardarImagen == true && noGuardarImagen==false){
      //alert('Ruta de imagen: ' + variableRuta);
      var carrera = document.getElementById('cmbCarreras').value;
      var titulo = document.getElementById('txtTitulo').value;
      var contenido = document.getElementById('txtContenido').value;
      var tipoAnuncio = document.getElementById('cmbTipoAnuncio').value;
      
      //alert('Carrera: ' + carrera);
      //alert('Título: ' + titulo);
      //alert('Contenido: ' + contenido);  
     //var fechita = firebase.firestore.FieldValue.serverTimestamp();
     //alert('Fechita: ' + fechita);
     //console.log('FECHA I GUESS: ' + fechita);
  
     db.collection(carrera).add({
         Escuela: carrera,
         Titulo: titulo,
         Contenido:contenido,
         Imagen: variableRuta,
         Fecha: firebase.firestore.FieldValue.serverTimestamp(),
         TipoAnuncio: tipoAnuncio
  
     })
     .then(function(docRef) {
         console.log("Document written with ID: ", docRef.id);
         document.getElementById("cmbCarreras").options.selectedIndex = 0;
         document.getElementById("cmbTipoAnuncio").options.selectedIndex = 0;
         document.getElementById('txtTitulo').value = '';
         document.getElementById('txtContenido').value = '';
         document.getElementById('addImagen').checked = null;
         document.getElementById('noAddImagen').checked = null;
         
     })
     .catch(function(error) {
         console.error("Error adding document: ", error);
     });
  
     var grupoAdding = document.getElementById('grupoAgregar');
    var imagenPro = document.getElementById('Imagen-de-firebase');
    grupoAdding.style="visibility: hidden"
    imagenPro.style="visibility: hidden"

     imagen = document.getElementById("Imagen-de-firebase");	
    /*if (!imagen){
      alert("El elemento no existe");
    } else {
      padre = imagen.parentNode;
      padre.removeChild(imagen);
    }*/
    //SI ELIGIÓ NO GUARDAR IMAGEN
  }else if(noGuardarImagen == true && guardarImagen==false){
   
    var carrera = document.getElementById('cmbCarreras').value;
    var titulo = document.getElementById('txtTitulo').value;
    var contenido = document.getElementById('txtContenido').value;
    var tipoAnuncio = document.getElementById('cmbTipoAnuncio').value;

   db.collection(carrera).add({
       Escuela: carrera,
       Titulo: titulo,
       Contenido:contenido,
       //Imagen: 'https://firebasestorage.googleapis.com/v0/b/appumg-67eca.appspot.com/o/noimagen.jpg?alt=media&token=f829f42d-c4f7-442d-bcac-ea445bd5e9ef',
       Fecha: firebase.firestore.FieldValue.serverTimestamp(),
       TipoAnuncio: tipoAnuncio

   })
   .then(function(docRef) {
       console.log("Document written with ID: ", docRef.id);
       document.getElementById("cmbCarreras").options.selectedIndex = 0;
       document.getElementById("cmbTipoAnuncio").options.selectedIndex = 0;
       document.getElementById('txtTitulo').value = '';
       document.getElementById('txtContenido').value = '';       
       document.getElementById('addImagen').checked = false;
       document.getElementById('noAddImagen').checked = false;
   })
   .catch(function(error) {
       console.error("Error adding document: ", error);
   });

   imagen = document.getElementById("Imagen-de-firebase");

 /* if (!imagen){
    alert("El elemento no existe");
  } else {
    padre = imagen.parentNode;
    padre.removeChild(imagen);
  }*/
}
  }else{
    alert('Completa todos los campos')
  }


}

function verificacion(){
  var guardarImagen = document.getElementById('addImagen').checked;
  var noGuardarImagen = document.getElementById('noAddImagen').checked;
  
    var grupoAdding = document.getElementById('grupoAgregar');
    var imagenPro = document.getElementById('Imagen-de-firebase');
    grupoAdding.style="visibility: visible";
    imagenPro.style="visibility: visible";
    
    //alert('checkbox1 esta seleccionado');
 
}

function verificacion2(){
  var guardarImagen = document.getElementById('addImagen').checked;
  var noGuardarImagen = document.getElementById('noAddImagen').checked;
    //alert('checkbox2 esta seleccionado');
    var grupoAdding = document.getElementById('grupoAgregar');
    var imagenPro = document.getElementById('Imagen-de-firebase');
    grupoAdding.style="visibility: hidden"
    imagenPro.style="visibility: hidden"

}