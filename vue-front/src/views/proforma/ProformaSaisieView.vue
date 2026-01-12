<template>
  <div class="container">
    <h1>Saisie Proforma</h1>
    <ProformaForm @saved="handleSaved" />
    <div v-if="result" :class="['result', resultType]">{{ result }}</div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import ProformaForm from './ProformaForm.vue'

const result = ref('')
const resultType = ref('')

function handleSaved({ success, message }) {
  result.value = message
  resultType.value = success ? 'success' : 'error'
  setTimeout(() => result.value = '', 5000)
}
</script>

<style scoped>
/* ...copie le style de ton exemple ici... */
</style>