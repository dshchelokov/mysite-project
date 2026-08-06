FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY vendor /vendor

RUN pip install --no-index --find-links /vendor asgiref sqlparse django==4.0.6 django-debug-toolbar==4.3.0 djangorestframework==3.14.0 django-filter==23.5 pillow==12.3.0 gunicorn==26.0.0

COPY . .

CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]