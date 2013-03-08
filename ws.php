#!/usr/bin/env php
<?php
namespace WordSearch;

class WordSearch {
    protected $filePath = null;
    protected $grid = array();
    protected $pwords = array();
    protected $wrap = false;
    protected $n = 0;
    protected $m = 0;
    protected $start = array();
    public function __construct($filePath) {
        $this->filePath = $filePath;
    }
    
    public function run() {
        $this->makeGrid();
        foreach ($this->pwords as $word) {
            $this->findWords($word);
        }
    }
    
    protected function makeGrid() {
        $f = fopen($this->filePath, 'r');
        list($this->n, $this->m) = explode(' ', trim(fgets($f)));
        for ($i = 0;$i < $this->n;$i++) {
            $this->grid[] = trim(fgets($f));
        }
        if (trim(fgets($f)) == 'WRAP') {
            $this->wrap = true;
        }
        if ($this->wrap) {
            $len = count($this->grid);
            foreach ($this->grid as $k => $v) {
                $this->grid[$k] = $v . $v;
                $this->grid[$k + $len] = $v . $v;
            }
        }
        $p = fgets($f);
        for ($i = 0;$i < $p;$i++) {
            $this->pwords[] = trim(fgets($f));
        }
        fclose($f);
    }
    
    protected function findWords($word) {
        for ($x = 0;$x < count($this->grid);$x++) {
            for ($y = 0;$y < strlen($this->grid[$x]);$y++) {
                if ($this->grid[$x][$y] == $word[0]) {
                    $end = $this->inGrid($x, $y, $word);
                    if ($end == false) {
                        continue;
                    } else {
                        $x = $x >= $this->n ? $x - $this->n : $x;
                        $y = $y >= $this->m ? $y - $this->m : $y;
                        $end[0] = $end[0] >= $this->n ? $end[0] - $this->n : $end[0];
                        $end[1] = $end[1] >= $this->m ? $end[1] - $this->m : $end[1];
                        echo "({$x},{$y}) ({$end[0]},{$end[1]})\n";
                        return true;
                    }
                }
            }
        }
        echo "NOT FOUND\n";
        return false;
    }
    
    protected function inGrid($x, $y, $word) {
        $this->start = array(
            $x,
            $y
        );
        $directions = array(
            array(0, -1),
            array(1, -1),
            array(1, 0),
            array(1, 1),
            array(0, 1),
            array(-1, 1),
            array(-1, 0),
            array(-1, -1)
        );
        foreach ($directions as $direction) {
            $end = $this->dirCompare($x, $y, $direction, $word);
            if ($end != false) {
                return $end;
            }
        }
        return false;
    }
    
    protected function dirCompare($x, $y, $d, $w, $i = 1) {
        if ($i >= strlen($w)) {
            return array(
                $x,
                $y
            );
        }
        $x+= $d[0];
        $y+= $d[1];
        $ratio = $this->wrap ? 2 : 1;
        if ($x < 0 || $y < 0 || $x >= $this->n * $ratio || $y >= $this->m * $ratio) {
            return false;
        }
        if (($x - $this->start[0]) % $this->n == 0 && ($y - $this->start[1]) % $this->m == 0) {
            return false;
        }
        if ($this->grid[$x][$y] == $w[$i]) {
            return $this->dirCompare($x, $y, $d, $w, $i + 1);
        }
        return false;
    }
}

$filePath = isset($argv[1]) ? $argv[1] : 'input_wrap.txt';
$ws = new WordSearch($filePath);
$ws->run();
