-- Migration: create utils

BEGIN TRANSACTION;

--------------------------------------------------------------------------------

DEFINE FUNCTION fn::has_references(
  $record: record,
  $check_incoming: bool,
  $check_outgoing: bool
) {
  LET $incoming = IF $check_incoming THEN (SELECT VALUE <-(?) FROM ONLY $record) ELSE [] END;
  LET $outgoing = IF $check_outgoing THEN (SELECT VALUE ->(?) FROM ONLY $record) ELSE [] END;
  LET $total_refs = array::len($incoming) + array::len($outgoing);
  IF $total_refs > 0 { RETURN true };
  RETURN false;
};

--------------------------------------------------------------------------------

COMMIT TRANSACTION;
