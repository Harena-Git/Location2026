<template>
  <div class="content-wrapper">
    <section class="content-header">
      <h1>Liste des réservations</h1>
    </section>
    <section class="content">
      <form class="apj-form" @submit.prevent="onFiltrer">
        <div class="apj-form-row">
          <input type="date" v-model="filters.dateMin" placeholder="Date min" class="apj-form-input" />
          <input type="date" v-model="filters.dateMax" placeholder="Date max" class="apj-form-input" />
          <input type="text" v-model="filters.idClient" placeholder="Client" class="apj-form-input" />
          <select v-model="filters.etatPayment" class="apj-form-input">
            <option value="">État paiement</option>
            <option value="17">Accompte</option>
            <option value="16">Payé Totalité</option>
          </select>
          <select v-model="filters.etatLogistique" class="apj-form-input">
            <option value="">État logistique</option>
            <option value="12">À Préparer</option>
            <option value="13">Expédié(e)</option>
            <option value="14">Bouclé(e)</option>
          </select>
          <button type="submit" class="apj-btn">Filtrer</button>
        </div>
      </form>
      <div class="list-container">
        <table class="apj-list-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Client</th>
              <th>Date</th>
              <th>Remarque</th>
              <th>État Payment</th>
              <th>État Logistique</th>
              <th>Montant</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="resa in reservations" :key="resa.id">
              <td>
                <router-link :to="`/reservation/fiche/${resa.id}`">{{ resa.id }}</router-link>
              </td>
              <td>{{ resa.client }}</td>
              <td>{{ resa.date }}</td>
              <td>{{ resa.remarque }}</td>
              <td>{{ resa.etatPayment }}</td>
              <td>{{ resa.etatLogistique }}</td>
              <td>{{ resa.montant }}</td>
            </tr>
          </tbody>
        </table>
        <div class="apj-list-summary">
          Total : {{ total }} réservation(s) &mdash; Somme montant : {{ sommeMontant }} Ar
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { fetchReservations } from '@/services/services.js'

const allReservations = ref([])
const reservations = ref([])
const total = ref(0)
const sommeMontant = ref(0)

const today = () => {
  const d = new Date();
  return d.toISOString().slice(0, 10);
};

const filters = ref({
  // Par défaut, on n'applique pas de filtre de date pour afficher tout
  dateMin: '',
  dateMax: '',
  idClient: '',
  etatPayment: '',
  etatLogistique: ''
})

function applyFilters() {
  let filtered = allReservations.value
  if (filters.value.dateMin) {
    filtered = filtered.filter(r => r.date && r.date >= filters.value.dateMin)
  }
  if (filters.value.dateMax) {
    filtered = filtered.filter(r => r.date && r.date <= filters.value.dateMax)
  }
  if (filters.value.idClient) {
    filtered = filtered.filter(r => (r.client || '').toLowerCase().includes(filters.value.idClient.toLowerCase()))
  }
  if (filters.value.etatPayment) {
    filtered = filtered.filter(r => String(r.etatPayment) === String(filters.value.etatPayment) || String(r.etatPaymentLib) === String(filters.value.etatPayment))
  }
  if (filters.value.etatLogistique) {
    filtered = filtered.filter(r => String(r.etatLogistique) === String(filters.value.etatLogistique) || String(r.etatLogistiqueLib) === String(filters.value.etatLogistique))
  }
  reservations.value = filtered
  total.value = filtered.length
  sommeMontant.value = filtered.reduce((sum, r) => sum + (Number(r.montant) || 0), 0)
}

async function loadReservations() {
  const data = await fetchReservations()
  // Accepte soit un tableau brut, soit un objet { data: [...] }
  if (Array.isArray(data)) {
    allReservations.value = data
  } else {
    allReservations.value = data.data || []
  }
  applyFilters()
}

function onFiltrer() {
  applyFilters()
}

onMounted(loadReservations)
</script>

<style scoped>

</style>