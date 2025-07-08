<?php

declare(strict_types=1);

use League\Route\RouteGroup;
use League\Route\Router;
use Vortex\Contexts\Identity\Infra\Http\UsersController;

/**
 * @var Router $router
 */
$router->group('/api/v1/users', function (RouteGroup $router) {
    $router->get('/', [UsersController::class, 'index']);
    $router->get('/{id}', [UsersController::class, 'show']);
    $router->post('/', [UsersController::class, 'create']);
    $router->put('/{id}', [UsersController::class, 'update']);
    $router->delete('/{id}', [UsersController::class, 'delete']);
    $router->patch('/{id}/status', [UsersController::class, 'toggleStatus']);
});
