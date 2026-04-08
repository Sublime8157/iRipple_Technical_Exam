<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">Dashboard</h1>

    <div v-if="loading" class="text-gray-500">Loading data...</div>

    <div v-else>
      <!-- Orders Section -->
      <div class="flex flex-col gap-4 mb-6">
        <h1 class="text-gray-300 text-xl">Total Orders</h1>
        <div class="flex flex-row gap-4">
          <div
            v-for="(card, index) in orderCards"
            :key="index"
            class="bg-white rounded-xl shadow p-6 flex flex-col items-start"
          >
            <p class="text-sm text-gray-500 w-72">{{ card.label }}</p>
            <p class="text-xl font-bold text-gray-800">{{ card.value }}</p>
          </div>
        </div>
      </div>

      <!-- Products Section -->
      <div class="flex flex-col gap-4">
        <h1 class="text-gray-300 text-xl">Total Products</h1>
        <div class="flex flex-row gap-4">
          <div
            v-for="(card, index) in productCards"
            :key="index"
            class="bg-white rounded-xl shadow p-6 flex flex-col items-start"
          >
            <p class="text-sm text-gray-500 mb-2 w-72">{{ card.label }}</p>
            <p class="text-xl font-bold text-gray-800">{{ card.value }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import api from "../api/axios";

const orders = ref([]);
const products = ref([]);
const totals = ref({ orders_total: 0, products_total: 0 });
const loading = ref(true);

onMounted(async () => {
  try {
    const response = await api.get("/dashboard");
    orders.value = response.data.orders;
    products.value = response.data.products;
    totals.value = response.data.totals;
  } catch (error) {
    console.error("Failed to fetch dashboard data:", error);
  } finally {
    loading.value = false;
  }
});

// Compute metrics dynamically
const orderCards = computed(() => [
  { label: "Amount", value: `₱${totals.value.orders_total}` },
  {
    label: "Created",
    value: orders.value.filter((o) => o.status === "C").length,
  },
  {
    label: "Pending",
    value: orders.value.filter((o) => o.status === "P").length,
  },
]);

const productCards = computed(() => [
  { label: "Amount", value: `₱${totals.value.products_total}` },
  {
    label: "Active",
    value: products.value.filter((p) => p.status === "A").length,
  },
  {
    label: "Inactive",
    value: products.value.filter((p) => p.status !== "A").length,
  },
]);
</script>
