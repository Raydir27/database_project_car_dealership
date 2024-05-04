--Create Customer

CREATE OR REPLACE FUNCTION addCustomer
    (
        _name varchar(45)
    )
RETURNS varchar(45)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO customer (
        _name
    ) VALUES (
        _name,
    );
    
    RETURN _name;
END;
$$

--Create Vehicle
CREATE OR REPLACE FUNCTION addVehicle
    (
        _vin_number INTEGER, 
		_make VARCHAR(250),
		_model VARCHAR(250), 
		_customer_id INTEGER
    )
RETURNS varchar(45)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO vehicle (
        vin_number, 
		make,
		model, 
		customer_id
    ) VALUES (
        _vin, 
		_make,
		_model,
		_customer_id
    );
    
    RETURN _model;
END;
$$


--Create Salesperson (Maddy)
CREATE OR REPLACE FUNCTION addEmployee
    (
        _name varchar(45)
    )
RETURNS varchar(45)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Employee (
        _name,
    ) VALUES (
        _name,
    );
    RETURN _name;
END;
$$


--Sales_Transaction
CREATE OR REPLACE FUNCTION addSalesTransaction (
        _customer_id INTEGER,
        _vehicle_id INTEGER,
        _salesperson_id INTEGER
    )
RETURNS INTEGER
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO sales_invoice (
        customer_id,
        vehicle_id,
        salesperson_id
    ) VALUES (
        _customer_id,
        _vehicle_id,
        _salesperson_id
    );
    
    RETURN _customer_id;
END;
$$
