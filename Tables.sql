
CREATE TABLE Department (
  department_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  department_name VARCHAR(50) NOT NULL UNIQUE  -- Ensures unique department names
);

CREATE TABLE Role (
  role_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(50) NOT NULL UNIQUE,
  department_id INT UNSIGNED NOT NULL,  -- New column for department reference
  FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Trigger to ensure valid department_id before inserting a new role
DELIMITER //
CREATE TRIGGER assign_department_before_insert
BEFORE INSERT ON Role
FOR EACH ROW
BEGIN
  DECLARE dept_exists INT;
  SELECT COUNT(*) INTO dept_exists
  FROM Department
  WHERE department_id = NEW.department_id;

  IF dept_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid department_id provided';
  END IF;
END; //
DELIMITER ;

--Employee TABLE
CREATE TABLE Employee (
  employee_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  phone_no VARCHAR(255) NOT NULL,
  role_id INT UNSIGNED NOT NULL,
  department_id INT UNSIGNED NOT NULL,
  hire_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES Role(role_id),
  FOREIGN KEY (department_id) REFERENCES Role(department_id)
  
);

--Assigns department_id into Employee based on inserted role_id
CREATE TRIGGER assign_department_on_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
  SET NEW.department_id = (SELECT department_id FROM Role WHERE role_id = NEW.role_id);
END;


-- Make Table
CREATE TABLE Make (
  make_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  make_name VARCHAR(50) NOT NULL UNIQUE
);

-- Model Table
CREATE TABLE Model (
  model_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  model_name VARCHAR(50) NOT NULL,
  make_id INT UNSIGNED NOT NULL,
  FOREIGN KEY (make_id) REFERENCES Make(make_id)
);


-- Vehicle Table (Updated with Foreign Keys)
CREATE TABLE Vehicle (
  vin_number VARCHAR(17) NOT NULL UNIQUE PRIMARY KEY,
  make_id INT UNSIGNED NOT NULL,
  model_id INT UNSIGNED NOT NULL,
  year INT NOT NULL,
  mileage INT,
  color VARCHAR(50),
  purchase_price DECIMAL(10,2),
  status ENUM('available', 'sold', 'under service') NOT NULL DEFAULT 'available',
  FOREIGN KEY (make_id) REFERENCES Make(make_id),
  FOREIGN KEY (model_id) REFERENCES Model(model_id)
);

-- Customer Table
CREATE TABLE Customer (
  customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255)
  phone_no INT NOT NULL,
  driver_license_details VARCHAR(255)
  );


-- Sales Transaction Table (can be created later with Foreign Keys referencing these tables)
CREATE TABLE Sales_Transaction (
  transaction_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL,
  vin_number VARCHAR NOT NULL,
  salesperson_id INT UNSIGNED,  -- Foreign Key to Employee table (if applicable)
  sale_date DATETIME NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
  FOREIGN KEY (vin_number) REFERENCES Vehicle(vin_number),
  FOREIGN KEY (salesperson_id) REFERENCES Employee(employee_id)  -- Add this line if including Employee table
);

DELIMITER //
CREATE PROCEDURE update_vehicle_status_on_sale()
BEGIN
  DECLARE vehicle_exists INT;
  DECLARE sold_vin VARCHAR(17);

  -- Get VIN from the inserted Sales_Transaction record
  SET sold_vin = NEW.vin_number;

  -- Check if vehicle exists in Vehicle table
  SELECT COUNT(*) INTO vehicle_exists
  FROM Vehicle
  WHERE vin_number = sold_vin;

  IF vehicle_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid VIN number provided';
  END IF;

  -- Update status to 'sold' in Vehicle table
  UPDATE Vehicle
  SET status = 'sold'
  WHERE vin_number = sold_vin;
END; //
DELIMITER ;

CREATE TRIGGER update_vehicle_on_sale_after_insert
AFTER INSERT ON Sales_Transaction
FOR EACH ROW
BEGIN
  CALL update_vehicle_status_on_sale();
END;
