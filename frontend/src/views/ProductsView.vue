<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">Products</h1>

    <!-- Alert -->
    <div
      v-if="alert.message"
      :class="
        alert.type === 'success'
          ? 'bg-green-100 text-green-800 border border-green-300'
          : 'bg-red-100 text-red-800 border border-red-300'
      "
      class="px-4 py-3 rounded-lg mb-4 text-sm font-medium"
    >
      {{ alert.message }}
    </div>

    <!-- Create Product Form -->
    <div class="bg-white rounded-xl shadow p-6 mb-8">
      <h2 class="text-lg font-semibold text-gray-700 mb-4">Create Products</h2>
      <div
        v-for="(item, index) in newItems"
        :key="index"
        class="flex gap-3 mb-3 items-center"
      >
        <input
          v-model="item.name"
          placeholder="Name"
          class="flex-1 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
        />
        <input
          v-model="item.code"
          placeholder="Code"
          class="flex-1 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
        />
        <input
          v-model="item.price"
          placeholder="Price"
          type="number"
          class="flex-1 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
        />
        <button
          @click="removeItem(index)"
          class="bg-red-500 hover:bg-red-600 text-white px-3 py-2 rounded-lg text-sm transition"
        >
          Remove
        </button>
      </div>
      <div class="flex gap-3 mt-4">
        <button
          @click="addItem"
          class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg text-sm transition"
        >
          + Add Row
        </button>
        <button
          @click="createProducts"
          class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg text-sm transition"
        >
          Create Products
        </button>
      </div>
    </div>

    <!-- Products Table -->
    <div class="bg-white rounded-xl shadow overflow-hidden">
      <table class="w-full text-sm">
        <thead class="bg-gray-800 text-white">
          <tr>
            <th class="px-4 py-3 text-left">ID</th>
            <th class="px-4 py-3 text-left">Name</th>
            <th class="px-4 py-3 text-left">Code</th>
            <th class="px-4 py-3 text-left">Price</th>
            <th class="px-4 py-3 text-left">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="product in products"
            :key="product.id"
            class="border-b border-gray-100 hover:bg-blue-50 transition cursor-pointer"
            @dblclick="openModal(product)"
          >
            <td class="px-4 py-3">{{ product.id }}</td>
            <td class="px-4 py-3 font-medium">{{ product.name }}</td>
            <td class="px-4 py-3 text-gray-500">{{ product.code }}</td>
            <td class="px-4 py-3">₱{{ product.price }}</td>
            <td class="px-4 py-3">
              <span
                :class="
                  product.status === 'A'
                    ? 'bg-green-100 text-green-700'
                    : 'bg-blue-100 text-blue-700'
                "
                class="px-2 py-1 rounded-full text-xs font-semibold"
              >
                {{ product.status === "A" ? "Active" : "Created" }}
              </span>
            </td>
          </tr>
          <tr v-if="products.length === 0">
            <td colspan="5" class="text-center py-8 text-gray-400">
              No products yet
            </td>
          </tr>
        </tbody>
      </table>

      <div class="px-4 py-3">
        <PaginationBar
          :current-page="currentPage"
          :total-pages="totalPages"
          :total-count="totalCount"
          @change="onPageChange"
        />
      </div>
    </div>

    <!-- Hint -->
    <p class="text-xs text-gray-400 mt-2 text-center">
      Double-click a row to edit or delete
    </p>

    <!-- Edit Modal -->
    <ModalForm
      v-if="showModal"
      title="Edit Product"
      @close="closeModal"
      @update="updateProduct"
      @delete="deleteProduct"
    >
      <div class="space-y-3">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Name</label
          >
          <input
            v-model="selected.name"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Code</label
          >
          <input
            v-model="selected.code"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Price</label
          >
          <input
            v-model="selected.price"
            type="number"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Status</label
          >
          <select
            v-model="selected.status"
            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
          >
            <option value="C">Created</option>
            <option value="A">Active</option>
          </select>
        </div>
      </div>
    </ModalForm>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "../api/axios";
import PaginationBar from "../components/PaginationBar.vue";
import ModalForm from "../components/ModalForm.vue";

const products = ref([]);
const newItems = ref([{ name: "", code: "", price: "" }]);
const alert = ref({ message: "", type: "" });
const showModal = ref(false);
const selected = ref({});
const currentPage = ref(1);
const totalPages = ref(1);
const totalCount = ref(0);

function showAlert(message, type = "success") {
  alert.value = { message, type };
  setTimeout(() => (alert.value = { message: "", type: "" }), 3000);
}

async function fetchProducts(page = 1) {
  const res = await api.get("/products", { params: { page, per_page: 5 } });
  products.value = res.data.data;
  currentPage.value = res.data.meta.current_page;
  totalPages.value = res.data.meta.total_pages;
  totalCount.value = res.data.meta.total_count;
}

function onPageChange(page) {
  fetchProducts(page);
}

function addItem() {
  newItems.value.push({ name: "", code: "", price: "" });
}
function removeItem(index) {
  if (newItems.value.length <= 1) return;
  newItems.value.splice(index, 1);
}

function openModal(product) {
  selected.value = { ...product }; // spread to avoid mutating original
  showModal.value = true;
}

function closeModal() {
  showModal.value = false;
  selected.value = {};
}

async function createProducts() {
  try {
    await api.post("/products", {
      status: "C",
      data: newItems.value.map((i) => ({
        name: i.name,
        code: i.code,
        price: parseFloat(i.price),
      })),
    });
    showAlert("Products created successfully!");
    newItems.value = [{ name: "", code: "", price: "" }];
    fetchProducts(currentPage.value);
  } catch (e) {
    const message =
      e.response?.data?.error ||
      e.response?.data?.errors[0]?.errors[0] ||
      "Failed to create product";
    showAlert(message, "error");
    closeModal();
  }
}

async function updateProduct() {
  try {
    await api.put(`/products/${selected.value.id}`, {
      name: selected.value.name,
      code: selected.value.code,
      price: selected.value.price,
      status: selected.value.status,
    });
    showAlert("Product updated successfully!");
    closeModal();
    fetchProducts(currentPage.value);
  } catch (e) {
    const message =
      e.response?.data?.error ||
      e.response?.data?.errors?.join(", ") ||
      "Failed to update product";
    showAlert(message, "error");
    closeModal();
  }
}

async function deleteProduct() {
  if (!confirm(`Delete "${selected.value.name}"? This cannot be undone.`))
    return;
  try {
    await api.delete(`/products/${selected.value.id}`);
    showAlert("Product deleted!");
    closeModal();
    fetchProducts(currentPage.value);
  } catch (e) {
    const message =
      e.response?.data?.error ||
      e.response?.data?.errors?.join(", ") ||
      "Failed to delete product";
    showAlert(message, "error");
    closeModal();
  }
}

onMounted(() => fetchProducts(1));
</script>
