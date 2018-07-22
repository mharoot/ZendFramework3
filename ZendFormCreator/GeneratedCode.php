<?php
namespace Product\Form;

use Zend\Form\Form;

class ProductForm extends Form
{
	public function __construct($name = null) {
		// We will ignore the name provided to the constructor
		parent::_construct('product');

		$this->add([
			'name' => 'ProductID',
			'type' => 'hidden',
		]);
		$this->add([
			'name' => 'ProductName',
			'type' => 'text',
			'options' => [
				'label' => 'ProductName',
			],
		]);
		$this->add([
			'name' => 'SupplierID',
			'type' => 'number',
			'options' => [
				'label' => 'SupplierID',
			],
		]);
		$this->add([
			'name' => 'CategoryID',
			'type' => 'number',
			'options' => [
				'label' => 'CategoryID',
			],
		]);
		$this->add([
			'name' => 'Unit',
			'type' => 'text',
			'options' => [
				'label' => 'Unit',
			],
		]);
		$this->add([
			'name' => 'Price',
			'type' => 'number',
			'options' => [
				'label' => 'Price',
			],
		]);
		$this->add([
			'name' => 'Quantity',
			'type' => 'number',
			'options' => [
				'label' => 'Quantity',
			],
		]);
		$this->add([
            'name' => 'submit',
            'type' => 'submit',
            'attributes' => [
                'value' => 'Go',
                'id'    => 'submitbutton',
            ],
        ]);
	}

}