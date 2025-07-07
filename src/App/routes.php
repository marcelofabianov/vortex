<?php

declare(strict_types=1);

use League\Route\Router;
use Vortex\Platform\Port\Http\HealthCheckController;
use Vortex\Platform\Port\Http\HomeController;

/**
 * @var Router $router
 */
$router->get('/', [HomeController::class, 'index']);
$router->get('/health', HealthCheckController::class);
