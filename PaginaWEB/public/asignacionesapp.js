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

 //LEER DOCUMENTOS   
 var comboboxcurso = document.getElementById('cmbCurso')
 var comboHorario = document.getElementById('horarioCursos')
    
  //CARGAR SEDES
  db.collection("Sedes").onSnapshot((querySnapshot) => {
    sede.innerHTML='<option>Seleccionar Sede</option> ';
    cmbCarrera.innerHTML='<option>Seleccionar Carrera</option> ';
    cmbCurso.innerHTML='<option>Seleccionar Curso</option> ';
    cmbCode.innerHTML='<option>Código del curso</option> ';
    codigoSede.innerHTML='<option>Código sede</option> ';
    querySnapshot.forEach((doc) => {
      console.log(`${doc.id} => ${doc.data().Nombre}`);
      sede.innerHTML += `
      <option>${doc.data().Nombre}</option>            
      `
      codigoSede.innerHTML += `
      <option>${doc.id}</option>            
      `
    });
  });

   //CARGAR HORARIO
  db.collection("Horario").onSnapshot((querySnapshot) => {
    horario.innerHTML='<option>Seleccionar Horario</option> ';
    querySnapshot.forEach((doc) => {
      console.log(`${doc.id} => ${doc.data().Horario}`);
      horario.innerHTML += `
      <option>${doc.data().Horario}</option>            
      `
    });
  });


function btnSede(){     
  /* Para obtener el valor */
  document.getElementById('codigoSede').options.selectedIndex = document.getElementById('sede').options.selectedIndex;
  
  var cod = document.getElementById("sede").value;
  //alert(cod);
  document.getElementById('cmbSemestre').options.selectedIndex = 0;
  document.getElementById('cmbCarrera').options.selectedIndex = 0;
  document.getElementById('horario').options.selectedIndex = 0;
  document.getElementById('cmbCatedraticos').options.selectedIndex = 0;
  document.getElementById('cmbCodeCatedratico').options.selectedIndex = 0;
  
  removeOptions(document.getElementById('cmbCurso'));
  removeOptions(document.getElementById('cmbCode'));
  cmbCode.innerHTML='<option>Código del curso</option> ';
  cmbCatedraticos.innerHTML='<option>Seleccione al catedrático</option> ';
  
  //cargar las carreras de la sede seleccionada
  db.collection("Carreras").where("Sede", "==", cod).onSnapshot((querySnapshot) => {
    cmbCarrera.innerHTML='<option>Seleccionar Carrera</option> ';
    querySnapshot.forEach((doc) => {
      console.log(`${doc.id} => ${doc.data().Nombre} => ${doc.data().Sede}`);
      cmbCarrera.innerHTML += `
      <option>${doc.data().Nombre}</option>            
      `
      cmbCode.innerHTML += `
      <option>${doc.data().IdCarrera}</option>            
      `
    });
  });

  //Cargar a los catedráticos
  var codigosede = document.getElementById("codigoSede").value;
  db.collection("usuarios").where("Sede", "==", codigosede).onSnapshot((querySnapshot) => {
    cmbCatedraticos.innerHTML='<option>Seleccionar catedrático</option> ';
    querySnapshot.forEach((doc) => {
      console.log(`${doc.id} => ${doc.data().Nombres} => ${doc.data().Sede}`);
      cmbCatedraticos.innerHTML += `
      <option>${doc.data().Nombres} ${doc.data().Apellidos}</option>            
      `
      cmbCodeCatedratico.innerHTML += `
      <option>${doc.data().Codigo}</option>            
      `
    });
  });
}

function btnCarrera(){
  var cod = document.getElementById("cmbCarrera").value;
  //alert(cod); 
  removeOptions(document.getElementById('cmbCurso'));
  document.getElementById('cmbCode').options.selectedIndex = document.getElementById('cmbCarrera').options.selectedIndex;
  document.getElementById('cmbSemestre').options.selectedIndex = 0;
}

