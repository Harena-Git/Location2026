<template>
  <div class="proforma-fiche-view">
    <h2>Fiche de la facture proforma</h2>
    <div v-if="loading">Chargement...</div>
    <div v-else-if="error" class="error">Erreur : {{ error }}</div>
    <div v-else>
      <div class="fiche-header">
        <div class="fiche-info">
          <div><strong>Id</strong> : {{ fiche.id }}</div>
          <div><strong>Désignation</strong> : {{ fiche.designation || '-' }}</div>
          <div><strong>Magasin</strong> : {{ fiche.magasin }}</div>
          <div><strong>Date</strong> : {{ formatDate(fiche.date) }}</div>
          <div><strong>Client</strong> : {{ fiche.client }}</div>
          <div><strong>État</strong> : {{ fiche.etat }}</div>
          <div><strong>Devise</strong> : {{ fiche.devise }}</div>
          <div><strong>Remarque</strong> : {{ fiche.remarque || '-' }}</div>
          <div><strong>Montant sans remise</strong> : {{ fiche.montantSansRemise }}</div>
          <div><strong>Montant de la remise</strong> : {{ fiche.montantRemise }}</div>
          <div><strong>Montant restant</strong> : {{ fiche.montantRestant }}</div>
          <div><strong>Remise</strong> : {{ fiche.remise }}</div>
          <div><strong>Période</strong> : {{ formatDate(fiche.periode) }}</div>
          <div><strong>État Payment</strong> : <span v-html="fiche.etatPayment"></span></div>
          <div><strong>Lieu de location</strong> : {{ fiche.lieuLocation || '-' }}</div>
        </div>
        <!-- Bouton Créer BC -->
        <button @click="creerBC" :disabled="loadingBC" class="btn btn-primary" style="margin-top:1rem;">
          Créer BC
        </button>
        <div v-if="loadingBC" style="margin-top:0.5rem;">Création en cours...</div>
        <div v-if="messageBC" style="margin-top:0.5rem;">{{ messageBC }}</div>
      </div>
      <h3>Détails</h3>
      <table class="fiche-details">
        <thead>
          <tr>
            <th>Id</th>
            <th>Produit</th>
            <th>Désignation</th>
            <th>Image</th>
            <th>Quantité (Article)</th>
            <th>Quantité (En Jour)</th>
            <th>Date De Début</th>
            <th>Prix Unitaire</th>
            <th>Montant De La Remise</th>
            <th>Montant</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="d in fiche.details" :key="d.id">
            <td>{{ d.id }}</td>
            <td>{{ d.produit }}</td>
            <td>{{ d.designation }}</td>
            <td>
              <img v-if="d.image" :src="d.image" alt="img" style="max-width:40px;max-height:40px;" />
            </td>
            <td>{{ d.quantiteArticle }}</td>
            <td>{{ d.quantiteJour }}</td>
            <td>{{ formatDate(d.dateDebut) }}</td>
            <td>{{ d.prixUnitaire }}</td>
            <td>{{ d.montantRemise }}</td>
            <td>{{ d.montant }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { fetchProformaFiche, validerProforma } from '@/services/services.js';

const route = useRoute();
const fiche = ref({ details: [] });
const loading = ref(true);
const error = ref(null);

const loadingBC = ref(false);
const messageBC = ref('');

function formatDate(dateStr) {
  if (!dateStr) return '-';
  const d = new Date(dateStr);
  if (isNaN(d)) return dateStr;
  return d.toLocaleDateString();
}

async function fetchFiche() {
  loading.value = true;
  error.value = null;
  try {
    const id = route.params.id;
    fiche.value = await fetchProformaFiche(id);
  } catch (e) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
}

async function creerBC() {
  loadingBC.value = true;
  messageBC.value = '';
  try {
    const id = route.params.id;
    const userId = localStorage.getItem('userId') || 'admin';
    const data = await validerProforma(id, userId);
    if (data.success) {
      messageBC.value = 'Bon de commande créé avec succès !';
    } else {
      messageBC.value = data.error || 'Erreur lors de la création du BC';
    }
  } catch (e) {
    messageBC.value = e.message;
  } finally {
    loadingBC.value = false;
  }
}

onMounted(fetchFiche);
</script>

<style scoped>
.proforma-fiche-view {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}
.fiche-header {
  background: #fff;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 2px 8px #0001;
}
.fiche-info > div {
  margin-bottom: 0.5rem;
}
.fiche-details {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  box-shadow: 0 2px 8px #0001;
}
.fiche-details th, .fiche-details td {
  border: 1px solid #eee;
  padding: 0.5rem 0.75rem;
  text-align: left;
}
.fiche-details th {
  background: #f8f8f8;
}
.error {
  color: #c00;
  font-weight: bold;
}
</style>