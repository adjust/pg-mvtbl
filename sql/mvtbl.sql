CREATE FUNCTION mvtbl(tbl text, tblspace text) 
RETURNS bigint AS
$$
	DECLARE
		r RECORD; 
		tbl_oid oid := tbl::regclass::oid;
		res bigint = 0;
	BEGIN
		EXECUTE format($sql$ ALTER TABLE %s SET TABLESPACE %s $sql$, tbl, tblspace);
		RAISE NOTICE 'done moving %', tbl;
		SELECT pg_catalog.pg_total_relation_size(tbl) INTO res;

		FOR r IN SELECT 
			c2.oid::regclass as iname
			FROM pg_catalog.pg_class c, pg_catalog.pg_class c2, pg_catalog.pg_index i
			WHERE c.oid = tbl_oid AND c.oid = i.indrelid AND i.indexrelid = c2.oid
			ORDER BY i.indisprimary DESC, i.indisunique DESC, c2.relname LOOP

			EXECUTE format($sql$ ALTER INDEX %s SET TABLESPACE %s $sql$, r.iname, tblspace);
			RAISE NOTICE 'done moving %', r.iname;
		END LOOP;
		RETURN res;
	END;
$$ LANGUAGE plpgsql STRICT;