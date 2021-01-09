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
    DECLARE ISession INT DEFAULT 0;
    SELECT COUNT(ItemName) into ISession
		FROM CART
		WHERE 1=1;
      IF new.session_id IS NULL && ISession = 0 THEN
        SET new.session_id = UUID();

  END IF;

END
;

DROP PROCEDURE IF EXISTS store_in_cart;

CREATE PROCEDURE store_in_cart(IN _ItemName varchar(36),IN _NumberOfItem INT)
	BEGIN
	    DECLARE Itemscount INT DEFAULT 0;
	    DECLARE OldItem INT DEFAULT 0;
	    DECLARE Session CHAR(36) DEFAULT 0;
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
                 SELECT distinct session_id  into Session  FROM CART WHERE NumberOFItem  IS NOT NULL limit 1;
                UPDATE CART SET session_id = Session WHERE ItemName=_ItemName;
                end if;
	        UPDATE  CART
	            SET NumberOFItem=NumberOFItem+_NumberOfItem
                WHERE ItemName=_ItemName;
        end if;



		  SET Session=LAST_INSERT_ID();
	       	SELECT session_id  FROM CART WHERE session_id=LAST_INSERT_ID() ;
	END;

--   CALL store_in_cart('book',2);


