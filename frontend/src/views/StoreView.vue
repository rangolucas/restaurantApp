<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router';

const route = useRoute();
const storeId = ref(route.params.id);

onMounted(() => {
  console.log(`Store ID: ${storeId.value}`);
});
</script>

<template>
  <div>
    <ul class="nav nav-tabs">
      <li class="nav-item">
        <a class="nav-link active" aria-current="page" href="#">Pedidos</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Menu</a>
      </li>
    </ul>
  </div>
</template>

<style scoped></style>
