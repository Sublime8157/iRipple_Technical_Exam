import { createRouter, createWebHistory } from "vue-router";
import OrdersView from "../views/OrdersView.vue";
import ProductsView from "../views/ProductsView.vue";
import DashboardView from "@/views/DashboardView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: "/", component: OrdersView },
    { path: "/products", component: ProductsView },
    { path: "/dashboard", component: DashboardView },
  ],
});

export default router;
