<?php
/**
 * Execute this php script by running and passing 5 arguments:
 * php ZendFormCreator.php {Module Name} {db name} {db host} {db user} {db pass}  >> path/to/file
 * 
 * Example:
 * php ZendFormCreator.php Product emvc localhost root password >> module/Product/src/Model/ProductForm.php
*/

class Node {
    public $field;
    public $type;
    public $size; // for strings only ignore this for numbers

    public function __construct($field, $type, $size = null) {
        $this->field = $field;
        $this->type = $type;
        $this->size = $size;
    }
}



class ZendFormCreator {
    public $tablename;
    private $_dbName;
    private $_dbHost;
    private $_dbUser;
    private $_dbPass;
    private $_pdo;
    private $_stmt;

    public function __construct($moduleName, $dbName, $dbHost, $dbUser, $dbPass) {
        $this->tablename = lcfirst($moduleName);
        $this->_dbName = $dbName;
        $this->_dbHost = $dbHost;
        $this->_dbUser = $dbUser;
        $this->_dbPass = $dbPass;

        $this->_pdo = new PDO("mysql:dbname=$this->_dbName;host=$this->_dbHost", $this->_dbUser, $this->_dbPass);

    }

    public function query($q) {
       $this->_stmt = $this->_pdo->prepare($q);
       $this->_stmt->execute();
    }

    public function fetchALL() {
        return $this->_stmt->fetchall(PDO::FETCH_OBJ);
    }

    public function getFieldInfo() {
        $this->query("DESCRIBE $this->tablename");
        $res = $this->fetchAll();

        $nodeColumns = [];
        

        foreach($res as $r) {
            $temp = $r->Type;
            $type = '';
            $i = 0;
            
            // extract type
            while ($temp[$i] != '(') {
                $type.=$temp[$i];
                $i++;
            }
            $i++;

            // extract size
            $sizeAsStr = '';
            $n = strlen($temp);
            while ($i < $n && $temp[$i] != ',' && $temp[$i] != ')') {
                $sizeAsStr .= $temp[$i];
                $i++;
            }

            switch($type) {
                case "int":
                case "decimal":
                    $nodeColumns[] = new Node($r->Field,'number', (int) $sizeAsStr);
                break;
                case "varchar":
                case "text":
                    $nodeColumns[] = new Node($r->Field,'text', (int) $sizeAsStr);
                break;
                default:
                    $nodeColumns[] = new Node($r->Field,'text', (int) $sizeAsStr);
            }
        }

        return $nodeColumns;
    }

    private function header() {
        $module = ucfirst($this->tablename);
        printf("<?php\nnamespace $module\Form;\n\nuse Zend\Form\Form;\n\n");
        printf("class %sForm extends Form\n{\n", $module);
        printf("\tpublic function __construct(\$name = null) {\n");
        printf("\t\t// We will ignore the name provided to the constructor\n");
        printf("\t\tparent::_construct('%s');\n\n", $this->tablename);
    }

    private function footer() {
        printf("\t\t\$this->add([
            'name' => 'submit',
            'type' => 'submit',
            'attributes' => [
                'value' => 'Go',
                'id'    => 'submitbutton',
            ],
        ]);\n");
    }

    public function run() {
        $this->header();
        $nodeCols = $this->getFieldInfo();

        // assumed first field is the primary key
        printf ("\t\t\$this->add([\n\t\t\t'name' => '%s',\n\t\t\t'type' => 'hidden',\n\t\t]);\n", $nodeCols[0]->field);

        // rest of cols
        $n = count( $nodeCols );
        for ($i = 1; $i < $n; $i++) {
            $name = $nodeCols[$i]->field;
            $type = $nodeCols[$i]->type;
            $size = $nodeCols[$i]->size;
            $label = ucfirst($name);

            printf ("\t\t\$this->add([\n\t\t\t'name' => '%s',\n\t\t\t'type' => '%s',\n\t\t\t'options' => [\n\t\t\t\t'label' => '%s',\n\t\t\t],\n\t\t]);\n", $name, $type, $label);
        }
        $this->footer();
        // end of constructor
        printf("\t}\n\n}");
    }

}

// php ZendFormCreator.php Product emvc localhost root password  >> codeGenerated.php
$ZFC = new ZendFormCreator($argv[1], $argv[2], $argv[3], $argv[4], $argv[5]);
$ZFC->run();