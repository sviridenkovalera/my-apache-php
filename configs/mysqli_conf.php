<?php

    define('PRODUCTION', false);
    define('TESTING', $_SERVER['SERVER_NAME'] === '');
    define('DEVELOPMENT', !PRODUCTION && !TESTING);
    define('DEMO', strpos($_SERVER['SERVER_NAME'], '.site-market.pro'));
    define('NO_CACHE', !PRODUCTION ? "?nocache=" . time() : "");

    switch (true) {
        case PRODUCTION:
            error_reporting(0);
            ini_set('display_errors', false);
            $DB_HOST = 'localhost';
            $DB_USER = 'pro_db_user';
            $DB_PASS = 'pro_db_password';
            $DB_NAME = 'pro_db_name';
            $DB_CHAR = 'utf8';
            break;
        case TESTING:
            error_reporting(E_ALL);
            ini_set('display_errors', true);
            $DB_HOST = 'localhost';
            $DB_USER = 'test_db_user';
            $DB_PASS = 'test_db_password';
            $DB_NAME = 'test_db_name';
            $DB_CHAR = 'utf8';
            break;
        case DEVELOPMENT:
        default:
            error_reporting(E_ALL);
            ini_set('display_errors', true);
            ini_set('display_startup_errors', true);
            $DB_HOST = 'db';
            $DB_USER = 'root';
            $DB_PASS = '';
            $DB_NAME = 'script';
            $DB_CHAR = 'utf8';
            break;
    }
