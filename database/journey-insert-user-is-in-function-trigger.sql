/**
function & trigger:
when a new journey is created, add the user who created it in the user_is_in table and give him the function/role journey leader (1)
**/

CREATE OR REPLACE FUNCTION insert_user_in_on_journey_insert()
RETURNS TRIGGER
security definer
AS $$
BEGIN
  INSERT INTO user_is_in(pk_user_uuid, pk_journey_uuid, function)
  VALUES (auth.uid(), new.pk_journey_uuid, 1);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_user_in_trigger
AFTER INSERT ON journey
FOR EACH ROW
EXECUTE FUNCTION insert_user_in_on_journey_insert();
