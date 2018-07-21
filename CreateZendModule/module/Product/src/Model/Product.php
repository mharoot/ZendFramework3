<?php

namespace Product\Model;

use DomainException;
use Zend\Filter\StringTrim;
use Zend\Filter\StripTags;
use Zend\Filter\ToInt;
use Zend\InputFilter\InputFilter;
use Zend\InputFilter\InputFilterAwareInterface;
use Zend\InputFilter\InputFilterInterface;
use Zend\Validator\StringLength;

class Product implements InputFilterAwareInterface { 

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

	public function getArrayCopy() {
		return [
			'ProductID' => $this->ProductID,
			'ProductName' => $this->ProductName,
			'SupplierID' => $this->SupplierID,
			'CategoryID' => $this->CategoryID,
			'Unit' => $this->Unit,
			'Price' => $this->Price,
			'Quantity' => $this->Quantity,
		];
	}

	public function setInputFilter(InputFilterInterface $inputFilter) {
		throw new DomainException(sprintf(
			"Product does not allow injection of an alternate input filter"
		));
	}

	public function getInputFilter() {

		if ($this->inputFilter) {
			return $this->inputFilter;
		}

		$inputFilter = new InputFilter();

		$inputFilter->add([
			'name' => 'ProductID',
			'required' => true,
			'filters' => [
				['name' => ToInt::class],
			],
		]);

		$this->inputFilter = $inputFilter;
		return $this->inputFilter;
	}

}