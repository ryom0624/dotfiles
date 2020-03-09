<template>
  <div>
    <div align="center">
      <button  id="auth_button" @click="signIn">signIn</button>        
    </div>
  </div>
</template>


<script>
import firebase from 'firebase'

export default {
  name: 'Signin',
  data: function () {
    return {
    }
  },
  methods: {
    signIn: function () {
      const provider = new firebase.auth.GoogleAuthProvider()
      firebase.auth().signInWithRedirect(provider)
    },
  },
}
</script>

<style lang="css" scoped>
  #auth_button {
    margin: 120px 0;
    border: 1px solid #ddd;
    background-color: #ddd;
  }
</style>
