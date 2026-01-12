<template>
  <div class="content-wrapper">
    <h1>
      <router-link to="/vente/liste">
        <i class="fa fa-angle-left"></i>
      </router-link>
      Détails de la facture client
    </h1>

    <div v-if="loading">Chargement...</div>
    <div v-else-if="error">{{ error }}</div>
    <div v-else>
      <div class="box-fiche">
        <div class="box">
          <div class="box-body">
            <div><strong>Id</strong> : {{ fiche.id }}</div>
            <div><strong>Désignation</strong> : {{ fiche.designation }}</div>
            <div><strong>Remarque</strong> : {{ fiche.remarque || '-' }}</div>
            <div><strong>Magasin</strong> : {{ fiche.magasin }}</div>
            <div><strong>Date</strong> : {{ fiche.date }}</div>
            <div><strong>Client</strong> : {{ fiche.client }}</div>
            <div><strong>Téléphone</strong> : {{ fiche.telephone }}</div>
            <div><strong>État</strong> : {{ fiche.etat }}</div>
            <div><strong>Montant</strong> : {{ fiche.montant.toLocaleString() }} Ar</div>
            <div><strong>Montant Payé</strong> : {{ fiche.montantPaye.toLocaleString() }} Ar</div>
            <div><strong>Montant Remise</strong> : {{ fiche.montantRemise.toLocaleString() }} Ar</div>
            <div><strong>Reste à payer</strong> : {{ fiche.montantReste.toLocaleString() }} Ar</div>
            <div><strong>Date prévue</strong> : {{ fiche.datePrevue }}</div>
            <div><strong>Période</strong> : {{ fiche.periode }}</div>
            <div><strong>ID Réservation</strong> : 
              <router-link :to="'/reservation/fiche/' + fiche.idReservation">
                {{ fiche.idReservation }}
              </router-link>
            </div>
            <div><strong>État Logistique</strong> : {{ fiche.etatLogistique }}</div>
          </div>
          <div class="box-footer">
            <button v-if="fiche.montantReste > 0" class="btn btn-primary" @click="payerLocation">
              Payer
            </button>
            <button class="btn btn-warning" @click="imprimer">Imprimer</button>
          </div>
        </div>
      </div>

      <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
          <li :class="{ active: tab === 'details' }">
            <a @click="tab = 'details'">Détail(s)</a>
          </li>
          <li :class="{ active: tab === 'paiements' }">
            <a @click="tab = 'paiements'">Paiement(s)</a>
          </li>
          <li :class="{ active: tab === 'cautions' }">
            <a @click="tab = 'cautions'">Caution(s)</a>
          </li>
        </ul>
        <div class="tab-content">
          <div v-if="tab === 'details'">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>Id</th>
                  <th>Désignation</th>
                  <th>Image</th>
                  <th>Quantité</th>
                  <th>Prix Unitaire</th>
                  <th>Montant Avant Remise</th>
                  <th>Montant Remise</th>
                  <th>Montant</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="detail in fiche.details" :key="detail.id">
                  <td>{{ detail.id }}</td>
                  <td>{{ detail.designation }}</td>
                  <td><img v-if="detail.image" :src="detail.image" width="50" /></td>
                  <td>{{ detail.quantite }}</td>
                  <td>{{ detail.prixUnitaire.toLocaleString() }} Ar</td>
                  <td>{{ detail.montantAvantRemise.toLocaleString() }} Ar</td>
                  <td>{{ detail.montantRemise.toLocaleString() }} Ar</td>
                  <td>{{ detail.montant.toLocaleString() }} Ar</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <td colspan="5" class="text-right"><strong>Montant Total :</strong></td>
                  <td><strong>{{ fiche.montantTotalDetails.toLocaleString() }} AR</strong></td>
                </tr>
                <tr>
                  <td colspan="5" class="text-right"><strong>Montant Remise :</strong></td>
                  <td><strong>{{ fiche.montantRemiseDetails.toLocaleString() }} AR</strong></td>
                </tr>
                <tr>
                  <td colspan="5" class="text-right"><strong>Montant Final :</strong></td>
                  <td><strong>{{ fiche.montantFinalDetails.toLocaleString() }} AR</strong></td>
                </tr>
              </tfoot>
            </table>
          </div>
          <div v-if="tab === 'paiements'">
            <!-- Liste des paiements -->
            <p>Liste des paiements à implémenter</p>
          </div>
          <div v-if="tab === 'cautions'">
            <!-- Liste des cautions -->
            <p>Liste des cautions à implémenter</p>
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

const fiche = ref({})
const loading = ref(true)
const error = ref(null)
const tab = ref('details')

async function loadFiche() {
  try {
    const resp = await fetch(`/asynclocation/api/vente/fiche/${route.params.id}`)
    const data = await resp.json()
    if (data.success === false) {
      error.value = data.error
    } else {
      fiche.value = data
    }
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

function payerLocation() {
  router.push({
    path: '/caisse/mvt-caisse-saisie-location',
    query: {
      idOrigine: fiche.value.id,
      montant: fiche.value.montantReste,
      tiers: fiche.value.client
    }
  })
}

function imprimer() {
  window.open(`/asynclocation/ExportPDF?action=fiche_vente&id=${fiche.value.id}`, '_blank')
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
.nav-tabs-custom {
  margin-top: 2rem;
}
</style>