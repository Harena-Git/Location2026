<template>
  <form @submit.prevent="submit">
    <!-- Informations principales -->
    <div class="card">
      <div class="card-title">Informations Principales</div>
      <div class="form-section">
        <div class="form-group">
          <label>Date</label>
          <input type="date" v-model="form.daty" required />
        </div>
        <div class="form-group">
          <label>Client</label>
          <input list="clients" v-model="form.idClient" required placeholder="Sélectionnez un client" />
          <datalist id="clients">
            <option v-for="c in clients" :key="c.id" :value="c.id">{{ c.nom }}</option>
          </datalist>
        </div>
        <div class="form-group">
          <label>Désignation</label>
          <input type="text" v-model="form.designation" placeholder="Titre de la proforma" />
        </div>
        <div class="form-group">
          <label>Remarque</label>
          <input type="text" v-model="form.remarque" placeholder="Remarques ou commentaires" />
        </div>
      </div>
    </div>
    <!-- Détails Financiers & Logistiques -->
    <div class="card">
      <div class="card-title">Détails Financiers & Logistiques</div>
      <div class="form-section">
        <div class="form-group">
          <label>Magasin</label>
          <input type="hidden" v-model="form.idMagasin" />
          <input type="text" value="Ankorahotra" readonly disabled style="background:#eee;" />
        </div>
        <div class="form-group">
          <label>Lieu de Location</label>
          <input type="text" v-model="form.lieuLocation" placeholder="Lieu de location" />
        </div>
        <div class="form-group">
          <label>Remise (%)</label>
          <input type="number" v-model.number="form.remise" min="0" max="100" step="0.01" />
        </div>
        <div class="form-group">
          <label>Caution (%)</label>
          <input type="number" v-model.number="form.caution" min="0" max="100" step="0.01" />
        </div>
        <div class="form-group">
          <label>Date Début Réservation</label>
          <input type="date" v-model="form.dateDebutReservation" required />
        </div>
        <div class="form-group">
          <label>État</label>
          <input type="number" v-model.number="form.etat" min="0" max="20" />
        </div>
      </div>
    </div>
    <!-- Détails des Produits -->
    <div class="card">
      <div class="card-title">Détails des Produits</div>
      <button type="button" class="btn btn-add" @click="addProduit">Ajouter un Produit</button>
      <table>
        <thead>
          <tr>
            <th>Produit</th>
            <th>Désignation</th>
            <th>Dimension</th>
            <th>Qté (Article)</th>
            <th>Qté (Jours)</th>
            <th>Prix Unitaire</th>
            <th>Unité</th>
            <th>Date Début</th>
            <th>Image</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(prod, i) in form.details" :key="i">
            <td>
              <select v-model="prod.idProduit" @change="fillProduit(prod)">
                <option value="">-- Choisir --</option>
                <option v-for="p in produits" :key="p.id" :value="p.id">{{ p.libelle }}</option>
              </select>
            </td>
            <td><input type="text" v-model="prod.designation" /></td>
            <td><input type="text" v-model="prod.dimension" /></td>
            <td><input type="number" v-model.number="prod.nombre" min="1" /></td>
            <td><input type="number" v-model.number="prod.qte" min="1" /></td>
            <td><input type="number" v-model.number="prod.pu" min="0" /></td>
            <td><input type="text" v-model="prod.unite" /></td>
            <td><input type="date" v-model="prod.dateDebut" /></td>
            <td><input type="text" v-model="prod.image" /></td>
            <td><button type="button" class="btn btn-danger" @click="removeProduit(i)">Supprimer</button></td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="actions">
      <button type="reset" class="btn btn-secondary" @click.prevent="reset">Réinitialiser</button>
      <button type="submit" class="btn btn-primary">Enregistrer</button>
    </div>
  </form>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { fetchProformaClients, fetchProformaProduits, creerProforma } from '@/services/services.js'

const emit = defineEmits(['saved'])

const clients = ref([])
const produits = ref([])

const today = () => {
  const d = new Date();
  return d.toISOString().slice(0, 10);
};

const form = reactive({
  daty: today(),
  idClient: '',
  designation: '',
  remarque: '',
  idMagasin: 'PNT000086',
  lieuLocation: '',
  remise: 0,
  caution: 0,
  dateDebutReservation: today(),
  etat: 1,
  details: []
})

async function fetchClients() {
  clients.value = await fetchProformaClients()
}
async function fetchProduits() {
  produits.value = await fetchProformaProduits()
}
onMounted(() => {
  fetchClients()
  fetchProduits()
  addProduit()
})

function addProduit() {
  form.details.push({
    idProduit: '',
    designation: '',
    dimension: '',
    nombre: 1,
    qte: 1,
    pu: 0,
    unite: '',
    dateDebut: today(),
    image: ''
  })
}
function removeProduit(i) {
  form.details.splice(i, 1)
}
function fillProduit(prod) {
  const p = produits.value.find(x => x.id === prod.idProduit)
  if (p) {
    prod.designation = p.libelle || ''
    prod.dimension = p.dimension || ''
    prod.pu = p.pu || 0
    prod.unite = p.unite || ''
    prod.image = p.image || ''
  }
}
function reset() {
  Object.assign(form, {
    daty: '',
    idClient: '',
    designation: '',
    remarque: '',
    idMagasin: 'PNT000086',
    lieuLocation: '',
    remise: 0,
    caution: 0,
    dateDebutReservation: '',
    etat: 0,
    details: []
  })
  addProduit()
}
async function submit() {
  const data = JSON.parse(JSON.stringify(form))
  data.details = data.details.filter(d => d.idProduit)
  try {
    const result = await creerProforma(data)
    emit('saved', { success: result.success, message: result.success ? `Proforma créé avec succès ! ID: ${result.id}` : (result.error || 'Erreur inconnue') })
    if (result.success) reset()
  } catch (e) {
    emit('saved', { success: false, message: 'Erreur de connexion: ' + e.message })
  }
}
</script>

<style scoped>
/* ...copie le style de ton exemple ici... */
</style>