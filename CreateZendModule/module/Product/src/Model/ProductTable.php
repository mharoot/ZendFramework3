<?php

namespace Product\Model;

use RuntimeException;
use Zend\Db\TableGateway\TableGatewayInterface;

class ProductTable
{
	private $tableGateway;

	public function __construct(TableGatewayInterface $tableGateway) {
		$this->tableGateway = $tableGateway;
	}

	public function fetchAll() {
		return $this->tableGateway->select();
    }

	public function getProduct($ProductID) {
		$ProductID = (int) $ProductID;
		$rowset = $this->tableGateway->select(['ProductID' => $ProductID]);
		$row = $rowset->current();

		if (! $row) {
			throw new RuntimeException(sprintf(
				"Could not find row with identifier $ProductID"
			));
		}

		return $row;
	}

	public function saveProduct(Product $product) {
		$data = [
			 'ProductName' => $product->ProductName, 
			 'SupplierID' => $product->SupplierID, 
			 'CategoryID' => $product->CategoryID, 
			 'Unit' => $product->Unit, 
			 'Price' => $product->Price, 
			 'Quantity' => $product->Quantity, 
		];

		$ProductID = (int) $product->ProductID;
		if ($ProductID === 0) {
			$this->tableGateway->insert($data);
			return;
		}

		if (! $this->getProduct($ProductID)) {
			throw new RuntimeException(sprintf(
				"Cannot update Product with identifiers $ProductID"
			));
		}
		
		$this->tableGateway->update($data, ['ProductID' => $ProductID]);
	}

	public function deleteProduct($ProductID){
		$this->tableGateway->delete(['ProductID' => (int) $ProductID]);
	}

}
