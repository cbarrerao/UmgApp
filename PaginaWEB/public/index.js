const signInForm = document.querySelector('#signin-form');

signInForm.addEventListener('submit', (e) =>{
  e.preventDefault();

  const email = document.querySelector('#signin-email').value;
  const password = document.querySelector('#signin-password').value;

  console.log('submited: ' + email, password );

  //Aqui inicia para sign up
  auth
      .signInWithEmailAndPassword(email, password)
      .then(userCredential => {
        //Clear the form
        signInForm.reset();

        //Close the modal
        $('#signInModal').modal('hide')
        console.log('sign in')
        auth.onAuthStateChanged(user => {
          if(user){
            onclick=location.href ='Principal.html';
          }else{
            console.log('Auth: sign afuera')
          }
        });

      })

}); 

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
  }
});