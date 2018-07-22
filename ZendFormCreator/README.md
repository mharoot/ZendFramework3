# ZEND FORM CREATOR
This script is intended to be run in the command line in. It generates the Form class code file to be placed in your zend project.  Particularly, in 

```
Zend-Root-Project-Folder/module/{ModuleName}/src/Model/{ModuleName}Form.php
```

### Assumptions
1. Your very first column is a `primary key`, and will be hidden by default but rest of the columns are not hidden.
2. The following datatypes are exclusively covered int, double, varchar, and text.  All other datatypes are assumed to be text such as tinyint, bigint, and so on.  When dealing with a double or int the form knows its dealing with html type numbers, otherwise it assumes its text.
3. Assumed that the user will review the file to make proper modifications.

### Note
All generated code must still be evaluated, and maybe even modified if it doesn't suit your needs.  The purpose of this tool is to speed up development. Not all cases have been covered so you must modify to your needs. 