<?php

date_default_timezone_set('Europe/Vilnius');
ini_set('display_errors', '0');
ini_set('display_startup_errors', '0');
ini_set('log_errors', '1');
ini_set('html_errors', FALSE);
ini_set('error_log', dirname(__FILE__) . '/php_error.log');

use Goutte\Client;

class Importer
{
    private $_goutte = null;
    
    public function __construct() {
        require_once('rb.php');
        R::setup('mysql:host=192.168.128.95;dbname=catalog','root','12345');
        R::freeze( true );

        require_once 'goutte.phar';
        $this->_goutte = new Client();
    }

    public function importManufacturers()
    {
        $crawler = $this->_goutte->request('GET', 'http://www.sportsdirect.com/brands');
        $nodes = $crawler->filter('.letItems a');
        foreach($nodes as $node) {
            $man = R::dispense('manufacturer');
            $man->title = $node->textContent;
            $man->slug = $node->getAttribute('href');
            $man->created_at = date('c');
            $man->updated_at = date('c');
            R::store($man);
        }
    }
    
    public function importProducts()
    {
        $crawler = $this->_goutte->request('GET', 'http://www.sportsdirect.com/');
        //@todo
    }
}

$i = new Importer;
//$i->importManufacturers();
//$i->importProducts();