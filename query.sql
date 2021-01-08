DROP DATABASE CartDB;
CREATE DATABASE CartDB;
USE CartDB;

DROP TABLE CART ;
CREATE TABLE CART (
    session_id char(36) NULL,
    ItemName varchar(36) NULL,
    NumberOFItem INT
);
DROP TRIGGER before_insert_cart;
CREATE TRIGGER before_insert_cart
BEFORE INSERT ON CART
FOR EACH ROW
BEGIN
    IF new.session_id IS NULL && new.NumberOFItem = 0 THEN
    SET new.session_id = RAND(6);
  END IF;
#   IF new.session_id IS NULL THEN
#     SET new.session_id = uuid();
#   END IF;
END
;

DROP PROCEDURE IF EXISTS store_in_cart;

CREATE PROCEDURE store_in_cart(IN _ItemName varchar(36),IN _NumberOfItem INT)
	BEGIN
	    DECLARE Itemscount INT DEFAULT 0;
	    DECLARE OldItem INT DEFAULT 0;
	    SELECT COUNT(ItemName) into Itemscount
		FROM CART
		WHERE 1=1;
	    SELECT COUNT(ItemName) into OldItem
		FROM CART
		WHERE CART.ItemName=_ItemName;
	    IF Itemscount = 0 THEN
            INSERT INTO CART(ItemName,NumberOFItem)
		    VALUES (_ItemName,_NumberOfItem);

        ELSE
            IF OldItem = 0 THEN
                 INSERT INTO CART(ItemName,NumberOFItem)
		         VALUES (_ItemName,_NumberOfItem);
            end if;
	        UPDATE  CART
	            SET NumberOFItem=NumberOFItem+_NumberOfItem
                WHERE ItemName=_ItemName;
        end if;


-- 		 # SET _ratingID=LAST_INSERT_ID();
 	SELECT _ItemName AS 'ITEMNAME';
	END;
  CALL store_in_cart('coffee',2);


