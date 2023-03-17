CREATE FUNCTION mvtbl(tbl text, tblspace text)
RETURNS bigint AS
$$
	DECLARE
		r RECORD;
		tbl_oid oid := tbl::regclass::oid;
		res bigint = 0;
	BEGIN
		EXECUTE format($sql$ ALTER TABLE %s SET TABLESPACE %s $sql$, tbl, tblspace);
		SELECT pg_catalog.pg_total_relation_size(tbl) INTO res;

		FOR r IN SELECT
			c2.oid::regclass as iname
			FROM pg_catalog.pg_class c, pg_catalog.pg_class c2, pg_catalog.pg_index i
			WHERE c.oid = tbl_oid AND c.oid = i.indrelid AND i.indexrelid = c2.oid
			ORDER BY i.indisprimary DESC, i.indisunique DESC, c2.relname LOOP

			EXECUTE format($sql$ ALTER INDEX %s SET TABLESPACE %s $sql$, r.iname, tblspace);
		END LOOP;
		RETURN res;
	END;
$$ LANGUAGE plpgsql STRICT;

CREATE FUNCTION mvtbl(tbl text, tblspace text, retries int, sleep_sec int DEFAULT 10)
RETURNS bigint AS
$$
	DECLARE
		res bigint;
	BEGIN
		FOR i in 1..retries LOOP
			BEGIN
				res = mvtbl(tbl, tblspace);
				EXIT;
			EXCEPTION WHEN lock_not_available THEN
				IF i = retries THEN
					RAISE;
				END IF;
				pg_sleep(sleep_sec);
			END;
		END LOOP;
		RETURN res;
	END;
$$ LANGUAGE plpgsql STRICT;
