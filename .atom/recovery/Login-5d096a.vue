<template>
  <div>
    <div class="links" align="center">
      <a v-if="isAuth" @click="signOut" class="auth_button">signOut</a>
      <a v-else @click="signIn" class="auth_button">signIn</a>
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
      user: ''
    }
  },
  mounted: function () {
    firebase.auth().onAuthStateChanged((user) => {
      this.isAuth = !!user
      this.user = user.displayName
    })
  },
  methods: {
    signIn: function () {
      const provider = new firebase.auth.GoogleAuthProvider()
      firebase.auth().signInWithRedirect(provider)
      this.$router.push('/admin/mypage')
    },
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
