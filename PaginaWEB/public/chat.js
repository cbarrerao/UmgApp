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

      });      
    });



function saveMessage(messageText) {
    //Push a new message to Firebase.
    scrolldown(); 
    console.log("Mensaje obtenido: "+messageText + " Receptor: " + usuarioReceptor);
        // Add a new message entry to the database.
        return firebase.firestore().collection('Mensajes').add({
          Emisor: Number(usuarioPrincipal),
          Estado: Number(1),
          Fecha: firebase.firestore.FieldValue.serverTimestamp(),
          Mensaje: messageText,
          Receptor: Number(usuarioReceptor)
        }).catch(function(error) {
          console.error('Error writing new message to database', error);
        });        
  }
  

function eli(eliget){

document.getElementById("msgHistory").innerHTML="";
console.log("WHAT ELI GETS: "+ eliget);

usuarioReceptor=eliget;

let query = db.collection('Mensajes').orderBy('Fecha', 'asc');
console.log("USUARIO PRINCIPAL LOGUEADO: " + usuarioPrincipal );
// Start listening to the query.
 unsubscribed = query.onSnapshot(function(snapshot) {
  snapshot.docChanges().forEach(function(change) {

    scrolldown();
    
    if (change.type === "added") {
    var message = change.doc.data();    
    console.log("EMISOR: " + message.Emisor + " RECEPTOR: "+ message.Receptor);
    
    if(message.Emisor == usuarioPrincipal && message.Receptor == usuarioReceptor){
      document.getElementById("msgHistory").innerHTML +=`
            <div class="outgoing_msg"> 
            <div class="sent_msg"> 
            <p>${message.Mensaje}</p>
            <span class="time_date">${message.Fecha}</span></div></div>`;
                
    }else if(message.Emisor == usuarioReceptor && message.Receptor == usuarioPrincipal){
      document.getElementById("msgHistory").innerHTML +=`
            <div class="incoming_msg"> 
            <div class="received_msg"> 
            <div class="received_withd_msg"> 
            <p>${message.Mensaje}</p>
            <span class="time_date">${message.Fecha}</span></div></div></div>`;
    }
  }
      
  });
});
}


//Muestra los ultimos mensajes enviados al chat
function scrolldown(){
  var DIV = document.getElementById('msgHistory');
  DIV.scrollTop = DIV.scrollHeight;
}



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