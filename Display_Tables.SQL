--Customer Table
DECLARE
  customer_cursor CURSOR FOR
  SELECT customer_id, name, address, phone_no, driver_license_details
  FROM Customer;
  customer_record Customer%ROWTYPE;
BEGIN
  OPEN customer_cursor;
  LOOP
    FETCH customer_cursor INTO customer_record;
    EXIT WHEN customer_cursor%NOTFOUND;

    -- Display data from customer_record
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_record.customer_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || customer_record.name);
    DBMS_OUTPUT.PUT_LINE('Address: ' || customer_record.address);
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' || customer_record.phone_no);
    DBMS_OUTPUT.PUT_LINE('Driver License Details: ' || customer_record.driver_license_details);
    DBMS_OUTPUT.PUT_LINE('---------------------------');
  END LOOP;
  CLOSE customer_cursor;
END;
/

--Employee Table
DECLARE
  employee_cursor CURSOR FOR
  SELECT employee_id, name, phone_no, role_id, department_id, hire_date
  FROM Employee;
  employee_record Employee%ROWTYPE;
BEGIN
  OPEN employee_cursor;
  LOOP
    FETCH employee_cursor INTO employee_record;
    EXIT WHEN employee_cursor%NOTFOUND;

    -- Display data from employee_record
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || employee_record.employee_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || employee_record.name);
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' || employee_record.phone_no);
    DBMS_OUTPUT.PUT_LINE('Role ID: ' || employee_record.role_id);
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || employee_record.department_id);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || employee_record.hire_date);
    DBMS_OUTPUT.PUT_LINE('---------------------------');
  END LOOP;
  CLOSE employee_cursor;
END;
/

--Vehicle Table
DECLARE
  vehicle_cursor CURSOR FOR
  SELECT vin_number, m.make_name, mo.model_name, year, mileage, color, purchase_price, status
  FROM Vehicle v
  JOIN Make m ON v.make_id = m.make_id
  JOIN Model mo ON v.model_id = mo.model_id;
  vehicle_record Vehicle%ROWTYPE;
BEGIN
  OPEN vehicle_cursor;
  LOOP
    FETCH vehicle_cursor INTO vehicle_record;
    EXIT WHEN vehicle_cursor%NOTFOUND;

    -- Display data from vehicle_record
    DBMS_OUTPUT.PUT_LINE('VIN Number: ' || vehicle_record.vin_number);
    DBMS_OUTPUT.PUT_LINE('Make: ' || vehicle_record.make_name);
    DBMS_OUTPUT.PUT_LINE('Model: ' || vehicle_record.model_name);
    DBMS_OUTPUT.PUT_LINE('Year: ' || vehicle_record.year);
    DBMS_OUTPUT.PUT_LINE('Mileage: ' || vehicle_record.mileage);
    DBMS_OUTPUT.PUT_LINE('Color: ' || vehicle_record.color);
    DBMS_OUTPUT.PUT_LINE('Purchase Price: ' || vehicle_record.purchase_price);
    DBMS_OUTPUT.PUT_LINE('Status: ' || vehicle_record.status);
    DBMS_OUTPUT.PUT_LINE('---------------------------');
  END LOOP;
  CLOSE vehicle_cursor;
END;
/

--Sales Transaction Table
DECLARE
  transaction_cursor CURSOR FOR
  SELECT transaction_id, s.customer_id, c.name AS customer_name, vin_number, salesperson_id, sale_date, price
  FROM Sales_Transaction st
  JOIN Customer c ON st.customer_id = c.customer_id;
  transaction_record Sales_Transaction%ROWTYPE;
BEGIN
  OPEN transaction_cursor;
  LOOP
    FETCH transaction_cursor INTO transaction_record;
    EXIT WHEN transaction_cursor%NOTFOUND;

    -- Display data from transaction_record
    DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || transaction_record.transaction_id);
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || transaction_record.customer_id);
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || transaction_record.customer_name);
    DBMS_OUTPUT.PUT_LINE('VIN Number: ' || transaction_record.vin_number);
    DBMS_OUTPUT.PUT_LINE('Salesperson ID: ' || transaction_record.salesperson_id);
    DBMS_OUTPUT.PUT_LINE('Sale Date: ' || transaction_record.sale_date);
    DBMS_OUTPUT.PUT_LINE('Price: ' || transaction_record.price);
    DBMS_OUTPUT.PUT_LINE('---------------------------');
  END LOOP;
  CLOSE transaction_cursor;
END;
/

--Display Vehicle ID's by grouping Make and Model
DECLARE
  vehicle_cursor CURSOR FOR
  SELECT vin_number, m.make_name, mo.model_name, year, mileage, color, purchase_price, status
  FROM Vehicle v
  JOIN Make m ON v.make_id = m.make_id
  JOIN Model mo ON v.model_id = mo.model_id;
  vehicle_record Vehicle%ROWTYPE;
  make_model_group VARCHAR(255);  -- To store make and model for grouping

BEGIN
  OPEN vehicle_cursor;
  LOOP
    FETCH vehicle_cursor INTO vehicle_record;
    EXIT WHEN vehicle_cursor%NOTFOUND;

    -- Create a group identifier for make and model
    make_model_group := 'Make: ' || vehicle_record.make_name || ', Model: ' || vehicle_record.model_name;

    -- Check if it's a new group (make and model combination)
    IF DBMS_OUTPUT.GET_LINE(make_model_group) IS NULL THEN
      DBMS_OUTPUT.PUT_LINE(make_model_group);  -- Print the group header
    END IF;

    -- Display vehicle details within the group
    DBMS_OUTPUT.PUT_LINE('\t' || vehicle_record.vin_number || ' - ' || vehicle_record.year || ' ' || vehicle_record.color);  

  END LOOP;
  CLOSE vehicle_cursor;
END;
/

--Group and Display Employees by Role and Department
DECLARE
  employee_cursor CURSOR FOR
  SELECT employee_id, name, phone_no, e.role_id, e.department_id, r.role_name, d.department_name
  FROM Employee e
  JOIN Role r ON e.role_id = r.role_id
  JOIN Department d ON e.department_id = d.department_id;
  employee_record Employee%ROWTYPE;
  role_dept_group VARCHAR(255);  -- To store role and department for grouping

BEGIN
  OPEN employee_cursor;
  LOOP
    FETCH employee_cursor INTO employee_record;
    EXIT WHEN employee_cursor%NOTFOUND;

    -- Create a group identifier for role and department names
    role_dept_group := 'Role: ' || employee_record.role_name || ', Department: ' || employee_record.department_name;

    -- Check if it's a new group (role and department combination)
    IF DBMS_OUTPUT.GET_LINE(role_dept_group) IS NULL THEN
      DBMS_OUTPUT.PUT_LINE(role_dept_group);  -- Print the group header
    END IF;

    -- Display employee details within the group
    DBMS_OUTPUT.PUT_LINE('\t' || employee_record.employee_id || ' - ' || employee_record.name);

  END LOOP;
  CLOSE employee_cursor;
END;
/
