<?php
namespace Product; 
use Zend\Router\Http\Segment;
// use Zend\ServiceManager\Factory\InvokableFactory;

return [ 
   /*'controllers' => [
    'factories' => [ 
            Controller\ProductController::class => InvokableFactory::class, 
        ],
    ],*/
    'router' => [ 
            'routes' => [
                'product' => [ 
                    'type' => Segment::class, 
                    'options' => [ 
                        'route' => '/product[/:action[/:id]]', 
                        'constraints' => [ 
                            'action' => '[a-zA-Z][a-zA-Z0-9_-]*', 
                            'id' => '[0-9]+', 
                        ], 
                        'defaults' => [ 
                            'controller' => Controller\ProductController::class,
                            'action' => 'index', 
                        ], 
                    ], 
                ], 
            ], 
        ],
    'view_manager' => [
        'template_path_stack' => [ 
            'product' => __DIR__ . '/../view', 
 		],
    ],
    'db' => [
        'driver'  => 'Pdo',
        'dsn'     => 'mysql:dbname=emvc;host=localhost;charset=utf8',
        'username'=> 'root',
        'password'=> 'password',
    ],
];