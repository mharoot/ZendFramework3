# How to use this script example:
#                                 
# ./createZendModule.sh Product
#
function createZendModule() {

    routeName=$1
    routeName="$(tr '[:upper:]' '[:lower:]' <<< ${routeName:0:1})${routeName:1}"

    function directories() {
        cd module
        mkdir $1
        cd $1
        mkdir config
        mkdir src 
        mkdir test 
        mkdir view 
    }

    function moduleConfig() {
        cd config
        printf "$( cat '../../../QuickStartZend/module.config.txt' )" $1 $1 $routeName $routeName $1 $routeName >> module.config.php
        cd ../
    }

    function src() {
        cd src
        mkdir Model 
        mkdir Form
        mkdir Controller
        touch Module.php

        function createController() {
            controllerName=$1Controller        
            printf "$( cat '../../../QuickStartZend/controller.txt' )"  $1 $controllerName >> Controller/$controllerName.php
        }

        function createForm() {
            printf "$( cat '../../../QuickStartZend/form.txt' )"  $1 $1 $routeName >> Form/$1Form.php
        }

        function createModel() {
            printf "$( cat '../../../QuickStartZend/model.txt' )" $1 $1 >> Model/$1.php
        }

        function createModelTable() {
            printf "$( cat '../../../QuickStartZend/model.table.txt' )" $1 $1 $1 $1 $1 $routeName $routeName $routeName $routeName $1 $routeName $1 >> Model/$1Table.php
        }

        function createModule() {
            printf "$( cat '../../../QuickStartZend/module.txt' )"  $1 $1 $1 $1 $1 $1 $routeName $1 $1 $1 >> Module.php
        }
        

        
        createController $1
        createForm $1
        createModel $1
        createModelTable $1
        createModule $1
        cd ../

    }
    
    function view() {
        cd view
        
        # make the first letter a lower case by convention
        foo=$1
        foo="$(tr '[:upper:]' '[:lower:]' <<< ${foo:0:1})${foo:1}"

        mkdir $foo
        cd $foo
        mkdir $foo
        cd $foo
        touch index.phtml delete.phtml edit.phtml add.phtml
        cd ../../../ # back to root project directory
    }

    directories $1
    moduleConfig $1
    src $1
    view $1
}


# Starting Point of Application
createZendModule $1

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
    echo "Also add In module.config.php, a database configuration..."
}
nextStep $1