<template>
  <aside class="sidebar">
    <h2 class="sidebar-title">Menu</h2>
    <nav>
      <ul>
        <li>
          <router-link to="/proforma/liste" class="sidebar-link" exact>Liste Proformas</router-link>
        </li>
        <li>
          <router-link to="/proforma/saisie" class="sidebar-link" exact>Saisie Proforma</router-link>
        </li>
          <li>
          <router-link to="/reservation/liste" class="sidebar-link" exact>Liste Réservations</router-link>
        </li>
      </ul>
    </nav>
  </aside>
</template>

<script setup>
</script>

<style scoped>
.sidebar {
  width: 220px;
  background: #fff;
  border-right: 1px solid #ddd;
  min-height: 100vh;
  padding: 24px 0 0 0;
  position: sticky;
  top: 0;
}
.sidebar-title {
  font-size: 1.2em;
  font-weight: bold;
  margin: 0 0 24px 24px;
  color: #337ab7;
}
.sidebar ul {
  list-style: none;
  padding: 0 0 0 24px;
  margin: 0;
}
.sidebar li {
  margin-bottom: 16px;
}
.sidebar-link {
  color: #222;
  text-decoration: none;
  font-size: 1em;
  padding: 6px 12px;
  border-radius: 2px;
  display: block;
  transition: background 0.2s;
}
.sidebar-link.router-link-exact-active {
  background: #337ab7;
  color: #fff;
}
.sidebar-link:hover {
  background: #eafbe7;
}
</style>