#!/bin/bash

./welcome.sh
echo "loading... :)" 
mkdir -p Databases
sleep 2.5



currentdb='' # this will be replaced by connect to db " method i guess
main_menu(){

    PS3="Choose an option: "

    options=("Create Database" "List Databases" "Connect To Database" "Drop Database" )

    while true; do
        clear
        echo "=============================="
        echo "   Bash DBMS - Main Menu"
        echo "=============================="

        select opt in "${options[@]}"; do
            case $REPLY in
                1) create_database; break ;;
                2) list_databases; break ;;
                3) connect_database; break ;;
                4) drop_database; break ;;
                0) echo "Exiting"; exit 0 ;;
                *) echo "Invalid choice"; sleep 1; break ;;
            esac
        done
    done
}

create_database() {
    read -p "Enter database name: " DBName

    if [[ -z "$DBName" ]]; then
	echo "Database name can not be empty"
	sleep 1
	return
    fi

    if [[ -d "Databases/$DBName" ]]; then
	echo "Database '$DBName' already exists"
    else
	mkdir "Databases/$DBName"
	echo "Database '$DBName' created successfully"
    fi
    read -p "Press any button to continue"
}

list_databases() {
    echo "Existing databases:"
    if [[ ! -d "Databases" ]] || [[ -z "$(ls -A Databases 2>/dev/null)" ]]; then
        echo "No databases found."
    else
        ls Databases
    fi
    read -p "Press Enter to continue..."
}
connect_database() {
ls Databases
echo ""


echo -n "choose database name: "
    read db_name
    
    if [[ -z "$db_name" ]]; then
    	echo "Database name can not be empty"
    	read -p "press any button to continue"
    	return
    fi

    if [ ! -d "Databases/$db_name" ]; then
        echo "Error: database '$db_name' not found"
        echo ""
        echo -n "Press Enter to continue..."
        read
        return
    fi
        echo "Connected to database '$DBName'"
        currentdb="$db_name"
        table_menu
        $currentdb=''
        main_menu
}

drop_database() {
    echo "Selcet a database to drop:"
    select DBName in $(ls ./Databases); do
	if [[ -z "$DBName" ]] ;then
	    echo "Invalid choice"
	else
	    read -p "Are you sure you want to delete '$DBName'? [Y/N]: " check
	    if [[ "$check" =~ ^[Yy]$ ]]; then
		rm -r "Databases/$DBName"
		echo "Database '$DBName' deleted"
	    else
		echo "Deletion canceled"
	    fi
	fi
	break
    done
    read -p "Press any key to continue"
}

# ###############################################################################table opereations
table_menu() {
    PS3="Table Menu: "
    options=("Create Table" "List Tables" "Drop Table" "Insert Data" "Select Table" "Delete Data" "Update Data" "Let's do SQL"  "Back to Main Menu")

    while true; do
        clear
        echo "=============================="
        echo "        Table Menu"
        echo " Database: $(basename "$PWD")"
        echo "=============================="

        select opt in "${options[@]}"; do
            case $REPLY in
                1) create_table; break ;;
                2) list_tables; break ;;
                3) drop_table; break ;;
                4) insert_into_table; break ;;
                5) select_table; break ;;
                6) delete_data; break ;;
                7) update_table; break ;;
                8) quiring; break ;;
                9) return ;;
                *) echo "Invalid choice"; sleep 1; break ;;
            esac
        done
    done
}

create_table() {
 echo "craeting new table...."
 read -p "Enter table name: " tablename
    
 table_file="Databases/$currentdb/$tablename"
 meta_file="Databases/$currentdb/${tablename}.meta"

if [ -z "$tablename" ]; then
        echo "error: name cannot be empty!"
        echo ""
        echo -n "Press Enter to continue..."
        read
        return
    fi
    if [ -f "$table_file" ]; then
        echo "error: table '$tablename' already exists!"
        echo ""
        echo -n "Press Enter to continue..."
        read
        return
    fi


echo -n  "no of columns of the new table?: "
read nocols

echo "you have two data types int and string"
echo  "now give me name for each col and data types of it  "

 columns=""
    datatypes=""


for (( i=1; i<=nocols; i++ )); do
        echo -n "what columne $i name?: "
        read col_name
        
        echo -n "what column $i $col_name datatype (int/string)?: "
        read col_type
        
       
        if [ -z "$columns" ]; then
            columns="$col_name"
            datatypes="$col_type"
        else
            columns="$columns-$col_name"   # 3shan ye apend 
            datatypes="$datatypes-$col_type"
        fi
    done

    echo -n "choose column that will be the primary key?(5ali balak howa  0 based) "
read pkk

echo  "$columns" > "$table_file"
echo "noofcolums: $nocols" >"$meta_file"
echo "datatypes: $datatypes" >> "$meta_file"
echo "names: $columns" >> "$meta_file"
echo "pk: $pkk " >> "$meta_file"


echo "$tablename created" 
 echo -n "Press Enter to continue..."
    read

}


