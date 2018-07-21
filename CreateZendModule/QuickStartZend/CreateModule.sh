

# QuickStartZend/./CreateModule.sh Product emvc root password

function ZendModuleCreator() {
    moduleName=$1   # Product
    dbName=$2       # emvc
    dbUser=$3       # root
    dbPass=$4       # password
    dbTable=$1      # product 
    routeName=""    # product 
    colStorage=""   # product table's columns
    id=""           # primary key id
    colStorageNoId="" # product table's columns w/o primary key

    function construct() {
        # By convention the table and route name is the module name with the
        # first letter is a lower case
        dbTable="$(tr '[:upper:]' '[:lower:]' <<< ${dbTable:0:1})${dbTable:1}"

        routeName=$dbTable # product


        # store cols into file
        params="$dbName -u$dbUser -p$dbPass"
        echo "SELECT column_name from information_schema.columns where table_schema = '$dbName' and table_name = '$dbTable'; 
        " | mysql $params  >> tempColStorage.txt

        # delete first line to remove `column_name` from text file
        sed -i 1d tempColStorage.txt 

        id=$(head -n 1 tempColStorage.txt )

        colStorage=$(cat tempColStorage.txt)

        sed -i 1d tempColStorage.txt 

        colStorageNoId=$(cat tempColStorage.txt)

        rm tempColStorage.txt
    }

    function directories() {
        mkdir module/$moduleName
            mkdir module/$moduleName/config
            mkdir module/$moduleName/src
                mkdir module/$moduleName/src/Model
                mkdir module/$moduleName/src/Form 
                mkdir module/$moduleName/src/Controller

            mkdir module/$moduleName/test 
            mkdir module/$moduleName/view 
                mkdir module/$moduleName/view/$routeName
                    mkdir module/$moduleName/view/$routeName/$routeName
    }

    function controller() {
        controllerName=$moduleName'Controller'   
        printf "$( cat 'QuickStartZend/templates/controller.txt' )"  $moduleName $moduleName $moduleName $controllerName $moduleName $routeName
    }

    function model() {
        printf "<?php\n\nnamespace $moduleName\Model;\n\n"
        printf "use DomainException;\nuse Zend\Filter\StringTrim;\nuse Zend\Filter\StripTags;\nuse Zend\Filter\ToInt;\nuse Zend\InputFilter\InputFilter;\nuse Zend\InputFilter\InputFilterAwareInterface;\nuse Zend\InputFilter\InputFilterInterface;\nuse Zend\Validator\StringLength;\n\n"
        printf "class $moduleName implements InputFilterAwareInterface { \n\n"

        for col in $colStorage
        do
            echo "  public \$$col;"
        done

        printf "\n  public function exchangeArray(array \$data) {  \n"
        for col in $colStorage
        do
            echo "      \$this->$col = !empty(\$data['$col']) ? \$data['$col'] : null; "
        done
        echo "  }"

        printf "\n\tpublic function getArrayCopy() {\n\t\treturn [\n"
        for col in $colStorage
        do
            printf "\t\t\t'$col' => \$this->$col,\n"
        done

        printf "\t\t];\n\t}\n\n"

        printf "\tpublic function setInputFilter(InputFilterInterface \$inputFilter) {\n"
        printf "\t\tthrow new DomainException(sprintf(\n\t\t\t\"$moduleName does not allow injection of an alternate input filter\"\n\t\t));\n\t}\n\n"

        printf "\tpublic function getInputFilter() {\n\n"
        printf "\t\tif (\$this->inputFilter) {\n\t\t\treturn \$this->inputFilter;\n\t\t}\n\n"
        printf "\t\t\$inputFilter = new InputFilter();\n\n"
        printf "\t\t\$inputFilter->add([\n\t\t\t'name' => '$id',\n\t\t\t'required' => true,\n\t\t\t'filters' => [\n"
        printf "\t\t\t\t['name' => ToInt::class],\n\t\t\t],\n\t\t]);\n\n"
        printf "\t\t\$this->inputFilter = \$inputFilter;\n\t\treturn \$this->inputFilter;\n\t}\n\n"
        printf "}";
    }

    function modelTable() {
   
        function namespace() {
            printf "<?php\n\nnamespace %s\Model;\n\n" $moduleName
        }

        function importModules() {
            printf "use RuntimeException;\nuse Zend\Db\TableGateway\TableGatewayInterface;\n\n" 
        }

        function construct() {
            printf "class %sTable\n{\n\tprivate \$tableGateway;\n\n" $moduleName
            
            printf "\tpublic function __construct(TableGatewayInterface \$tableGateway) {\n" 
            printf "\t\t\$this->tableGateway = \$tableGateway;\n\t}\n\n" 
        }

        function fetchAll() {
            printf "\tpublic function fetchAll() {\n\t\treturn \$this->tableGateway->select();\n    }\n\n" 
        }

        function get() {
            printf "\tpublic function get$moduleName(\$$id) {\n\t\t\$$id = (int) \$$id;\n"
            printf "\t\t\$rowset = \$this->tableGateway->select(['$id' => \$$id]);\n"
            printf "\t\t\$row = \$rowset->current();\n\n"
            printf "\t\tif (! \$row) {\n\t\t\tthrow new RuntimeException(sprintf(\n"
            printf "\t\t\t\t\"Could not find row with identifier \$$id\"\n\t\t\t));\n\t\t}\n\n\t\treturn \$row;\n\t}\n\n"
        }

        function save() {
            printf "\tpublic function save$moduleName($moduleName \$$dbTable) {\n"
            printf "\t\t\$data = [\n"
            for col in $colStorageNoId
            do
                printf "\t\t\t '%s' => \$%s->%s, \n" $col $dbTable $col         
            done
            printf "\t\t];\n\n"

            printf "\t\t\$$id = (int) \$$dbTable->$id;\n\t\tif (\$$id === 0) {\n"
            printf "\t\t\t\$this->tableGateway->insert(\$data);\n\t\t\treturn;\n\t\t}\n\n"
            printf "\t\tif (! \$this->get$moduleName(\$$id)) {\n"
            printf "\t\t\tthrow new RuntimeException(sprintf(\n"
            printf "\t\t\t\t\"Cannot update $moduleName with identifiers \$$id\"\n\t\t\t));\n\t\t}\n\n"
            printf "\t\t\$this->tableGateway->update(\$data, ['$id' => \$$id]);\n\t}\n\n"
        }

        function del() {
            printf "\tpublic function delete$moduleName(\$$id){\n\t\t"
            printf "\$this->tableGateway->delete(['$id' => (int) \$$id]);\n\t}\n\n"
        }

        function endBracket() {
            echo "}"
        }

        function main() {
            namespace
            importModules
            construct
            fetchAll
            get
            save
            del
            endBracket
        }
        main
    }

    function view() {

        function index() {
            printf "<?php\n\t// module/$moduleName/view/$routeName/$routeName/index.phtml:\n"
            printf "\t\$title = 'My %ss';\n" $routeName
            printf "\t\$this->headTitle(\$title);\n?>\n\n"
            printf "<h1><?= \$this->escapeHtml(\$title) ?></h1>\n\n"
            printf "<p>\n\t<a href=\"<?= \$this->url('%s', ['action' => 'add']) ?>\">Add new %s</a>\n</p>\n\n" $routeName $routeName
            printf "<table class=\"table\">\n\t<tr>\n"

            for col in $colStorageNoId
            do
                printf "\t\t<th>$col</th>\n"
            done

            printf "\t\t<th>&nbsp;</th>\n"
            printf "\t</tr>\n"
            printf "<?php foreach (\$%ss as \$%s) : ?>\n" $routeName $routeName
            printf "\t<tr>\n"

            for col in $colStorageNoId
            do
                printf "\t\t<td><?= \$this->escapeHtml(\$%s->$col) ?></td>\n" $routeName
            done

            printf "\t\t<td>\n"
            printf "\t\t\t<a href=\"<?= \$this->url('%s', ['action' => 'edit', '$id' => \$%s->$id]) ?>\">Edit</a>\n" $routeName $routeName
            printf "\t\t\t<a href=\"<?= \$this->url('%s', ['action' => 'delete', '$id' => \$%s->$id]) ?>\">Delete</a>\n" $routeName $routeName
            printf "\t\t</td>\n"
            printf "\t</tr>\n<?php endforeach; ?>\n</table>\n"
        }

        index >> module/$moduleName/view/$routeName/$routeName/index.phtml
    }

    function moduleConfig2() {
        printf "$( cat 'QuickStartZend/templates/module.config.2.txt' )" $moduleName $moduleName $routeName $routeName $moduleName $routeName $dbName $dbUser $dbPass
    }

    function main() {
        construct
        directories
        controller >> module/$moduleName/src/Controller/$moduleName'Controller.php'
        
        moduleConfig2 >> module/$moduleName/config/module.config.php
        model >> module/$moduleName/src/Model/$moduleName.php
        modelTable >> module/$moduleName/src/Model/$moduleName'Table.php'
        view
    }
    main
}

ZendModuleCreator $1 $2 $3 $4