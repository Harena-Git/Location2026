// Liste des réservations
export async function fetchReservations(params = {}) {
	const queryParams = new URLSearchParams(params).toString()
	const url = '/asynclocation/pages/reservation/api-liste.jsp' + (queryParams ? '?' + queryParams : '')
	const res = await fetch(url)
	if (!res.ok) throw new Error('Erreur API: ' + res.status)
	return await res.json()
}

// Fiche réservation
export async function fetchReservationFiche(id) {
  const res = await fetch(`/asynclocation/pages/reservation/api-fiche.jsp?id=${id}`)
  if (!res.ok) throw new Error('Erreur API: ' + res.status)
  return await res.json()
}

// Liste des proformas
export async function fetchProformas() {
	const res = await fetch('/asynclocation/pages/vente/proforma/api-liste.jsp')
	if (!res.ok) throw new Error('Erreur API: ' + res.status)
	return await res.json()
}

// Fiche proforma
export async function fetchProformaFiche(id) {
	const res = await fetch(`/asynclocation/pages/vente/proforma/api-fiche3.jsp?id=${id}`)
	if (!res.ok) throw new Error('Erreur API: ' + res.status)
	return await res.json()
}

// Valider proforma (créer BC)
export async function validerProforma(id, userId = 'admin') {
	const res = await fetch(`/asynclocation/api/proforma/valider/${id}`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
			'user': userId
		}
	})
	return await res.json()
}

// Liste des clients pour proforma
export async function fetchProformaClients() {
	const res = await fetch('/asynclocation/pages/vente/proforma/api-clients3.jsp')
	if (!res.ok) throw new Error('Erreur API: ' + res.status)
	return await res.json()
}

// Liste des produits pour proforma
export async function fetchProformaProduits() {
	const res = await fetch('/asynclocation/pages/vente/proforma/api-produits2.jsp')
	if (!res.ok) throw new Error('Erreur API: ' + res.status)
	return await res.json()
}

// Créer une proforma
export async function creerProforma(data) {
	const res = await fetch('/asynclocation/pages/vente/proforma/api-creer3.jsp', {
		method: 'POST',
		headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
		credentials: 'include',
		body: JSON.stringify(data)
	})

	// Si le serveur renvoie un code d'erreur HTTP, on lève une erreur explicite
	if (!res.ok) {
		throw new Error('Erreur API: ' + res.status)
	}

	// Évite l'erreur "Unexpected end of JSON input" si la réponse est vide ou non JSON
	const text = await res.text()
	if (!text) {
		return { success: false, error: 'Réponse vide du serveur' }
	}
	try {
		return JSON.parse(text)
	} catch (e) {
		return { success: false, error: 'Réponse non JSON du serveur' }
	}
}
