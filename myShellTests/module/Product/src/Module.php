<?php
namespace Product;

use Zend\Db\Adapter\AdapterInterface;
use Zend\Db\ResultSet\ResultSet;
use Zend\Db\TableGateway\TableGateway;
use Zend\ModuleManager\Feature\ConfigProviderInterface;

class Module implements ConfigProviderInterface
{
    public function getConfig()
    {
        return include __DIR__ . '/../config/module.config.php';
    }

    public function getServiceConfig() {
		return [ 'factories' => [
					Model\ProductTable::class => function($container) {
						$tableGateway = $container->get(Model\ProductTableGateway::class);
						return new Model\ProductTable($tableGateway);
					},
					Model\ProductTableGateway::class => function ($container) {
						$dbAdapter = $container->get(AdapterInterface::class);
						$resultSetPrototype = new ResultSet();
						$resultSetPrototype->setArrayObjectPrototype(new Model\Product());
						$tableName = 'product';
						return new TableGateway($tableName, $dbAdapter, null, $resultSetPrototype);
					},
				]
		];
    }
	
	public function getControllerConfig()
    {
        return [
            'factories' => [
                Controller\ProductController::class => function($container) {
                    return new Controller\ProductController(
                        $container->get(Model\ProductTable::class)
                    );
                },
            ],
        ];
    }
}