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
        R::setup('mysql:host=192.168.128.97;dbname=catalog','public','public');
        R::freeze( true );
        
        require_once 'goutte.phar';
        $this->_goutte = new Client();
    }

    public function importOverstock($case = 'categories')
    {
        $catfile = '/tmp/overstock_categories.txt';
        if($case == 'categories') {
            $pagefile = '/tmp/overstock_sitemap.txt';
            if(!file_exists($pagefile)) {
                $html = $this->_getUrl('http://www.overstock.com/sitemap');
                file_put_contents($pagefile, $html);
            }
            
            $dom = new DOMDocument();
            $dom->loadHTMLFile($pagefile);
            $categories = array();
            $xpath = new DOMXPath($dom);
            $nodes = $xpath->query("//li[@class='bullet3']/a");
            foreach ($nodes as $node) {
                $categories[] = array(
                    'title' => 'Overstock - ' . $node->textContent,
                    'href'  => $node->getAttribute('href'),
                );
            }
            file_put_contents($catfile, json_encode($categories));
        }
        
        if($case == 'products') {
            $categories = json_decode(file_get_contents($catfile), true);
            foreach($categories as $cat) {
                $cid = $this->_getDxCatId($cat);
                $html = $this->_getUrl($cat['href'], true);
                $ndom = new DOMDocument();
                $ndom->loadHTML($html);
                $nxpath     = new DOMXPath($ndom);
                $nodes = $nxpath->query("//div[@class='product-content']");
                
                foreach($nodes as $pnode) {
                    
                    $pxpath     = new DOMXPath($pnode->ownerDocument);
                    $price = $pxpath->query(".//span[@class='you-save']/strong", $pnode)->item(0)->textContent;
                    $price = preg_replace('/[^\d\.]+/', '', $price);
                    $title = $pxpath->query(".//span[@class='pro-name']", $pnode)->item(0)->textContent;
                    $image = $pxpath->query(".//a[@class='pro-thumb']/img", $pnode)->item(0)->getAttribute('src');

                    $p = R::dispense('product');
                    $p->category_id = $cid;
                    $p->title = $title;
                    $p->price = $price;
                    $p->stock = rand(1, 1000);
                    $p->image = $image;
                    $p->created_at = date('c');
                    $p->updated_at = date('c');
                    R::store($p);

                    print '.';
                }
                
                print '/';
            }
        }
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
                $this->_importSDNode($node);
            }
            print '.';
        }
    }
    
    private function _importSDNode($node)
    {
        $xpath     = new DOMXPath($node->ownerDocument);

        $title = trim($xpath->query(".//p[@class='productdescription']", $node)->item(0)->textContent);
        $image = $xpath->query(".//img", $node)->item(0)->getAttribute('src');
        $price = $xpath->query(".//span", $node)->item(0)->textContent;
        $price = preg_replace('/[^\d\.]+/', '', $price);

        $p = R::dispense('product');
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
    
    public function importDx($case = 'products')
    {
        if($case == 'categories') {
            $file = '/tmp/dx.txt';
            $html = file_get_contents($file);

            $dom = new DOMDocument();
            $dom->loadHTML($html);

            $categories = array();
            $xpath     = new DOMXPath($dom);
            $nodes = $xpath->query("//dl[@class='submenu']/dd/a");
            foreach($nodes as $i => $node) {
                $url = $node->getAttribute('href').'?pageSize=200';
                $page = $this->_getUrl($url.'&page=1', true);

                $ndom = new DOMDocument();
                $ndom->loadHTML($page);
                $nxpath     = new DOMXPath($ndom);
                $pages = $nxpath->query("//span[@class='pageCount']")->item(0)->textContent;
                unset($ndom, $nxpath);

                $categories[] = array(
                    'title' => 'DealExtreme - ' . $node->textContent,
                    'href'  => $url,
                    'pages'  => $pages,
                );
            }
            file_put_contents('/tmp/dx_categories.json', json_encode($categories));
        }
        
        if($case == 'products') {
            $categories = json_decode(file_get_contents('/tmp/dx_categories.json'), true);
            foreach($categories as $cat) {
                $cid = $this->_getDxCatId($cat);
                $page = 1;
                $pages = $cat['pages'];
                while ($pages-- > 0) {
                    $url = $cat['href'] .'&page='.$page;
                    
                    $html = $this->_getUrl($url, true);
                    $ndom = new DOMDocument();
                    $ndom->loadHTML($html);
                    $nxpath     = new DOMXPath($ndom);
                    $nodes = $nxpath->query("//div[@id='proList']/ul/li");
                    foreach($nodes as $pnode) {
                        $pxpath     = new DOMXPath($pnode->ownerDocument);
                        $price = $pxpath->query(".//div[@class='po']/p[@class='np']/span", $pnode)->item(0)->textContent;
                        $price = preg_replace('/[^\d\.]+/', '', $price);
                        $title = $pxpath->query(".//p[@class='title']/a", $pnode)->item(0)->textContent;
                        $image = $pxpath->query(".//img[@class='lazy']", $pnode)->item(0)->getAttribute('data-src');
                        
                        $p = R::dispense('product');
                        $p->category_id = $cid;
                        $p->title = $title;
                        $p->description = $title;
                        $p->price = $price;
                        $p->stock = rand(1, 1000);
                        $p->image = $image;
                        $p->created_at = date('c');
                        $p->updated_at = date('c');
                        R::store($p);
                        
                        print '.';
                    }
                    
                    unset($ndom, $nxpath, $html, $nodes);
                    $page++; 
                    print PHP_EOL;
                }
                print '/';
            }
        }
    }
    
    private function _getDxCatId($cat)
    {
        $id = R::getCell('SELECT id FROM category WHERE title = :title', array('title'=>$cat['title']));
        if(!$id) {
            $c = R::dispense('category');
            $c->title = $cat['title'];
            $c->created_at = date('c');
            $c->updated_at = date('c');
            R::store($c);
            $id = $c->id;
        }
        return $id;
    }
    
    private function _getUrl($url, $from_cache = false)
    {
        
        $filename = '/tmp/dx_'.md5($url);
        if($from_cache && file_exists($filename)) {
            return file_get_contents($filename);
        }
        
        $ch = curl_init();
        $timeout = 5;
        $userAgent = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)';
        curl_setopt($ch, CURLOPT_USERAGENT, $userAgent);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
        curl_setopt($ch, CURLOPT_FAILONERROR, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_AUTOREFERER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);

        $data = curl_exec($ch);
        if($data === false) {
            throw new Exception(curl_error($ch));
        }
        curl_close($ch);
        file_put_contents($filename, $data);
        return $data;
    }
}

$i = new Importer;
//$i->importOverstock('categories');
$i->importOverstock('products');
//$i->importDx('categories');
//$i->importDx('products');
