Make sure you have the following installed:
- Ruby 3.3.7
- Rails 7.2.3
- MySQL 8.0
- Node.js v20
- npm

## Backend Setup (Rails API)

### 1. Clone the repository
```bash
git clone <your-repo-url>
```

### 2. Go to backend folder
```bash
cd backend
```

### 3. Install dependencies
```bash
bundle install
```

### 4. Configure database
Edit `config/database.yml` and update with your MySQL credentials:
```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: 5
  username: rails_user
  password: password123
  host: 127.0.0.1
```

### 5. Create and migrate the database
```bash
rails db:create
rails db:migrate
```

### 6. Start the Rails server
```bash
rails server
```

API will be running at: `http://localhost:3000`

---

## Frontend Setup (Vue.js)

### 1. Go to frontend folder
```bash
cd frontend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Start the dev server
```bash
npm run dev
```

Frontend will be running at: `http://localhost:5173`

---

## API Endpoints

### Products

| Method | Endpoint               | Description              |
|--------|------------------------|--------------------------|
| GET    | /api/v1/products       | List all products        |
| POST   | /api/v1/products       | Create products          |
| PUT    | /api/v1/products/:id   | Update any fields        |
| DELETE | /api/v1/products/:id   | Delete product           |

### Orders

| Method | Endpoint             | Description           |
|--------|----------------------|-----------------------|
| GET    | /api/v1/orders       | List all orders       |
| POST   | /api/v1/orders       | Create a new order    |
| PUT    | /api/v1/orders/:id   | Update order status   |
| DELETE | /api/v1/orders/:id   | Delete product        |


## Features

- Dashboard with Totals for Products (Active, Inactive) and Orders (Created, Pending)
- Validation when deleting products with orders referencing
- Create and manage products (Update Fields, Delete Products)
- Create orders and Manage orders (Pending -> Created, Delete) with multiple items
- Auto-computed order total
- JOIN queries using ActiveRecord includes
- Database transactions for order creation
- Input validations
- API versioning (/api/v1/)
- Clean responsive UI with Tailwind CSS
- Rspec For Unit Test
- CORS to authorize frontend server
- Paginate pages using kaminari
