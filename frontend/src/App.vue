<template>
  <div class="min-h-screen bg-gray-100">
    <!-- Navbar -->
    <nav class="bg-gray-900 shadow-lg">
      <div
        class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center"
      >
        <span class="text-white text-xl font-bold tracking-wide"
          >🛒 Order Management</span
        >
        <div class="flex gap-6">
          <RouterLink
            to="/dashboard"
            class="text-gray-300 hover:text-white transition font-medium"
            active-class="text-white border-b-2 border-blue-400"
          >
            Dashboard
          </RouterLink>
          <RouterLink
            to="/"
            class="text-gray-300 hover:text-white transition font-medium"
            active-class="text-white border-b-2 border-blue-400"
          >
            Orders
          </RouterLink>
          <RouterLink
            to="/products"
            class="text-gray-300 hover:text-white transition font-medium"
            active-class="text-white border-b-2 border-blue-400"
          >
            Products
          </RouterLink>
        </div>
      </div>
    </nav>

    <!-- Page Content -->
    <main class="max-w-6xl mx-auto px-6 py-8">
      <RouterView />
    </main>
  </div>
</template>
