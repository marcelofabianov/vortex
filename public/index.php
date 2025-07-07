<?php

declare(strict_types=1);

use Laminas\HttpHandlerRunner\Emitter\SapiEmitter;
use League\Route\Router;
use Psr\Http\Message\ServerRequestInterface;

require_once __DIR__.'/../vendor/autoload.php';

$container = require_once __DIR__.'/../src/App/bootstrap.php';

/** @var Router $router */
$router = $container->get(Router::class);

require_once __DIR__.'/../src/App/routes.php';

$request = $container->get(ServerRequestInterface::class);
$response = $router->dispatch($request);

(new SapiEmitter())->emit($response);
