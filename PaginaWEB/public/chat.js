//Sección de LOGOUT
const logout = document.querySelector('#logout');

logout.addEventListener('click', e =>{
  e.preventDefault();
  auth.signOut().then(()=>{
    console.log('sign out')
  })
})

//Varibles globales
var usuarioPrincipal;
var usuarioReceptor;
var uid;
var eliget;
var unsubscribed = null;
const usuariosChat = [];
var fechaActiva = 0;

//Listener Login de la Página
auth.onAuthStateChanged(user => {
    if(user){
      console.log('Auth: sign in ')
      uid = user.uid;
      //Search code using uid
      var docRef = db.collection("usuarios").doc(uid);
      docRef.get().then(function(doc) {
          if (doc.exists) {
              console.log("Document data:", doc.data().Codigo);
              usuarioPrincipal=doc.data().Codigo;
          } else {
              // doc.data() will be undefined in this case
              console.log("No such document!");
          }
      }).catch(function(error) {
          console.log("Error getting document:", error);
      });

    }else{
      console.log('Auth: sign out')
      window.location.href ='Index.html';
    }
  });

//CARGAR USUARIOS
     db.collection("usuarios").onSnapshot((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        console.log(`${doc.id} => ${doc.data().Nombres}`);

        aChat.innerHTML += `<div class="chat_list" onclick="eli(${doc.data().Codigo});"><div class="chat_people"> <input type="text" value="${doc.data().Codigo}" id="${doc.id}" hidden>
        <div class="chat_img"> <img src="https://firebasestorage.googleapis.com/v0/b/appumg-67eca.appspot.com/o/icon.png?alt=media&token=028f100f-e813-4d50-ae9e-fba4dd51bd96"alt="sunil"> </div>
        <div class="chat_ib"><h5>${doc.data().Nombres + " "+  doc.data().Apellidos}<span class="chat_date">${"codigo: "+doc.data().Codigo}</span></h5>
        <p></p></div></div></div>`;
        var fullnames= doc.data().Nombres + " " + doc.data().Apellidos;
        usuariosChat.push({nombre: fullnames ,codigo: doc.data().Codigo});
      });      
    });



function saveMessage(messageText) {
  
  if(messageText==""){

  }else{
    
    //Push a new message to Firebase.
    scrolldown(); 
    console.log("Mensaje obtenido: "+messageText + " Receptor: " + usuarioReceptor);
        // Add a new message entry to the database.
          firebase.firestore().collection('Mensajes').add({
          Emisor: Number(usuarioPrincipal),
          Estado: Number(1),
          Fecha: firebase.firestore.FieldValue.serverTimestamp(),
          Mensaje: messageText,
          Receptor: Number(usuarioReceptor)
        }).catch(function(error) {
          console.error('Error writing new message to database', error);
        });
        document.getElementById('mensaje').value="";
        fechaActiva = 1;
        
  }
  }
  

function eli(eliget){
   
if(unsubscribed == null){
  retrieveData(eliget);
}else{
  unsubscribed();
  fechaActiva=0;
  retrieveData(eliget);
}
}

function retrieveData(eliget){
  document.getElementById("msgHistory").innerHTML="";
  console.log("WHAT ELI GETS: "+ eliget);
  
  usuarioReceptor=eliget;
  
  document.getElementById("msgHistory").innerHTML="";
    var query = db.collection('Mensajes').orderBy('Fecha', 'asc');
    console.log("USUARIO PRINCIPAL LOGUEADO: " + usuarioPrincipal );
    // Start listening to the query.
     unsubscribed= query.onSnapshot({ includeMetadataChanges: true }, function(snapshot) {
      snapshot.docChanges().forEach(function(change) {
        
        scrolldown();
        if (change.type === "added") {
          if (fechaActiva == 0) {
            var message = change.doc.data();    
          console.log("EMISOR: " + message.Emisor + " RECEPTOR: "+ message.Receptor);
        
        if(message.Emisor == usuarioPrincipal && message.Receptor == usuarioReceptor){
          document.getElementById("msgHistory").innerHTML +=`
                <div class="outgoing_msg"> 
                <div class="sent_msg"> 
                <p>${message.Mensaje}</p>
                <span class="time_date">${message.Fecha.toDate()}</span></div></div>`;
                    
        }else if(message.Emisor == usuarioReceptor && message.Receptor == usuarioPrincipal){
          document.getElementById("msgHistory").innerHTML +=`
                <div class="incoming_msg"> 
                <div class="received_msg"> 
                <div class="received_withd_msg"> 
                <p>${message.Mensaje}</p>
                <span class="time_date">${message.Fecha.toDate()}</span></div></div></div>`;
        }
          }else{
            var message = change.doc.data();    
          console.log("EMISOR: " + message.Emisor + " RECEPTOR: "+ message.Receptor);
        
        if(message.Emisor == usuarioPrincipal && message.Receptor == usuarioReceptor){
          document.getElementById("msgHistory").innerHTML +=`
                <div class="outgoing_msg"> 
                <div class="sent_msg"> 
                <p>${message.Mensaje}</p>
                <span class="time_date">${firebase.firestore.Timestamp.now().toDate()}</span></div></div>`;
                    
        }else if(message.Emisor == usuarioReceptor && message.Receptor == usuarioPrincipal){
          document.getElementById("msgHistory").innerHTML +=`
                <div class="incoming_msg"> 
                <div class="received_msg"> 
                <div class="received_withd_msg"> 
                <p>${message.Mensaje}</p>
                <span class="time_date">${firebase.firestore.Timestamp.now().toDate()}</span></div></div></div>`;
        }
          }

        }
        if (change.type === "modified") {
            console.log("Modified city: ", change.doc.data());
        }
        if (change.type === "removed") {
            console.log("Removed city: ", change.doc.data());
        }
    
        var source = snapshot.metadata.fromCache ? "local cache" : "server";
              console.log("Data came from " + source);
      
          
      });
    });  
}

//Muestra los ultimos mensajes enviados al chat
function scrolldown(){
  var DIV = document.getElementById('msgHistory');
  DIV.scrollTop = DIV.scrollHeight;
}

function busqueda (){
  alert("Hello");
}


const formulario = document.querySelector('#txtBusqueda');
const boton = document.querySelector('#btnBusqueda');

const filtrar = () =>{
document.getElementById("aChat").innerHTML="";
//console.log(formulario.value);
const texto = formulario.value.toLowerCase();
  for(let usuariochat of usuariosChat){
    let nombre = usuariochat.nombre.toLowerCase(); 
    //console.log(nombre);
    if (nombre.indexOf(texto)!==-1) {
      aChat.innerHTML += `<div class="chat_list" onclick="eli(${usuariochat.codigo});"><div class="chat_people"> <input type="text" value="${usuariochat.codigo}"  hidden>
          <div class="chat_img"> <img src="https://firebasestorage.googleapis.com/v0/b/appumg-67eca.appspot.com/o/icon.png?alt=media&token=028f100f-e813-4d50-ae9e-fba4dd51bd96"alt="sunil"> </div>
          <div class="chat_ib"><h5>${usuariochat.nombre}<span class="chat_date">${"codigo: "+usuariochat.codigo}</span></h5>
          <p></p></div></div></div>`;
    } 
  }
}
formulario.addEventListener('keyup',filtrar)
filtrar();


//Parte importante
/*
 if (change.type === "added") {
   
  }
  if (change.type === "modified") {
      console.log("Modified city: ", change.doc.data());
  }
  if (change.type === "removed") {
      console.log("Removed city: ", change.doc.data());
  }

*/