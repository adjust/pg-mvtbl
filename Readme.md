# mvtbl

A postgres Extension to easily move tables around tablespaces

The function mvtbl(tablname, tablespace ) moves a table `tablname` 
along with all indexes to the tablespace `tablespace` and returns
the moved data size in bytes.


### Usage

see test/expected/mvtbl.out for examples

```SQL
SELECT pg_size_pretty(mvtbl('test','mvtbl_test_tblspace'));
 pg_size_pretty 
----------------
 123 MB
(1 row)

SELECT pg_size_pretty(mvtbl('public.test','pg_default'));
 pg_size_pretty 
----------------
 123 MB
(1 row)
```

### Installation

```shell
$ make install
```

```SQL
CREATE EXTENSION mvtbl;
```
