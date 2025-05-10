"CREATE PROCEDURE kv_set
    (IN p_key VARCHAR(256),
     IN p_val LONG VARCHAR)
MODIFIES SQL DATA
BEGIN
    /* 1. Create table if it does not exist yet */
    EXEC SQL EXECDIRECT
         CREATE TABLE IF NOT EXISTS kv_store (
               key VARCHAR PRIMARY KEY,
               val LONG VARCHAR,
               updated TIMESTAMP
         ) STORE MEMORY;
    EXEC SQL COMMIT WORK;
    
    /* 2. Generic error handling */
    EXEC SQL WHENEVER SQLERROR ROLLBACK, ABORT;

    /* 3. Upsert logic */
    EXEC SQL PREPARE upsert
        MERGE INTO kv_store A
          USING (SELECT CAST(? AS VARCHAR)       AS N_key,
                        CAST(? AS LONG VARCHAR)  AS N_val) N
             ON (A.key = N_key)
        WHEN MATCHED THEN
             UPDATE SET A.val = N_val,
                        A.updated = NOW()
        WHEN NOT MATCHED THEN
             INSERT VALUES (N_key, N_val, NOW());

    EXEC SQL EXECUTE upsert USING (p_key, p_val);
    EXEC SQL CLOSE  upsert;
    EXEC SQL DROP   upsert;
    EXEC SQL COMMIT WORK;
END";
