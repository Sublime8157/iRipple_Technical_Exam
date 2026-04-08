<template>
  <div class="flex items-center justify-between p-4">
    <!-- Info -->
    <p class="text-sm text-gray-500">
      Page {{ currentPage }} of {{ totalPages }} ({{ totalCount }} total)
      <span v-if="totalAmount !== undefined && totalAmount !== null">
        — Total amount: ₱{{ totalAmount.toFixed(2) }}
      </span>
    </p>

    <!-- Buttons -->
    <div class="flex gap-2">
      <button
        @click="$emit('change', currentPage - 1)"
        :disabled="currentPage === 1"
        class="px-3 py-1 text-sm rounded-lg border border-gray-300 hover:bg-gray-100 disabled:opacity-40 disabled:cursor-not-allowed transition"
      >
        ← Prev
      </button>
      <button
        v-for="page in pagesToShow"
        :key="page"
        @click="$emit('change', page)"
        :class="
          page === currentPage
            ? 'bg-gray-800 text-white'
            : 'bg-white text-gray-700 hover:bg-gray-100'
        "
        class="px-3 py-1 text-sm rounded-lg border border-gray-300 transition"
      >
        {{ page }}
      </button>

      <button
        @click="$emit('change', currentPage + 1)"
        :disabled="currentPage === totalPages"
        class="px-3 py-1 text-sm rounded-lg border border-gray-300 hover:bg-gray-100 disabled:opacity-40 disabled:cursor-not-allowed transition"
      >
        Next →
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
  currentPage: Number,
  totalPages: Number,
  totalCount: Number,
  totalAmount: Number,
});

defineEmits(["change"]);

const pagesToShow = computed(() => {
  const pages = [];
  const start = Math.max(1, props.currentPage - 2);
  const end = Math.min(props.totalPages, props.currentPage + 2);
  for (let i = start; i <= end; i++) pages.push(i);
  return pages;
});
</script>
