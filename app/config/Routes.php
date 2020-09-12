<?php
// Set Base Path
$router->setBasePath(BASE_PATH);

// Dashboard
$router->map('GET', '/', 'DashboardController::index');
$router->map('GET', '/dashboard', 'DashboardController::index', 'dashboard');

// User Login
$router->map('GET', '/login', 'LoginController::login', 'login');
$router->map(
    'POST',
    '/login/submit',
    'LoginController::submit',
    'login_action',
);
$router->map('GET', '/logout', 'LoginController::logout', 'logout');

$master = ['User', 'Program', 'Activity', 'Package', 'Progress'];

foreach ($master as $value) {
    $controller = $value;
    $route = strtolower($value);

    $router->map(
        'GET|POST',
        "/{$route}",
        "{$controller}Controller::index",
        $route,
    );
    $router->map('GET', "/{$route}/add", "{$controller}Controller::form");
    $router->map(
        'GET',
        "/{$route}/edit/[i:id]?",
        "{$controller}Controller::form",
    );
    $router->map('POST', "/{$route}/submit", "{$controller}Controller::submit");
    $router->map(
        'GET|POST',
        "/{$route}/page/[i:page]/?",
        "{$controller}Controller::index",
    );
    $router->map(
        'GET|POST',
        "/{$route}/page/[i:page]/[a:keyword]",
        "{$controller}Controller::index",
    );
    $router->map('POST', "/{$route}/remove", "{$controller}Controller::remove");
}

$router->map('GET', '/report', 'ReportController::index', 'report');

$router->map('POST', '/file/upload', 'FileController::upload');

$router->map('GET', '/403', 'PageController::error403', '403');
$router->map('GET', '/404', 'PageController::error404', '404');
