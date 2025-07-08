<?php

declare(strict_types=1);

namespace Vortex\Contexts\Identity\Infra\Http;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Vortex\Platform\Port\Http\Controller;

class UsersController extends Controller
{
    public function index(ServerRequestInterface $request): ResponseInterface
    {
        return $this->ok([
            'message' => 'Users index',
            'data' => [],
        ]);
    }

    /**
     * @param array<string, string> $args
     */
    public function show(ServerRequestInterface $request, array $args): ResponseInterface
    {
        return $this->ok([
            'message' => 'User details',
            'data' => ['id' => $args['id']],
        ]);
    }

    public function create(ServerRequestInterface $request): ResponseInterface
    {
        return $this->created([
            'message' => 'User created',
            'data' => ['id' => 'new_user_id'],
        ]);
    }

    /**
     * @param array<string, string> $args
     */
    public function update(ServerRequestInterface $request, array $args): ResponseInterface
    {
        return $this->ok([
            'message' => 'User updated',
            'data' => ['id' => $args['id']],
        ]);
    }

    /**
     * @param array<string, string> $args
     */
    public function delete(ServerRequestInterface $request, array $args): ResponseInterface
    {
        return $this->noContent();
    }

    /**
     * @param array<string, string> $args
     */
    public function toggleStatus(ServerRequestInterface $request, array $args): ResponseInterface
    {
        // Logic to toggle user status
        return $this->ok([
            'message' => 'User status toggled',
            'data' => ['id' => $args['id']],
        ]);
    }
}
