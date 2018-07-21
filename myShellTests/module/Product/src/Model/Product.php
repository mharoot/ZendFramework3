<?php
namespace Product\Model; 

class Product { 
    
    public $id; 

    public function exchangeArray(array $data) { 
        $this->id   = !empty($data['id']) ? $data['id'] : null; 
    }
}