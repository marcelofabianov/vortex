<?php

declare(strict_types=1);

use Laminas\Diactoros\ResponseFactory;
use Laminas\Diactoros\ServerRequestFactory;
use League\Container\Container;
use League\Container\ReflectionContainer;
use League\Route\Router;
use League\Route\Strategy\ApplicationStrategy;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ServerRequestInterface;

$container = new Container();

$container->delegate(new ReflectionContainer(true));

$container->add(ServerRequestInterface::class, function () {
    return ServerRequestFactory::fromGlobals(
        $_SERVER,
        $_GET,
        $_POST,
        $_COOKIE,
        $_FILES
    );
});

$container->add(ResponseFactoryInterface::class, ResponseFactory::class);

$strategy = new ApplicationStrategy();
$strategy->setContainer($container);

$container->add(Router::class, function () use ($strategy) {
    $router = new Router();
    $router->setStrategy($strategy);

    return $router;
})->setShared(true);

return $container;
