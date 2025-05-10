"CREATE PROCEDURE kv_get
    (p_key VARCHAR(256))
RETURNS (val LONG VARCHAR)
READS SQL DATA
BEGIN
    DECLARE tmp LONG VARCHAR;
    EXEC SQL WHENEVER SQLERROR ROLLBACK, ABORT;
    EXEC SQL EXECDIRECT
         CREATE TABLE IF NOT EXISTS kv_store(
             key     VARCHAR PRIMARY KEY,
             val     LONG VARCHAR,
             updated TIMESTAMP );
    EXEC SQL COMMIT WORK;
    EXEC SQL PREPARE sel
         SELECT val FROM kv_store WHERE key = ?;

    EXEC SQL EXECUTE sel USING (p_key) INTO (tmp);
    EXEC SQL FETCH sel;

    IF SQLSUCCESS = 0 THEN
        RETURN NOROW;
    END IF;

    val := tmp;
    RETURN ROW;

    EXEC SQL CLOSE sel;
    EXEC SQL DROP  sel;
END";
