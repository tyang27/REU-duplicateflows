/* View that keeps track of duplicate violations. */
CREATE OR REPLACE VIEW dup_violation AS (
		SELECT fid FROM
		(SELECT rm.fid AS fid, ROW_NUMBER() OVER (partition BY rm.src, rm.dst ORDER BY rm.fid) AS rnum FROM rm) AS r
		WHERE r.rnum > 1 
		);

/* Rule that repairs violation. */
CREATE OR REPLACE RULE dup_repair AS
ON DELETE TO dup_violation
DO INSTEAD (
		DELETE FROM rm WHERE fid = OLD.fid;

	   );

DROP TABLE IF EXISTS worked;
CREATE UNLOGGED TABLE worked(tmp int);
INSERT INTO worked VALUES (0);

/* Function that returns trigger using plpythonu.
 * Trigger creates worked table with 1 when called.
 */
CREATE OR REPLACE FUNCTION dup_function()
	RETURNS TRIGGER AS $$
	plpy.notice('PLPY NOTICE')
	plpy.execute('DROP TABLE IF EXISTS worked;');
	plpy.execute('CREATE UNLOGGED TABLE worked(tmp int);')
	plpy.execute('INSERT INTO worked VALUES (1);')
	$$ LANGUAGE 'plpythonu';

CREATE OR REPLACE FUNCTION dup_function_sql()
	RETURNS TRIGGER AS $$
BEGIN
	DROP TABLE IF EXISTS worked;
	CREATE UNLOGGED TABLE worked(tmp int);
	INSERT INTO worked VALUES (1);
	RETURN NEW;
END
	$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


/* Executes trigger on insertion to reachability matrix. */
DROP TRIGGER IF EXISTS dup_trigger ON rm;
CREATE TRIGGER dup_trigger AFTER INSERT ON rm
FOR EACH ROW
EXECUTE PROCEDURE dup_function_sql();
