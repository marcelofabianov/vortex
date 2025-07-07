<?php

declare(strict_types=1);

namespace Vortex\Platform\Port\Http;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;

abstract class Controller
{
    public function __construct(
        protected readonly ResponseFactoryInterface $responseFactory
    ) {
    }

    /**
     * Creates a JSON response.
     *
     * @param array<string, mixed> $data
     */
    protected function json(array $data, HttpStatusCode $statusCode = HttpStatusCode::OK): ResponseInterface
    {
        $payload = json_encode($data, JSON_THROW_ON_ERROR | JSON_PRETTY_PRINT);

        $response = $this->responseFactory->createResponse($statusCode->value)
            ->withHeader('Content-Type', 'application/json');

        $response->getBody()->write($payload);

        return $response;
    }

    protected function ok(array $data = []): ResponseInterface
    {
        return $this->json($data, HttpStatusCode::OK);
    }

    protected function noContent(): ResponseInterface
    {
        return $this->responseFactory->createResponse(HttpStatusCode::NO_CONTENT->value);
    }

    protected function created(array $data = []): ResponseInterface
    {
        return $this->json($data, HttpStatusCode::CREATED);
    }

    protected function error(array $data = []): ResponseInterface
    {
        return $this->json($data, HttpStatusCode::INTERNAL_SERVER_ERROR);
    }

    protected function notFound(array $data = []): ResponseInterface
    {
        return $this->json($data, HttpStatusCode::NOT_FOUND);
    }

    protected function badRequest(array $data = []): ResponseInterface
    {
        return $this->json($data, HttpStatusCode::BAD_REQUEST);
    }

    protected function unprocessableEntity(array $data = []): ResponseInterface
    {
        return $this->json($data, HttpStatusCode::UNPROCESSABLE_ENTITY);
    }
}
