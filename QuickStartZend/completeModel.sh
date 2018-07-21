# QuickStartZend/./completeModel.sh Product emvc root password product

function completeModel() {
    moduleName=$1 # Product
    dbName=$2 #emvc
    dbUser=$3 #root
    dbPass=$4 #password
    dbTable=$5 #product

    params="$dbName -u$dbUser -p$dbPass"
    echo "SELECT column_name from information_schema.columns where table_schema = '$dbName' and table_name = '$dbTable'; 
    " | mysql $params  >> test.txt
    # or 
    # mysql $params <<DELIMITER
    # SELECT * FROM table;
    # DELIMITER

    sed -i 1d test.txt # delete column_name from first line in text file

    printf "<?php\n\nnamespace $moduleName\Model;\n\nclass $moduleName { \n\n"

    for col in $(cat test.txt)
    do
        echo "  public \$$col;"
    done

    printf "\n  public function exchangeArray(array \$data) {  \n"
    for col in $(cat test.txt)
    do
        echo "      \$this->$col = !empty(\$data['$col']) ? \$data['$col'] : null; "
    done
    echo "  }"
    echo "}"

    rm test.txt
}

function moduleConfig2() {
    routeName=$5
    moduleName=$1
    dbName=$2
    dbUser=$3
    dbPass=$4
    printf "$( cat 'QuickStartZend/module.config.2.txt' )" $moduleName $moduleName $routeName $routeName $moduleName $routeName $dbName $dbUser $dbPass > module/$1/config/module.config.php
    # cd ../
}


completeModel $1 $2 $3 $4 $5  > module/$1/src/Model/$1.php
moduleConfig2 $1 $2 $3 $4 $5

#./test.sh Product emvc root password product