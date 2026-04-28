FROM python:3.12-slim

WORKDIR /app

# Solo copiamos el requirements para instalar dependencias en una capa limpia
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos solo el código fuente (el .dockerignore evitará que entre basura)
COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]