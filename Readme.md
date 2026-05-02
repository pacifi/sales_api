# Django Sales API

REST API construida con Django + Django REST Framework. Gestiona **Categorías** y **Productos**.

---

## Requisitos

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

> ⚠️ **Base de datos:** El proyecto usa **SQLite** por defecto (no hay servicio de Postgres en el `docker-compose.yml`). El archivo `db.sqlite3` vivirá dentro del contenedor. Si quieres persistencia entre reinicios, agrega un volumen al servicio `web` en `docker-compose.yml`.

---

## Iniciar el proyecto

### 1. Construir y levantar el contenedor

```bash
docker-compose up --build
```

Para correrlo en segundo plano:

```bash
docker-compose up --build -d
```

La API quedará disponible en: `http://localhost:8000`

---

### 2. Aplicar migraciones

Con el contenedor corriendo, ejecuta en otra terminal:

```bash
docker exec -it django_sales_app python manage.py makemigrations
docker exec -it django_sales_app python manage.py migrate
```

---

### 3. Crear superusuario (acceso al admin)

```bash
docker exec -it django_sales_app python manage.py createsuperuser
```

Sigue las instrucciones en consola (username, email, password).

Panel de administración disponible en: `http://localhost:8000/admin/`

---

### 4. Detener el proyecto

```bash
docker-compose down
```

---

## Endpoints disponibles

Base URL: `http://localhost:8000`

### Categorías — `/product/categories/`

| Método   | URL                          | Acción                        |
|----------|------------------------------|-------------------------------|
| `GET`    | `/product/categories/`       | Listar todas las categorías   |
| `POST`   | `/product/categories/`       | Crear una categoría           |
| `GET`    | `/product/categories/{id}/`  | Obtener una categoría         |
| `PUT`    | `/product/categories/{id}/`  | Reemplazar una categoría      |
| `PATCH`  | `/product/categories/{id}/`  | Actualizar campos parciales   |
| `DELETE` | `/product/categories/{id}/`  | Eliminar una categoría        |

---

### Productos — `/product/products/`

| Método   | URL                         | Acción                      |
|----------|-----------------------------|-----------------------------|
| `GET`    | `/product/products/`        | Listar todos los productos  |
| `POST`   | `/product/products/`        | Crear un producto           |
| `GET`    | `/product/products/{id}/`   | Obtener un producto         |
| `PUT`    | `/product/products/{id}/`   | Reemplazar un producto      |
| `PATCH`  | `/product/products/{id}/`   | Actualizar campos parciales |
| `DELETE` | `/product/products/{id}/`   | Eliminar un producto        |

---

### Explorador de la API (DRF Browsable API)

| URL                              | Descripción                    |
|----------------------------------|--------------------------------|
| `http://localhost:8000/product/` | Raíz del router (DRF UI)       |

---

## Documentación de la API

### Modelo: Category

| Campo         | Tipo     | Requerido | Descripción                  |
|---------------|----------|-----------|------------------------------|
| `id`          | integer  | auto      | Clave primaria (autogenerada)|
| `name`        | string   | ✅ sí     | Nombre único (max 50 chars)  |
| `description` | string   | ✅ sí     | Descripción de la categoría  |

---

### Modelo: Product

| Campo         | Tipo     | Requerido | Descripción                          |
|---------------|----------|-----------|--------------------------------------|
| `id`          | integer  | auto      | Clave primaria (autogenerada)        |
| `category`    | integer  | ✅ sí     | ID de la categoría (FK)              |
| `name`        | string   | ✅ sí     | Nombre único (max 50 chars)          |
| `price`       | decimal  | ✅ sí     | Precio (máx 10 dígitos, 2 decimales) |
| `description` | string   | ✅ sí     | Descripción del producto             |

---

### Ejemplos de JSON

#### `GET /product/categories/` — Listar categorías

```json
[
  {
    "id": 1,
    "name": "Electrónica",
    "description": "Dispositivos y accesorios electrónicos"
  },
  {
    "id": 2,
    "name": "Ropa",
    "description": "Prendas de vestir para todo clima"
  }
]
```

---

#### `POST /product/categories/` — Crear categoría

**Request body:**
```json
{
  "name": "Electrónica",
  "description": "Dispositivos y accesorios electrónicos"
}
```

**Response `201 Created`:**
```json
{
  "id": 1,
  "name": "Electrónica",
  "description": "Dispositivos y accesorios electrónicos"
}
```

---

#### `GET /product/products/` — Listar productos (serializer de lectura: category anidada)

```json
[
  {
    "id": 1,
    "category": {
      "id": 1,
      "name": "Electrónica",
      "description": "Dispositivos y accesorios electrónicos"
    },
    "name": "Auriculares Bluetooth",
    "price": "49.99",
    "description": "Auriculares inalámbricos con cancelación de ruido"
  }
]
```

---

#### `POST /product/products/` — Crear producto (serializer de escritura: category como ID)

**Request body:**
```json
{
  "category": 1,
  "name": "Auriculares Bluetooth",
  "price": "49.99",
  "description": "Auriculares inalámbricos con cancelación de ruido"
}
```

**Response `201 Created`:**
```json
{
  "id": 1,
  "category": 1,
  "name": "Auriculares Bluetooth",
  "price": "49.99",
  "description": "Auriculares inalámbricos con cancelación de ruido"
}
```

> 📌 **Nota importante:** Al **leer** (`GET`), el campo `category` devuelve el objeto completo anidado. Al **escribir** (`POST`, `PUT`, `PATCH`), se envía solo el `id` de la categoría.

---

#### `PATCH /product/products/{id}/` — Actualización parcial

Solo envías los campos que quieres modificar:

```json
{
  "price": "39.99"
}
```

---

#### Respuesta de error — Category no existe al crear producto

```json
{
  "category": [
    "Invalid pk \"99\" - object does not exist."
  ]
}
```

#### Respuesta de error — Campo requerido faltante

```json
{
  "name": [
    "This field is required."
  ]
}
```

#### Respuesta de error — Nombre duplicado (`unique=True`)

```json
{
  "name": [
    "product with this name already exists."
  ]
}
```