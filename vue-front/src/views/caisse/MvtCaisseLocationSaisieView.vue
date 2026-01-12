<template>
  <div class="content-wrapper">
    <h1>Paiement de la location</h1>
    <form @submit.prevent="submitForm">
      <div class="row">
        <div class="col-md-6">
          <label>Date</label>
          <input type="date" v-model="form.daty" class="form-control" required />
        </div>
        <div class="col-md-6">
          <label>Désignation</label>
          <input type="text" v-model="form.designation" class="form-control" />
        </div>
      </div>
      <div class="row">
        <div class="col-md-6">
          <label>Caisse</label>
          <select v-model="form.idCaisse" class="form-control" required>
            <option v-for="caisse in caisses" :key="caisse.id" :value="caisse.id">
              {{ caisse.val }}
            </option>
          </select>
        </div>
        <div class="col-md-6">
          <label>Montant</label>
          <input type="number" v-model="form.montant" class="form-control" required />
        </div>
      </div>
      <div class="row mt-3">
        <div class="col-md-6">
          <button type="reset" class="btn btn-secondary">Réinitialiser</button>
        </div>
        <div class="col-md-6 text-right">
          <button type="submit" class="btn btn-primary">Enregistrer</button>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

function todayISO() {
  const d = new Date()
  return d.toISOString().slice(0, 10)
}

const form = ref({
  daty: todayISO(),
  designation: '',
  idCaisse: '',
  montant: 0,
  idOrigine: '', // id de la vente
  tiers: ''
})

const caisses = ref([])

onMounted(async () => {
  form.value.idOrigine = route.query.idOrigine || ''
  form.value.montant = route.query.montant || 0
  form.value.tiers = route.query.tiers || ''
  form.value.designation = 'Payment facture ' + form.value.idOrigine

  // Charger la liste des caisses
  const respCaisses = await fetch('/asynclocation/api/caisse/liste')
  caisses.value = await respCaisses.json()
})

async function submitForm() {
  try {
    const payload = { ...form.value }
    const resp = await fetch('/asynclocation/api/caisse/mvt-location', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
    const result = await resp.json()
    if (result.success) {
      alert('Paiement enregistré !')
      router.push('/vente/fiche/' + form.value.idOrigine)
    } else {
      alert('Erreur : ' + (result.error || JSON.stringify(result)))
    }
  } catch (e) {
    alert('Erreur JS : ' + e)
  }
}
</script>