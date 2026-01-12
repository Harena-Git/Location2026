<template>
  <div class="content-wrapper">
    <h1>
      <router-link to="/reservation/liste">
        <i class="fa fa-angle-left"></i>
      </router-link>
      Fiche de la réservation
    </h1>

    <div v-if="loading">Chargement...</div>
    <div v-else-if="error">{{ error }}</div>
    <div v-else>
      <div class="box-fiche">
        <div class="box">
          <div class="box-body">
            <div><strong>Id</strong> : {{ fiche.id }}</div>
            <div><strong>Client</strong> : {{ fiche.client }}</div>
            <div><strong>Date</strong> : {{ fiche.date }}</div>
            <div><strong>Remarque</strong> : {{ fiche.remarque }}</div>
            <div><strong>État</strong> : {{ fiche.etat }}</div>
            <div><strong>Montant Total</strong> : {{ fiche.montantTotal?.toLocaleString() }} Ar</div>
            <div><strong>Montant Payé</strong> : {{ fiche.paye?.toLocaleString() }} Ar</div>
            <div><strong>Reste à Payer</strong> : {{ fiche.resteAPayer?.toLocaleString() }} Ar</div>
            
            <!-- Lien vers la facture/vente -->
            <div v-if="fiche.idVente">
              <strong>Facture :</strong>
              <router-link :to="'/vente/fiche/' + fiche.idVente" class="btn btn-link">
                Voir la facture {{ fiche.idVente }}
              </router-link>
            </div>
          </div>
          <div class="box-footer">
            <button v-if="fiche.idVente" class="btn btn-primary" @click="allerFacture">
              Voir la facture
            </button>
            <button class="btn btn-warning" @click="imprimer">Imprimer</button>
          </div>
        </div>
      </div>

      <!-- Onglets -->
      <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
          <li :class="{ active: tab === 'details' }">
            <a @click="tab = 'details'">Détail(s)</a>
          </li>
          <li :class="{ active: tab === 'cautions' }">
            <a @click="tab = 'cautions'">Caution(s)</a>
          </li>
        </ul>
        <div class="tab-content">
          <div v-if="tab === 'details'">
            <table class="table table-bordered" v-if="fiche.details && fiche.details.length > 0">
              <thead>
                <tr>
                  <th>Produit</th>
                  <th>Désignation</th>
                  <th>Quantité (Article)</th>
                  <th>Quantité (En Jour)</th>
                  <th>Date De Début</th>
                  <th>Prix Unitaire</th>
                  <th>Montant De La Remise</th>
                  <th>Montant</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="detail in fiche.details" :key="detail.id">
                  <td>{{ detail.produit }}</td>
                  <td>{{ detail.designation }}</td>
                  <td>{{ detail.quantiteArticle }}</td>
                  <td>{{ detail.quantiteJour }}</td>
                  <td>{{ detail.dateDebut }}</td>
                  <td>{{ detail.prixUnitaire?.toLocaleString() }} Ar</td>
                  <td>{{ detail.montantRemise?.toLocaleString() }} Ar</td>
                  <td>{{ detail.montant?.toLocaleString() }} Ar</td>
                </tr>
              </tbody>
            </table>
            <p v-else>Aucun détail disponible</p>
          </div>
          <div v-if="tab === 'cautions'">
            <!-- Liste des cautions avec bouton Régler -->
            <table class="table table-bordered" v-if="fiche.cautions && fiche.cautions.length > 0">
              <thead>
                <tr>
                  <th>Id</th>
                  <th>Montant</th>
                  <th>État</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="caution in fiche.cautions" :key="caution.id">
                  <td>{{ caution.id }}</td>
                  <td>{{ caution.montant?.toLocaleString() }} Ar</td>
                  <td>{{ caution.etat }}</td>
                  <td>
                    <button class="btn btn-success btn-sm" @click="reglerCaution(caution.id)">
                      Régler caution
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
            <p v-else>Aucune caution disponible</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const fiche = ref({
  details: [],
  cautions: []
})
const loading = ref(true)
const error = ref(null)
const tab = ref('details')

async function loadFiche() {
  try {
    const resp = await fetch(`/asynclocation/api/reservation/fiche/${route.params.id}`)
    const data = await resp.json()
    if (data.success === false) {
      error.value = data.error
    } else {
      fiche.value = data
      // S'assurer que details et cautions sont des tableaux
      if (!fiche.value.details) fiche.value.details = []
      if (!fiche.value.cautions) fiche.value.cautions = []
    }
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

function allerFacture() {
  if (fiche.value.idVente) {
    router.push('/vente/fiche/' + fiche.value.idVente)
  }
}

function reglerCaution(idCaution) {
  router.push({
    path: '/caisse/mvt-caisse-saisie-caution',
    query: {
      idcaution: idCaution,
      idreservation: fiche.value.id,
      type: 'regler'
    }
  })
}

function imprimer() {
  window.open(`/asynclocation/ExportPDF?action=fiche_reservation&id=${fiche.value.id}`, '_blank')
}

onMounted(() => {
  loadFiche()
})
</script>

<style scoped>
.content-wrapper {
  padding: 2rem;
}
.box-fiche {
  margin-bottom: 2rem;
}
.box {
  background: #fff;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.box-body > div {
  margin-bottom: 0.5rem;
}
.box-footer {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #eee;
}
.nav-tabs-custom {
  margin-top: 2rem;
  background: #fff;
  border-radius: 8px;
  padding: 1rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.nav-tabs {
  list-style: none;
  padding: 0;
  margin: 0 0 1rem 0;
  display: flex;
  border-bottom: 2px solid #eee;
}
.nav-tabs li {
  margin-right: 1rem;
  padding: 0.5rem 1rem;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
}
.nav-tabs li.active {
  border-bottom-color: #007bff;
}
.nav-tabs li a {
  color: #333;
  text-decoration: none;
}
.nav-tabs li.active a {
  color: #007bff;
  font-weight: bold;
}
.tab-content {
  padding: 1rem 0;
}
.table {
  width: 100%;
  border-collapse: collapse;
}
.table-bordered {
  border: 1px solid #ddd;
}
.table-bordered th,
.table-bordered td {
  border: 1px solid #ddd;
  padding: 0.75rem;
  text-align: left;
}
.table thead {
  background-color: #f8f9fa;
}
.btn-link {
  color: #007bff;
  text-decoration: underline;
  padding: 0;
  margin-left: 10px;
  background: none;
  border: none;
  cursor: pointer;
}
.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 0.5rem;
}
.btn-primary {
  background-color: #007bff;
  color: white;
}
.btn-warning {
  background-color: #ffc107;
  color: #333;
}
.btn-success {
  background-color: #28a745;
  color: white;
}
.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}
</style>