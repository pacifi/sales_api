FROM python:3.12-slim

# Instalamos uv desde la imagen oficial para asegurar la versión más rápida
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Evita que Python genere archivos .pyc y permite logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Sincronizamos las dependencias usando uv
# Si tienes pyproject.toml y uv.lock, uv es absurdamente rápido
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-cache

# Copiamos el resto del código
COPY . .

# Exponemos el puerto de Django
EXPOSE 8000

# Usamos 'uv run' para ejecutar Django dentro del entorno virtual creado por uv
CMD ["uv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]