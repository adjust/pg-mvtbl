-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "ALTER EXTENSION mvtbl UPDATE TO '0.0.3'" to load this file. \quit

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
                pg_sleep(sleep_sec);
            END;
        END LOOP;
        RETURN res;
    END;
$$ LANGUAGE plpgsql STRICT;
