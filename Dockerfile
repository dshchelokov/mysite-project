FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*

RUN pip install poetry==1.4.2

COPY pyproject.toml poetry.lock* ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

COPY . .

RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]