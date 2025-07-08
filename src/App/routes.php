<?php

declare(strict_types=1);

use League\Route\Router;
use Vortex\Platform\Port\Http\HealthCheckController;

/**
 * @var Router $router
 */
$router->get('/health', HealthCheckController::class);
