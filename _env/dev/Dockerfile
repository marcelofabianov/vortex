FROM php:8.4-fpm-alpine AS base

ARG HOST_UID=1000
ARG HOST_GID=1000

ENV TZ=America/Sao_Paulo

RUN addgroup -g ${HOST_GID} -S appgroup && \
    adduser -u ${HOST_UID} -G appgroup -S -D -h /home/appuser appuser

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    linux-headers \
    brotli-dev \
    icu-dev \
    libzip-dev \
    libxml2-dev \
    postgresql-dev \
    oniguruma-dev && \
    apk add --no-cache \
    git \
    curl \
    unzip \
    libpq \
    libzip \
    icu-libs \
    gettext \
    oniguruma \
    brotli-libs && \
    docker-php-ext-configure intl && \
    docker-php-ext-install \
    intl \
    zip \
    mbstring \
    pcntl \
    sockets \
    bcmath \
    soap \
    xml \
    pdo_pgsql \
    pgsql && \
    pecl install swoole redis apcu && \
    docker-php-ext-enable swoole redis opcache apcu && \
    apk del .build-deps && \
    rm -rf /tmp/pear

COPY _env/dev/php.ini /usr/local/etc/php/conf.d/custom-php.ini

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN mkdir -p /app && chown -R appuser:appgroup /app

WORKDIR /app

USER appuser

COPY --chown=appuser:appgroup composer.json composer.lock ./
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

COPY --chown=appuser:appgroup . .

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
