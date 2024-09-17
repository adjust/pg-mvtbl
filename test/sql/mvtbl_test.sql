CREATE TABLESPACE mvtbl_test_tblspace LOCATION '/tmp/tsttblsp';

CREATE TABLE test AS SELECT i as a, i as b , i as c FROM generate_series(1,1e6) i;
CREATE INDEX ON test(a);
CREATE INDEX ON test(a,b);
CREATE INDEX ON test(c);

SELECT pg_size_pretty(mvtbl('test','mvtbl_test_tblspace'));
SELECT pg_size_pretty(mvtbl('test','pg_default'));

SELECT pg_size_pretty(mvtbl('test','mvtbl_test_tblspace', 3, 3));
SELECT pg_size_pretty(mvtbl('test','pg_default', 3));

ALTER EXTENSION mvtbl UPDATE TO '0.0.2';
ALTER EXTENSION mvtbl UPDATE TO '0.0.3';

DROP TABLESPACE mvtbl_test_tblspace;