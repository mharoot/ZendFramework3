# How to use this script example:
#                                 
# ./createZendModule.sh %s
#

function createMessage() {
    echo "Creating $1 Module..."
    echo
}

function createDirectory() {
    cd module
    mkdir $1
    cd $1
    mkdir config
    mkdir src 
    mkdir test 
    mkdir view 
}

function createConfig() {
    cd config
    touch module.config.php

    # create module.config.php
    echo "<?php" >> module.config.php
    echo "namespace $1;" >> module.config.php
    echo >> module.config.php

    echo "use Zend\Router\Http\Segment;" >> module.config.php
    
    # if you have not set up getServiceConfig() in module.config.php, uncomment the line below:
    # echo "use Zend\ServiceManager\Factory\InvokableFactory;" >> module.config.php

    echo >> module.config.php
    echo "return [ " >> module.config.php
    # echo "    'controllers' => [" >> module.config.php 
    
    # as well as uncomment these lines below:
    # echo "    'factories' => [" >> module.config.php
    # printf "            Controller\%sController::class => InvokableFactory::class, \n" $1 >> module.config.php
    # echo "        ]," >> module.config.php
    # echo "    ]," >> module.config.php

    # make the first letter a lower case by convention
    routeName=$1
    routeName="$(tr '[:upper:]' '[:lower:]' <<< ${routeName:0:1})${routeName:1}"

    printf "    'router' => [ 
        'routes' => [
            '%s' => [ 
                'type' => Segment::class, 
                'options' => [ 
                    'route' => '/%s[/:action[/:id]]', 
                    'constraints' => [ 
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*', 
                        'id' => '[0-9]+', 
                    ], 
                    'defaults' => [ 
                        'controller' => Controller\%sController::class,
                        'action' => 'index', 
                    ], 
                ], 
            ], 
        ], 
    ],\n" $routeName $routeName $1 >> module.config.php

    
    echo "    'view_manager' => [" >> module.config.php
    echo "        'template_path_stack' => [ " >> module.config.php
    echo "            '$routeName' => __DIR__ . '/../view'," >> module.config.php
    echo " 		]," >> module.config.php
    echo "    ]," >> module.config.php
    echo "];" >> module.config.php
    cd ../
}

function createSrc() {
    cd src
    mkdir Model 
    mkdir Form
    mkdir Controller
    touch Module.php
    createModule $1
    createController $1
    cd ../
}

function createModule() {
    # make the first letter a lower case by convention
    lowerCase=$1
    lowerCase="$(tr '[:upper:]' '[:lower:]' <<< ${lowerCase:0:1})${lowerCase:1}"
    # create module
    printf "
<?php
namespace %s;

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
					Model\%sTable::class => function(\$container) {
						\$tableGateway = \$container->get(Model\%sTableGateway::class);
						return new Model\%sTable(\$tableGateway);
					},
					Model\%sTableGateway::class => function (\$container) {
						\$dbAdapter = \$container->get(AdapterInterface::class);
						\$resultSetPrototype = new ResultSet();
						\$resultSetPrototype->setArrayObjectProtottype(new Model\%s());
						\$tableName = '%s';
						return new TableGateway(\$tableName, \$dbAdapter, null, \$resultSetPrototype);
					},
				]
		];
    }
}
    " $1 $1 $1 $1 $1 $1 $lowerCase > Module.php



} # end of create module 

function createController() {
    controllerName=$1Controller
    printf "<?php 

namespace %s\Controller; 

use Zend\Mvc\Controller\AbstractActionController; 
use Zend\View\Model\ViewModel; 

class %s extends AbstractActionController { 
    public function indexAction() { 

    } 
    public function addAction() { 

    } 
    public function editAction() { 

    } 
    public function deleteAction() { 

    } 
}" $1 $controllerName >> Controller/$controllerName.php


}

function createView() {
    cd view
    
    # make the first letter a lower case by convention
    foo=$1
    foo="$(tr '[:upper:]' '[:lower:]' <<< ${foo:0:1})${foo:1}"

    mkdir $foo
    cd $foo
    mkdir $foo
    cd $foo
    touch index.phtml delete.phtml edit.phtml add.phtml
    cd ../../../
}

function nextStep() {
    echo "Open \"composer.json\" in your project root, and find the following section:"
    echo 
    echo "\"autoload\": {"
    echo "       \"psr-4\": {" 
    echo "            \"Application\\\\\": \"module/Application/src/\","
    echo "            \"$1\\\\\": \"module/$1/src/\"   // Add the following line"
    echo "         }"
    echo
    printf "Open module/%s/config/modules.config.php \n 
            return [ 
                'Zend\Form', 
                'Zend\Db', 
                'Zend\Router', 
                'Zend\Validator', 
                'Application', 
                '$1', // <-- Add this line 
            ];\n\n" ${DIR} $1
    echo "Once you've made that change, run the following to ensure Composer updates its autoloading rules:"
    echo "$ composer dump-autoload"
    echo
}

function main() {
    createMessage $1
    createDirectory $1
    createConfig $1
    createSrc $1
    createView $1
    nextStep $1

}
main $1

