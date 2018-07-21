<?php

namespace Product\Model;

class Product { 

  public $ProductID;
  public $ProductName;
  public $SupplierID;
  public $CategoryID;
  public $Unit;
  public $Price;
  public $Quantity;

  public function exchangeArray(array $data) {  
      $this->ProductID = !empty($data['ProductID']) ? $data['ProductID'] : null; 
      $this->ProductName = !empty($data['ProductName']) ? $data['ProductName'] : null; 
      $this->SupplierID = !empty($data['SupplierID']) ? $data['SupplierID'] : null; 
      $this->CategoryID = !empty($data['CategoryID']) ? $data['CategoryID'] : null; 
      $this->Unit = !empty($data['Unit']) ? $data['Unit'] : null; 
      $this->Price = !empty($data['Price']) ? $data['Price'] : null; 
      $this->Quantity = !empty($data['Quantity']) ? $data['Quantity'] : null; 
  }
}
