<?php

require_once('rb.php');
R::setup('mysql:host=192.168.128.95;dbname=prekes','root','12345');
R::freeze( true );


require_once 'goutte.phar';
use Goutte\Client;
$client = new Client();

$crawler = $client->request('GET', 'http://www.sportsdirect.com/');
$nodes = $crawler->filter('.sdmCol a');
var_dump($nodes);