


function completeModelTable() {
    module=$1
    function namespace() {
        printf "<?php\n\nnamespace %s\Model;\n\n" $module # >> module/$module/src/Model/$moduleTable.php
    }

    function importModules() {
        printf "use RuntimeException;\nuse Zend\Db\TableGateway\TableGatewayInterface;\n\n" # >> module/$module/src/Model/$moduleTable.php
    }

    function construct() {
        printf "class %sTable\n{\n" $module # >> module/$module/src/Model/$moduleTable.php
        printf "    private \$tableGateway;\n\n" # >> module/$module/src/Model/$moduleTable.php
        
        printf "    public function __construct(TableGatewayInterface \$tableGateway) {\n" # >> module/$module/src/Model/$moduleTable.php
        printf "\t\$this->tableGateway = \$tableGateway;\n    }\n\n" # >> module/$module/src/Model/$moduleTable.php
    }

    function fetchAll() {
        printf "    public function fetchAll() {\n\treturn \$this->tableGateway->select();\n    }\n\n" # >> module/$module/src/Model/$moduleTable.php
    }

    function get() {

    }

    function del() {

    }



    namespace
    importModules
    construct
    fetchAll
    get
    del

}

completeModelTable $1

#     public function getProduct($id)
#     {
#         $id = (int) $id;
#         $rowset = $this->tableGateway->select(['id' => $id]);
#         $row = $rowset->current();
#         if (! $row) {
#             throw new RuntimeException(sprintf(
#                 "Could not find row with identifier $id"
#             ));
#         }

#         return $row;
#     }

#     public function saveProduct(Product $product)
#     {
#         $data = [
#             'col_key1' => $product->col_key1,
#             'col_key2'  => $product->col_key2,
#         ];

#         $id = (int) $product->id;

#         if ($id === 0) {
#             $this->tableGateway->insert($data);
#             return;
#         }

#         if (! $this->getProduct($id)) {
#             throw new RuntimeException(sprintf(
#                 "Cannot update product with identifier $id; does not exist"
#             ));
#         }

#         $this->tableGateway->update($data, ['id' => $id]);
#     }

#     public function deleteProduct($id)
#     {
#         $this->tableGateway->delete(['id' => (int) $id]);
#     }
# }
