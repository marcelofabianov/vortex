<?php

declare(strict_types=1);

namespace Vortex\Platform\Port\Http;

use Psr\Http\Message\ResponseInterface;

class HealthCheckController extends Controller
{
    public function __invoke(): ResponseInterface
    {
        return $this->ok([
            'status' => 'ok',
            'message' => 'Service is healthy',
        ]);
    }
}
