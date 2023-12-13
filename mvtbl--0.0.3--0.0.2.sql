-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "ALTER EXTENSION mvtbl UPDATE TO '0.0.2'" to load this file. \quit

DROP FUNCTION mvtbl(tbl text, tblspace text, retries int, sleep_sec int)