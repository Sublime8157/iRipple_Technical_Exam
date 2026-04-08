<template>
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
  >
    <div class="bg-white rounded-xl shadow-xl w-full max-w-md p-6 relative">
      <!-- Header -->
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-lg font-bold text-gray-800">{{ title }}</h2>
        <button
          @click="$emit('close')"
          class="text-gray-400 hover:text-gray-600 text-xl font-bold"
        >
          ✕
        </button>
      </div>

      <!-- Slot for form content -->
      <slot />

      <!-- Actions -->
      <div class="flex justify-between mt-6">
        <button
          @click="$emit('delete')"
          class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
        >
          🗑 Delete
        </button>
        <button
          @click="$emit('update')"
          class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
        >
          ✏️ Update
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({ title: String });
defineEmits(["close", "update", "delete"]);
</script>
