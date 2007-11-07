<?php

require "bootstrap.php";

class Producer Extends Dispatcher {

    var $xmlconfig;
    var $current_page;
    var $static_root;

    function Producer() {
        $this->static_root=ROOT.DS.APP_DIR.DS."static";
    }

    function main() {
        foreach ($this->tasks() as $url) {
            $this->write($this->static_root . $this->url2path($url), $this->renderUrl($url));
        }
    }

    function renderUrl($url) {
        ob_start();
        $this->dispatch($url);
        return ob_get_clean();
    }

    // TODO: convert url to local path (win32 safe, etc)
    function url2path($url) {
        return $url;
    }

    // TODO: check if path exists and write file
    function write($path, $content) {
        print "$path\n\n";
        print $content;
    }

    // TODO: get task list via producer model
    function tasks() {
        return array("/articles/2007/01/1.html", "/articles/2005/04/67627.html");
    }
}

$p = new Producer();
$p->main();

?>
