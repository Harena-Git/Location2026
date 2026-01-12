<template>
  <div class="container">
    <h1>Liste des Proformas</h1>
    <div class="filters">
      <div class="form-section">
        <div class="form-group">
          <label>Date min</label>
          <input type="date" v-model="filters.dateMin" />
        </div>
        <div class="form-group">
          <label>Date max</label>
          <input type="date" v-model="filters.dateMax" />
        </div>
        <div class="form-group">
          <label>Client</label>
          <input v-model="filters.client" placeholder="Nom ou ID client" />
        </div>
        <div class="form-group">
          <label>Magasin</label>
          <input v-model="filters.magasin" placeholder="Nom ou ID magasin" />
        </div>
        <div class="form-group">
          <label>État</label>
          <input v-model="filters.etat" placeholder="État" />
        </div>
      </div>
    </div>
    <div v-if="loading" style="text-align: center; padding: 20px;">
      Chargement...
    </div>
    <div v-else-if="error" style="background: #fdeaea; color: #a94442; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
      Erreur: {{ error }}
    </div>
    <div v-else-if="filteredProformas.length === 0" style="text-align: center; padding: 20px; color: #666;">
      Aucune proforma trouvée
    </div>
    <table v-else>
      <thead>
        <tr>
          <th>ID</th>
          <th>Date</th>
          <th>Client</th>
          <th>Magasin</th>
          <th>Montant</th>
          <th>État</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="p in filteredProformas" :key="p.id">
          <td>
            <router-link :to="`/proforma/fiche/${p.id}`">{{ p.id }}</router-link>
          </td>
          <td>{{ p.daty }}</td>
          <td>{{ p.idClientLib || '-' }}</td>
          <td>{{ p.idMagasinLib || '-' }}</td>
          <td>{{ p.montant || 0 }}</td>
          <td>{{ p.etat }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { fetchProformas } from '@/services/services.js'

const proformas = ref([])
const loading = ref(true)
const error = ref(null)

const today = () => {
  const d = new Date();
  return d.toISOString().slice(0, 10);
};

const filters = ref({ dateMin: today(), dateMax: today(), client: '', magasin: '', etat: '' })

const filteredProformas = computed(() => {
  return proformas.value.filter(p => {
    // Date min
    if (filters.value.dateMin && p.daty && p.daty < filters.value.dateMin) return false
    // Date max
    if (filters.value.dateMax && p.daty && p.daty > filters.value.dateMax) return false
    // Client
    if (filters.value.client && !(String(p.idClient || p.idClientLib || '').toLowerCase().includes(filters.value.client.toLowerCase()))) return false
    // Magasin
    if (filters.value.magasin && !(String(p.idMagasin || p.idMagasinLib || '').toLowerCase().includes(filters.value.magasin.toLowerCase()))) return false
    // Etat
    if (filters.value.etat && !(String(p.etat || '').toLowerCase().includes(filters.value.etat.toLowerCase()))) return false
    return true
  })
})

onMounted(async () => {
  try {
    const data = await fetchProformas()
    if (Array.isArray(data)) {
      proformas.value = data
    } else if (data.data && Array.isArray(data.data)) {
      proformas.value = data.data
    } else if (data.liste && Array.isArray(data.liste)) {
      proformas.value = data.liste
    } else {
      proformas.value = []
    }
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
/* ...copie le style de ton exemple ici... */
</style>