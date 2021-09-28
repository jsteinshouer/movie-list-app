<template>
  <div class="home">
    <h1>{{message}}</h1>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data() {
    return {
      message: ""
    }
  },
  mounted() {
    let vm = this;
    
    this.axios.get( "/api/echo" ).then((response) => {
      vm.message = response.data.data;
    })

  }
}
</script>