function btnSemestre(){
  var semestre = document.getElementById("cmbSemestre").value;
  //alert(semestre); 
  var carrera = document.getElementById("cmbCarrera").value;
  //alert(carrera); 
  var sede = document.getElementById("sede").value;
  //alert(sede);
  var codigoCarrera = Number(document.getElementById("cmbCode").value);  

  //cargar los cursos segun el semestre
  db.collection("Cursos").where("Carrera", "array-contains", codigoCarrera).where("Ciclo", "==", semestre).onSnapshot((querySnapshot) => {
    cmbCurso.innerHTML='<option>Seleccionar Curso</option> ';
    querySnapshot.forEach((doc) => {
      console.log(`${doc.id} => ${doc.data().Nombre} => ${doc.data().Sede}`);
      cmbCurso.innerHTML += `
      <option>${doc.data().Nombre}</option>            
      `
    });
  });
}

//Limpiar un combo
function removeOptions(selectElement) {
  var i, L = selectElement.options.length - 1;
  for(i = L; i >= 0; i--) {
     selectElement.remove(i);
  }
}

var tabla = document.getElementById('tablaDias');


class Node {
  constructor(dia,horainicio,horafin,next){
    this.dia = dia;
    this.horainicio = horainicio;
    this.horafin = horafin;
    this.next = next;
  };
};

class LinkedList {
  constructor(){
    this.head = null;
    this.size = 0;
  };

  add(dia,horainicio,horafin){
    const newNode = new Node(dia,horainicio,horafin,null);
    if(!this.head){
      this.head = newNode
    }else{
      let current = this.head;
      while(current.next){
        current = current.next;
      };
      current.next = newNode;
    };
    this.size++
  };

  print(){
    if(!this.size){
      return null;
    };
    let current = this.head;
    let result  = '';
    while(current){
      tabla.innerHTML +=  `
      <tr>
          <th scope="row">`+current.dia+`</th>
          <td>`+current.horainicio+`</td>
          <td>`+current.horafin+`</td>
      </tr>`;
      result += current.dia;
      current = current.next;
    };
    result += 'X';
    return result;
  }

  printToSave(){
    if(!this.size){
      return null;
    };
    let current = this.head;
    let result  = '';
    while(current){
      result += current.dia+';';
      current = current.next;
    };
    return result;
  }

  printToSaveHora(){
    if(!this.size){
      return null;
    };
    let current = this.head;
    let result  = '';
    while(current){
      result += current.horainicio+'-'+current.horafin+';';
      current = current.next;
    };
    return result;
  }

  eliminarHorario(dia){
    let current = this.head;
    let previous = null;

    while(current != null){
      if(current.dia == dia){
        if(!previous){
          this.head = current.next;
        }else{
          previous.next = current.next;
        };
        this.size--;
        return current.dia;
      };
      previous = current;
      current = current.next;
    };
    return null;
  };

  
deleteAllHorario(){
  let tamanio = this.size;
  //alert('size: '+tamanio);
  return tamanio;
};

deleteAllHorario2(){
  let current = this.head;
  let previous = null;
  let tamanio = this.size;
  //alert('size2: '+tamanio)

  this.head = current.next;
  this.size--;
};

};

const linkedList = new LinkedList();
console.log(linkedList);

function btnHorario(){
  if(document.getElementById("cmbDias").options.selectedIndex != 0){
 //QUITAR VISIBILIDAD
 show();
  /* Para obtener el valor */
  var cod = document.getElementById("cmbDias").value;
  //alert(cod);
  var inicioHora = document.getElementById("mihorainicio").value;
  //alert(inicioHora);
  var finHora = document.getElementById("mihorafin").value;
  //alert(finHora);

  //alert('inicio: '+ inicioHora);
  //alert('fin: '+ finHora);
  $("#tablaDias tr").remove();

  linkedList.add(cod,inicioHora,finHora);
  console.log(linkedList.print());
  console.log(linkedList)
  }else{
    alert('Escoja un dia');
  }
  
 
  
}