#       ###########################################
list_tables() {
    echo "listing all tables ..."
    ls "Databases/$currentdb" | grep -v '\.meta$'
    echo -n "Press Enter to continue..."
    read
}

select_table(){
    echo "listing all tables ..."
    ls "Databases/$currentdb" | grep -v '\.meta$'
    
    echo "selecting from table...."
    echo "entter table name: " 
     read tablename
    table_file="Databases/$currentdb/$tablename"
 if [[ ! -f "$table_file" ]]; then
    echo "Table not found!"
    read -p "Enter any button to continue"
    return
fi
echo "Table data:"
    cat "$table_file"

    read -p "Press Enter to continue..."
}

drop_table() {
	echo "available tables ... "
	ls "Databases/$currentdb/$tablename" | grep -v '\.meta$'
	
echo "enter table name to drop: "
 read table
 table_file="Databases/$currentdb/$table"
 meta_file="Databases/$currentdb/${table}.meta"
 if [[ ! -f "$table_file" ]]; then
 echo "Table not found!"
 read -p "Press Enter to continue..."
 return
 fi 
 read -p "Are you sure you want to delete '$table'? [Y/N]: " check
if [[ !"$check" =~ ^[Yy]$ ]]; then
	echo "Drop table cancelled."
	read -p "Press Enter to continue..."
 	return 
fi 
rm -f "$table_file" "$meta_file"
 echo "Table '$table' and its metadata have been deleted."
 read -p "Press Enter to continue..."
}


insert_into_table() {
	echo "available tables..."
	ls "Databases/$currentdb/$tablename" | grep -v '\.meta$'

    echo "Enter table name: " 
    read tablename
    table_file="Databases/$currentdb/$tablename"
    meta_file="Databases/$currentdb/${tablename}.meta"


     if [[ ! -f "$table_file" ]]; then
        echo "Table not found!"
        read -p "Press Enter to continue..."
        return
      fi
    colnames=$(grep "^names:" "$meta_file" | cut -d: -f2)
nocols=$(grep "^nocolumns:" "$meta_file" | cut -d: -f2)
    datatypes=$(grep "^datatypes:" "$meta_file" | cut -d: -f2)
    pk=$(grep "^pk:" "$meta_file" | cut -d: -f2) 
    IFS="-" read -ra cols <<< "$colnames"
    IFS="-" read -ra types <<< "$datatypes"

    row=""
    for i in "${!cols[@]}"; do
        col="${cols[$i]}"
        type="${types[$i]}"
        while true; do
            read -p "$col [$type]: " data
            if [[ "$type" == "int" && ! "$data" =~ ^[0-9]+$ ]]; then   # int bas 3shan string no need to check all good
                echo "error: $col must be an integer"
                continue
            fi

            if [ "$i" -eq "$pk" ]; then
                if grep -q "^$data" "$table_file"; then
                    echo "error: primary key already there haha "
                    continue
                fi
            fi

            break
        done

        if [ -z "$row" ]; then
            row="$data"
        else
            row="$row-$data" # here will be the design we need good design for future
        fi
    done
echo "$row" >> "$table_file" 
 echo "done inserting.... " 
read -p "Press Enter to continue..."
}

