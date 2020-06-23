# docker-sphinxsearch-mssql
sphinxsearch docker image based on bionic with mssql

## sphinx.conf example
```
...
source front
{
	type			= odbc

	sql_host		= 1.2.3.4
	sql_user		= sa
	sql_pass		= password
	sql_db			= db
	sql_port		= 1433
	odbc_dsn = DSN=db;Driver={/etc/odbc.ini};Uid=sa;Pwd=password
}
...
```

## odbc.ini example (linked to sphinx conf volume)
```
[db]
Driver = ODBC Driver 17 for SQL Server  
Server = tcp:1.2.3.4,1433
```
