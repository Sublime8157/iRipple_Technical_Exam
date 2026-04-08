<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">Orders</h1>

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

    <!-- Create Order Form -->
    <div class="bg-white rounded-xl shadow p-6 mb-8">
      <h2 class="text-lg font-semibold text-gray-700 mb-4">Create Order</h2>
      <div
        v-for="(item, index) in orderItems"
        :key="index"
        class="flex gap-3 mb-3 items-center"
      >
        <select
          v-model="item.product_id"
          class="flex-1 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
        >
          <option disabled value="">Select Product</option>
          <option v-for="p in products" :key="p.id" :value="p.id">
            {{ p.name }} — ₱{{ p.price }}
          </option>
        </select>
        <input
          v-model="item.quantity"
          type="number"
          min="1"
          placeholder="Qty"
          @blur="item.quantity = item.quantity < 1 ? 1 : item.quantity"
          class="w-24 border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
        />
        <span class="w-28 text-sm font-semibold text-gray-700"
          >₱{{ getSubtotal(item) }}</span
        >
        <button
          @click="removeOrderItem(index)"
          class="bg-red-500 hover:bg-red-600 text-white px-3 py-2 rounded-lg text-sm transition"
        >
          Remove
        </button>
      </div>

      <div class="flex justify-between items-center mt-4">
        <div class="flex flex-row gap-2">
          <button
            @click="addOrderItem"
            class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg text-sm transition"
          >
            + Add Item
          </button>
          <button
            @click="createOrder"
            class="bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-lg text-sm font-semibold transition"
          >
            Place Order
          </button>
        </div>
        <div class="text-lg font-bold text-gray-800">
          Total: ₱{{ computedTotal }}
        </div>
      </div>
    </div>

    <!-- Orders Table -->
    <div class="bg-white rounded-xl shadow overflow-hidden">
      <table class="w-full text-sm">
        <thead class="bg-gray-800 text-white">
          <tr>
            <th class="px-4 py-3 text-left">ID</th>
            <th class="px-4 py-3 text-left">Status</th>
            <th class="px-4 py-3 text-left">Total</th>
            <th class="px-4 py-3 text-left">Items</th>
            <th class="px-4 py-3 text-left">Created At</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="order in orders"
            :key="order.id"
            class="border-b border-gray-100 hover:bg-blue-50 transition cursor-pointer"
            @dblclick="openModal(order)"
          >
            <td class="px-4 py-3 font-medium">#{{ order.id }}</td>
            <td class="px-4 py-3">
              <span
                :class="
                  order.status === 'C'
                    ? 'bg-green-100 text-green-700'
                    : 'bg-yellow-100 text-yellow-700'
                "
                class="px-2 py-1 rounded-full text-xs font-semibold"
              >
                {{ order.status === "C" ? "Completed" : "Pending" }}
              </span>
            </td>
            <td class="px-4 py-3 font-semibold">₱{{ order.total_amount }}</td>
            <td class="px-4 py-3">
              <ul class="space-y-1">
                <li
                  v-for="item in order.items"
                  :key="item.product_id"
                  class="text-gray-600"
                >
                  {{ item.product_name }}
                  <span class="text-gray-400">x{{ item.quantity }}</span>
                  — ₱{{ item.subtotal }}
                </li>
              </ul>
            </td>
            <td class="px-4 py-3 text-gray-500">
              {{ new Date(order.created_at).toLocaleString() }}
            </td>
          </tr>
          <tr v-if="orders.length === 0">
            <td colspan="5" class="text-center py-8 text-gray-400">
              No orders yet
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
      title="Edit Order"
      @close="closeModal"
      @update="updateOrder"
      @delete="deleteOrder"
    >
      <div class="space-y-3">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Order ID</label
          >
          <input
            :value="'#' + selected.id"
            disabled
            class="w-full border border-gray-200 bg-gray-50 rounded-lg px-3 py-2 text-sm text-gray-400"
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
            <option value="P">Pending</option>
            <option value="C">Completed</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Items</label
          >
          <ul
            class="bg-gray-50 rounded-lg p-3 space-y-1 text-sm text-gray-600 border border-gray-200"
          >
            <li v-for="item in selected.items" :key="item.product_id">
              {{ item.product_name }}
              <span class="text-gray-400">x{{ item.quantity }}</span>
              — ₱{{ item.subtotal }}
            </li>
          </ul>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >Total Amount</label
          >
          <input
            :value="'₱' + selected.total_amount"
            disabled
            class="w-full border border-gray-200 bg-gray-50 rounded-lg px-3 py-2 text-sm text-gray-400"
          />
        </div>
      </div>
    </ModalForm>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import api from "../api/axios";
import PaginationBar from "../components/PaginationBar.vue";
import ModalForm from "../components/ModalForm.vue";

const orders = ref([]);
const products = ref([]);
const orderItems = ref([{ product_id: "", quantity: 1 }]);
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

async function fetchOrders(page = 1) {
  const res = await api.get("/orders", { params: { page, per_page: 5 } });
  orders.value = res.data.data;
  currentPage.value = res.data.meta.current_page;
  totalPages.value = res.data.meta.total_pages;
  totalCount.value = res.data.meta.total_count;
}

async function fetchProducts() {
  const res = await api.get("/products", { params: { status: "active" } });
  products.value = res.data.data;
}

function onPageChange(page) {
  fetchOrders(page);
}
function addOrderItem() {
  orderItems.value.push({ product_id: "", quantity: 1 });
}
function removeOrderItem(i) {
  if (orderItems.value.length <= 1) return;
  orderItems.value.splice(i, 1);
}

function openModal(order) {
  selected.value = { ...order };
  showModal.value = true;
}

function closeModal() {
  showModal.value = false;
  selected.value = {};
}

function getSubtotal(item) {
  const product = products.value.find((p) => p.id === item.product_id);
  if (!product || !item.quantity) return 0;
  return parseFloat(product.price) * parseInt(item.quantity);
}

const computedTotal = computed(() => {
  return orderItems.value.reduce((sum, item) => sum + getSubtotal(item), 0);
});

async function createOrder() {
  try {
    await api.post("/orders", {
      items: orderItems.value.map((i) => ({
        product_id: i.product_id,
        quantity: parseInt(i.quantity),
      })),
    });
    showAlert("Order placed successfully!");
    orderItems.value = [{ product_id: "", quantity: 1 }];
    fetchOrders(currentPage.value);
  } catch (e) {
    const message =
      e.response?.data?.error ||
      e.response?.data?.errors?.join(", ") ||
      "Failed to create order";
    showAlert(message, "error");
    closeModal();
  }
}

async function updateOrder() {
  try {
    await api.put(`/orders/${selected.value.id}`, {
      status: selected.value.status,
    });
    showAlert("Order updated successfully!");
    closeModal();
    fetchOrders(currentPage.value);
  } catch (e) {
    const message =
      e.response?.data?.error ||
      e.response?.data?.errors?.join(", ") ||
      "Failed to update order";
    showAlert(message, "error");
    closeModal();
  }
}

async function deleteOrder() {
  if (!confirm(`Delete Order #${selected.value.id}? This cannot be undone.`))
    return;
  try {
    await api.delete(`/orders/${selected.value.id}`);
    showAlert("Order deleted!");
    closeModal();
    fetchOrders(currentPage.value);
  } catch (e) {
    const message =
      e.response?.data?.error ||
      e.response?.data?.errors?.join(", ") ||
      "Failed to delete order";
    showAlert(message, "error");
    closeModal();
  }
}

onMounted(() => {
  fetchOrders(1);
  fetchProducts();
});
</script>