update_table() {

    echo "let's update table"
    echo ""
    
	echo "listing all tables ..."
    ls "Databases/$currentdb" | grep -v '\.meta$'

    echo -n "enter table name: "
    read tablename

    table_file="Databases/$currentdb/$tablename"
    meta_file="Databases/$currentdb/${tablename}.meta"

    if [[ ! -f "$table_file" ]]; then
        echo "table not found!"
        read -p "Enter any key to continue"
        return
    fi

    colnames=$(grep "^names:" "$meta_file" | cut -d: -f2)
    nocols=$(grep "^nocolumns:" "$meta_file" | cut -d: -f2)
    datatypes=$(grep "^datatypes:" "$meta_file" | cut -d: -f2)
    pk=$(grep "^pk:" "$meta_file" | cut -d: -f2)

    IFS="-" read -ra cols <<< "$colnames"
    IFS="-" read -ra types <<< "$datatypes"

    echo ""
    echo "selecting columns from: $colnames"
    echo ""

    echo -n "enter column name to update: "
    read colselect

    echo -n "enter new value: "
    read valselect

    echo -n "enter an id to search: "
    read id

    row=$(grep "^$id-" "$table_file")

    if [[ -z "$row" ]]; then
        echo "Record with id $id not found"
        read -p "Enter any key to continue"
        return
    fi

    # split row into fields
    IFS="-" read -ra fields <<< "$row"

    index=-1
    for i in "${!cols[@]}"; do
        if [[ "${cols[i]}" == "$colselect" ]]; then
            index=$i
            break
        fi
    done

    if [[ $index -eq -1 ]]; then
        echo "Column not found"
        read -p "Enter any key to continue"
        return
    fi

    # update selected column
    fields[$index]="$valselect"

    # rebuild row
    new_row=$(IFS=-; echo "${fields[*]}")

    # replace old row
    sed -i "s/^$id-.*/$new_row/" "$table_file"

    echo "Done"
    read -p "Enter any key to continue"
}

delete_data()
{
    echo "let's delte table"
    echo ""
    
    echo "listing all tables ..."
    ls "Databases/$currentdb" | grep -v '\.meta$'
    echo ""

    echo -n "enter table name: "
    read tablename

    table_file="Databases/$currentdb/$tablename"
    meta_file="Databases/$currentdb/${tablename}.meta"

    if [[ ! -f "$table_file" ]]; then
        echo "table not found!"
        read -p "Enter any key to continue"
        return
    fi

    colnames=$(grep "^names:" "$meta_file" | cut -d: -f2)
    nocols=$(grep "^nocolumns:" "$meta_file" | cut -d: -f2)
    datatypes=$(grep "^datatypes:" "$meta_file" | cut -d: -f2)
    pk=$(grep "^pk:" "$meta_file" | cut -d: -f2)

    IFS="-" read -ra cols <<< "$colnames"
    IFS="-" read -ra types <<< "$datatypes"

    echo ""
    echo "selecting columns from: $colnames"
    echo ""

    echo -n "enter an id to search: "
    read id

    row=$(grep "^$id-" "$table_file")

    if [[ -z "$row" ]]; then
        echo "Record with id $id not found"
        read -p "Enter any key to continue"
        return
    fi

    # split row into fields
    IFS="-" read -ra fields <<< "$row"

    for i in "${!cols[@]}"; do
        fields[i]=""
    done

    # rebuild row
    new_row=$(echo "${fields[*]}")

    # replace old row
    sed -i "s/^$id-.*/$new_row/" "$table_file"

    echo "Done"
    read -p "Enter any key to continue"
}



quiring() {

    echo "let's do  sql "
    echo ""
# to do : we can make usr choose all ar  one column to view ehen add logic to it    
	echo "listing all tables ..."
    ls "Databases/$currentdb" | grep -v '\.meta$'
# ###########################################
  echo -n "select * "
    
echo -n "from "
read tablename
 echo -n "where id = "
    read id

# ##########################################


    table_file="Databases/$currentdb/$tablename"
    meta_file="Databases/$currentdb/${tablename}.meta"

    if [[ ! -f "$table_file" ]]; then
        echo "table not found!"
        read -p "Enter any key to continue"
        return
    fi

    colnames=$(grep "^names:" "$meta_file" | cut -d: -f2)
    nocols=$(grep "^nocolumns:" "$meta_file" | cut -d: -f2)
    datatypes=$(grep "^datatypes:" "$meta_file" | cut -d: -f2)
    pk=$(grep "^pk:" "$meta_file" | cut -d: -f2)

    IFS="-" read -ra cols <<< "$colnames"
    IFS="-" read -ra types <<< "$datatypes"

    echo ""
    echo "selecting columns from: $colnames"


 echo ""
# ##########################
    row=$(grep "^$id-" "$table_file")

    if [[ -z "$row" ]]; then
        echo "Record with id $id not found"
        read -p "Enter any key to continue"
        return
    fi
echo "$row"
echo ""
    echo "Done"
    read -p "Enter any key to continue"
}







# todo:
# ui menu 
# some quires 



# edits

# validate data types for both update and delete

# organizing list tables functions to make it usable everywhere
# allowing update and delete with more details
















main_menu
