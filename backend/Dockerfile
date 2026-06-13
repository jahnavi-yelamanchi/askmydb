FROM python:3.12-slim
WORKDIR /app
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ .
COPY demo_db/seed.sql ./seed.sql
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
