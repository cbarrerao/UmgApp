
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