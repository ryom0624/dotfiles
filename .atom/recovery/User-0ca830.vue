<template>
  <div>
    <h1 class="username" v-if="isAuth" align="center">Welcome to {{this.user}} !!</h1>
    <div class="links" align="center">
      <a v-if="isAuth" @click="signOut" class="auth_button">signOut</a>
    </div>
  </div>
</template>


<script>
import firebase from 'firebase'

export default {
  name: 'Signin',
  data: function () {
    return {
      isAuth: false,
      user: firebase.auth().currentUser.displayName
    }
  },
  methods: {
    signOut: function () {
      firebase.auth().signOut()
    }
  },
}
</script>

<style lang="css" scoped>
  .username {
    margin: 120px auto;
  }
  .links{
    margin: 120px auto;
  }
  .auth_button {
    border: 1px solid #ddd;
  }
</style>
