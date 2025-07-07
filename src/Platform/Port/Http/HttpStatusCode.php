<?php

declare(strict_types=1);

namespace Vortex\Platform\Port\Http;

enum HttpStatusCode: int
{
    // 2xx Success
    case OK = 200;
    case CREATED = 201;
    case ACCEPTED = 202;
    case NO_CONTENT = 204;

    // 3xx Redirection
    case MOVED_PERMANENTLY = 301;
    case FOUND = 302;

    // 4xx Client Error
    case BAD_REQUEST = 400;
    case UNAUTHORIZED = 401;
    case FORBIDDEN = 403;
    case NOT_FOUND = 404;
    case METHOD_NOT_ALLOWED = 405;
    case CONFLICT = 409;
    case UNPROCESSABLE_ENTITY = 422;

    // 5xx Server Error
    case INTERNAL_SERVER_ERROR = 500;
    case SERVICE_UNAVAILABLE = 503;
    case GATEWAY_TIMEOUT = 504;
}
