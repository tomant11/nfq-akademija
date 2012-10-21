<?php

date_default_timezone_set('Europe/Vilnius');
ini_set('display_errors', '0');
ini_set('display_startup_errors', '0');
ini_set('log_errors', '1');
ini_set('html_errors', FALSE);
ini_set('error_log', dirname(__FILE__) . '/php_error.log');

use Goutte\Client;
use Symfony\Component\BrowserKit\Cookie;

use Guzzle\Http\Message\Response as GuzzleResponse;
use Guzzle\Http\Client as GuzzleClient;
use Guzzle\Http\Plugin\MockPlugin;
use Guzzle\Http\Plugin\HistoryPlugin;
use Guzzle\Http\Message\Response;
use Guzzle\Http\Message\PostFile;

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
    
    public function importProducts($limit = 1)
    {
        $sql="SELECT SQL_CALC_FOUND_ROWS m.id, m.slug
            FROM `manufacturer` m
            LEFT OUTER JOIN product p ON (m.id = p.manufacturer_id)
            WHERE p.manufacturer_id IS NULL
            LIMIT :limit
        ";
        $list = R::getAll($sql, array('limit'=>$limit));
        $total = R::getCell('SELECT FOUND_ROWS();');
        print 'Manufacturers left: '.$total;
        
        /*
        $content = file_get_contents('tmp.txt');
        $plugin = new MockPlugin();
        $plugin->addResponse(new GuzzleResponse(200, null, $content));
        $guzzle = new GuzzleClient();
        $guzzle->getEventDispatcher()->addSubscriber($plugin);
        $this->_goutte = new Client();
        $this->_goutte->setClient($guzzle);
        */
        $page = 1;
        
        foreach ($list as $m) {
            $url = 'http://www.sportsdirect.com/'.$m['slug'].'/?mppp=true&mcp='.$page;
            $crawler = $this->_goutte->request('GET', $url);
            $nodes = $crawler->filter('.s-productthumbbox');
            foreach($nodes as $node) {

                $doc = $node->ownerDocument;
                $doc->preserveWhiteSpace = false;
                $xpath     = new DOMXPath($doc);
                
                $title = trim($xpath->query(".//p[@class='productdescription']", $node)->item(0)->textContent);
                $image = $xpath->query(".//img", $node)->item(0)->getAttribute('src');
                $price = $xpath->query(".//span", $node)->item(0)->textContent;
                $price = preg_replace('/[^\d\.]+/', '', $price);
                
                $p = R::dispense('product');
//                $p->group_id = rand(1, 10);
                $p->manufacturer_id = $m['id'];
                $p->title = $title;
                $p->description = '';
                $p->price = $price;
                $p->stock = rand(1, 1000);
                $p->image = $image;
                $p->created_at = date('c');
                $p->updated_at = date('c');
                R::store($p);
            }
            
            print '.';
        }
    }
}

$i = new Importer;
//$i->importManufacturers();
$i->importProducts(100);
