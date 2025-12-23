# bash-dbms
a database management system written entirely in bash.
## what is this

just a fun project to manage databases, tables, and records right from your terminal using plain bash scripts and files. no mysql, no postgres, just bash doing its thing.

## how to run

chmod +x dbms.sh
./dbms.sh

make sure the Databases/ folder exists or let the script create it.
what it can do

    create/list/drop databases
    connect to a database
    create tables with columns (supports int and string types)
    primary key support
    insert data into tables
    select (display) table contents
    drop tables

data is stored as flat files. metadata (column info, types, pk) lives in .meta files.
coming soon

    sql parsing - gonna add actual sql-like syntax so you can do stuff like SELECT * FROM users instead of menu clicking



structure

text

Databases/
  mydb/
    users        <- table data
    users.meta   <- column names, types, pk info