function show(){
  var tablaM = document.getElementById('tablaMayor');
  var btnRemover = document.getElementById('eliminarHorario');
  var dayDelete = document.getElementById('dayDelete');
  tablaM.style.visibility = 'visible';
  btnRemover.style.visibility = 'visible';
  dayDelete.style.visibility = 'visible';

}

function deleteSchedule(){
  var diaEliminacion = document.getElementById("dayDelete").value;
  linkedList.eliminarHorario(diaEliminacion);
  $("#tablaDias tr").remove();
  console.log(linkedList.print());
  console.log(linkedList)
  document.getElementById("dayDelete").value = "";
}

function selectCatedratico(){
  document.getElementById('cmbCodeCatedratico').options.selectedIndex = document.getElementById('cmbCatedraticos').options.selectedIndex;
}

function SaveAllData(){
  
if(document.getElementById("sede").options.selectedIndex != 0 && document.getElementById("cmbCarrera").options.selectedIndex != 0 &&
document.getElementById("cmbSemestre").options.selectedIndex != 0 && document.getElementById("cmbCurso").options.selectedIndex != 0 &&
document.getElementById("horario").options.selectedIndex != 0 && document.getElementById("cmbCatedraticos").options.selectedIndex != 0 &&
document.getElementById("cmbDias").options.selectedIndex != 0){
//INICIO
var respuestaDia = linkedList.printToSave();
var respuestaHora = linkedList.printToSaveHora();
  var sede = document.getElementById("sede").value;
  var carrera = document.getElementById("cmbCarrera").value;
  var semestre = document.getElementById("cmbSemestre").value;
  var curso = document.getElementById("cmbCurso").value;
  var tipoHorario = document.getElementById("horario").value;
  var catedratico = document.getElementById("cmbCodeCatedratico").value;
  /*alert('sede: ' + sede);
  alert('carrera: ' + carrera);
  alert('Semestre: ' + semestre);
  alert('Curso: ' + curso);
  alert('Tipo de Horario: ' + tipoHorario);
  alert('Días y Horas: ' + respuestaHora);
  alert('Catedrático: ' + catedratico);*/

  db.collection("Asignacion").add({
    Sede: sede,
    Carrera: carrera,
    Semestre: semestre,
    Curso: curso,
    TipoHorario: tipoHorario,
    Dia: respuestaDia,
    Hora: respuestaHora,
    Catedratico: Number(catedratico)
  })
  .then(function(docRef) {
    console.log("Document written with ID: ", docRef.id);
    document.getElementById("sede").options.selectedIndex = 0;
    document.getElementById("cmbCarrera").options.selectedIndex = 0;
    document.getElementById("cmbSemestre").options.selectedIndex = 0;
    document.getElementById("cmbCurso").options.selectedIndex = 0;
    document.getElementById("horario").options.selectedIndex = 0;
    document.getElementById("cmbCatedraticos").options.selectedIndex = 0;
    document.getElementById("codigoSede").options.selectedIndex = 0;
    document.getElementById("cmbCode").options.selectedIndex = 0;
    document.getElementById("cmbDias").options.selectedIndex = 0;
    document.getElementById("cmbCatedraticos").options.selectedIndex = 0;
    document.getElementById("cmbCodeCatedratico").options.selectedIndex = 0;
    document.getElementById("mihorainicio").value = null;
    document.getElementById("mihorafin").value = null;
  })
  .catch(function(error) {
    console.error("Error adding document: ", error);
  });

  var tam = linkedList.deleteAllHorario();

  //alert('tamaño de tam: ' + tam);
  for (let index = 0; index < tam; index++) {
    linkedList.deleteAllHorario2();
  }

 
  $("#tablaDias tr").remove();
  
  console.log(linkedList.print());
  console.log(linkedList)
  document.getElementById("dayDelete").value = "";
//FINAL
}else{
  alert('Completa todos los campos')
}

  
}

