-- Verificar si la base de datos ya existe
	IF DB_ID('Aeropuerto') IS NULL
	BEGIN
		-- Crear la base de datos
		EXEC('CREATE DATABASE Aeropuerto');
	END
	GO

	-- Uso de la base de datos recién creada
	USE Aeropuerto;
	GO

	-- Creación de la tabla Country (País)
	CREATE TABLE Country (
		ID INT PRIMARY KEY,
		Name VARCHAR(100) NOT NULL  -- NOT NULL garantiza la integridad de datos
	);

	-- Creación de la tabla City (Ciudad)
	CREATE TABLE City (
		ID INT PRIMARY KEY,
		Name VARCHAR(100) NOT NULL,
		Country_ID INT,
		FOREIGN KEY (Country_ID) REFERENCES Country(ID) ON DELETE CASCADE ON UPDATE CASCADE
	);

	-- Creación de la tabla Plane Model
	CREATE TABLE PlaneModel (
		ID INT PRIMARY KEY,
		Description VARCHAR(255) NOT NULL,
		Graphic VARBINARY(MAX)
	);

	-- Creación de la tabla FlightCategory (Categoría de Vuelo)
	CREATE TABLE FlightCategory (
		ID INT PRIMARY KEY,
		Name VARCHAR(100) NOT NULL,
		Description VARCHAR(255),
		PriceMultiplier DECIMAL(5,2) CHECK (PriceMultiplier > 0)  -- CHECK garantiza que el multiplicador de precio sea mayor a 0
	);

	-- Creación de la tabla Airport
	CREATE TABLE Airport (
		ID INT PRIMARY KEY,
		Name VARCHAR(100) NOT NULL,
		City_ID INT,
		FOREIGN KEY (City_ID) REFERENCES City(ID) ON DELETE CASCADE ON UPDATE CASCADE
	);

	-- Creación de la tabla Flight Number
	CREATE TABLE FlightNumber (
		ID INT PRIMARY KEY,
		Departure_Time TIME NOT NULL,
		Description VARCHAR(255),
		Type VARCHAR(50),
		Airline VARCHAR(100),
		Start_Airport_ID INT,
		Goal_Airport_ID INT,
		Plane_Model_ID INT NULL,
		FOREIGN KEY (Start_Airport_ID) REFERENCES Airport(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
		FOREIGN KEY (Goal_Airport_ID) REFERENCES Airport(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
		FOREIGN KEY (Plane_Model_ID) REFERENCES PlaneModel(ID) ON DELETE SET NULL ON UPDATE CASCADE
	);

	-- Creación de la tabla Airplane
	CREATE TABLE Airplane (
		Registration_Number INT PRIMARY KEY,
		Begin_of_Operation DATE,
		Status VARCHAR(50),
		Plane_Model_ID INT,
		FOREIGN KEY (Plane_Model_ID) REFERENCES PlaneModel(ID) ON DELETE SET NULL ON UPDATE CASCADE
	);

	-- Creación de la tabla Seat
	CREATE TABLE Seat (
		ID INT PRIMARY KEY,
		Size VARCHAR(50),
		Number INT,
		Location VARCHAR(100),
		Plane_Model_ID INT,
		FOREIGN KEY (Plane_Model_ID) REFERENCES PlaneModel(ID) ON DELETE CASCADE ON UPDATE CASCADE
	);

	-- Creación de la tabla Flight
	CREATE TABLE Flight (
		ID INT PRIMARY KEY,
		Boarding_Time TIME NOT NULL,
		Flight_Date DATE NOT NULL,
		Gate VARCHAR(50),
		Check_In_Counter VARCHAR(50),
		Flight_Number_ID INT,
		Flight_Category_ID INT,
		FOREIGN KEY (Flight_Number_ID) REFERENCES FlightNumber(ID) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (Flight_Category_ID) REFERENCES FlightCategory(ID) ON DELETE SET NULL ON UPDATE CASCADE
	);

	-- Creación de la tabla Available Seat
	CREATE TABLE AvailableSeat (
		ID INT PRIMARY KEY,
		Flight_ID INT,
		Seat_ID INT,
		FOREIGN KEY (Flight_ID) REFERENCES Flight(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
		FOREIGN KEY (Seat_ID) REFERENCES Seat(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
	);

	-- Creación de la tabla Customer
	CREATE TABLE Customer (
		ID INT PRIMARY KEY,
		Date_of_Birth DATE NOT NULL,
		Name VARCHAR(100) NOT NULL
	);

	-- Creación de la tabla Documento
	CREATE TABLE Documento (
		ID INT PRIMARY KEY,
		Number VARCHAR(50) NOT NULL,
		Type VARCHAR(50) NOT NULL,
		Customer_ID INT,
		FOREIGN KEY (Customer_ID) REFERENCES Customer(ID) ON DELETE CASCADE ON UPDATE CASCADE
	);



	-- Creación de la tabla Ticket
	CREATE TABLE Ticket (
		Ticketing_Code INT PRIMARY KEY,
		Number INT NOT NULL,
		Customer_ID INT,
		FOREIGN KEY (Customer_ID) REFERENCES Customer(ID) ON DELETE CASCADE ON UPDATE CASCADE
	);

	-- Creación de la tabla Coupon
	CREATE TABLE Coupon (
		ID INT PRIMARY KEY,
		Date_of_Redemption DATE,
		Class VARCHAR(50),
		Standby BIT,
		Meal_Code VARCHAR(50),
		Ticketing_Code INT,
		Flight_ID INT,
		Available_Seat_ID INT NULL,
		FOREIGN KEY (Ticketing_Code) REFERENCES Ticket(Ticketing_Code) ON DELETE NO ACTION ON UPDATE NO ACTION,
		FOREIGN KEY (Flight_ID) REFERENCES Flight(ID) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (Available_Seat_ID) REFERENCES AvailableSeat(ID) ON DELETE SET NULL ON UPDATE CASCADE
	);

	-- Creación de la tabla Frequent Flyer Card
	CREATE TABLE FrequentFlyerCard (
		FFC_Number INT PRIMARY KEY,
		Miles INT CHECK (Miles >= 0), -- CHECK garantiza que los puntos de millas no sean negativos
		Meal_Code VARCHAR(50),
		Customer_ID INT,
		FOREIGN KEY (Customer_ID) REFERENCES Customer(ID) ON DELETE SET NULL ON UPDATE CASCADE
	);

	-- Creación de la tabla Pieces of Luggage
	CREATE TABLE PiecesOfLuggage (
		ID INT PRIMARY KEY,
		Number INT CHECK (Number > 0), -- CHECK garantiza que haya al menos una pieza de equipaje
		Weight DECIMAL(10,2) CHECK (Weight > 0), -- CHECK garantiza que el peso sea mayor a 0
		Coupon_ID INT,
		FOREIGN KEY (Coupon_ID) REFERENCES Coupon(ID) ON DELETE CASCADE ON UPDATE CASCADE
	);
	-------------------------------------------------------------------

	-- Insertar datos en la tabla Country
INSERT INTO Country (ID, Name) VALUES (1, 'USA');
INSERT INTO Country (ID, Name) VALUES (2, 'Canada');

-- Insertar datos en la tabla City
INSERT INTO City (ID, Name, Country_ID) VALUES (1, 'New York', 1);
INSERT INTO City (ID, Name, Country_ID) VALUES (2, 'Toronto', 2);

-- Insertar datos en la tabla PlaneModel
INSERT INTO PlaneModel (ID, Description, Graphic) VALUES (1, 'Boeing 737', NULL);
INSERT INTO PlaneModel (ID, Description, Graphic) VALUES (2, 'Airbus A320', NULL);

-- Insertar datos en la tabla FlightCategory
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (1, 'Economy', 'Clase Económica', 1.0);
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (2, 'Business', 'Clase Ejecutiva', 1.5);

-- Insertar datos en la tabla Airport
INSERT INTO Airport (ID, Name, City_ID) VALUES (1, 'John F. Kennedy International Airport', 1);
INSERT INTO Airport (ID, Name, City_ID) VALUES (2, 'Toronto Pearson International Airport', 2);

-- Insertar datos en la tabla FlightNumber
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID) 
VALUES (1, '08:00:00', 'Morning flight', 'Domestic', 'American Airlines', 1, 2, 1);
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID) 
VALUES (2, '14:00:00', 'Afternoon flight', 'International', 'Air Canada', 2, 1, 2);

-- Insertar datos en la tabla Airplane
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID) 
VALUES (1, '2020-01-01', 'Active', 1);
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID) 
VALUES (2, '2018-05-15', 'Active', 2);

-- Insertar datos en la tabla Seat
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID) 
VALUES (1, 'Standard', 1, 'Aisle', 1);
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID) 
VALUES (2, 'Standard', 2, 'Window', 2);

-- Insertar datos en la tabla Flight
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID) 
VALUES (1, '07:30:00', '2024-08-25', 'B12', 'C34', 1, 1);
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID) 
VALUES (2, '13:30:00', '2024-08-25', 'A11', 'B23', 2, 2);

-- Insertar datos en la tabla AvailableSeat
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID) 
VALUES (1, 1, 1);
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID) 
VALUES (2, 2, 2);

-- Insertar datos en la tabla Customer
INSERT INTO Customer (ID, Date_of_Birth, Name) 
VALUES (1, '1985-07-15', 'John Doe');
INSERT INTO Customer (ID, Date_of_Birth, Name) 
VALUES (2, '1990-10-30', 'Jane Smith');

-- Insertar datos en la tabla Documento
INSERT INTO Documento (ID, Number, Type, Customer_ID) 
VALUES (1, 'AB123456', 'Passport', 1);
INSERT INTO Documento (ID, Number, Type, Customer_ID) 
VALUES (2, 'CD789012', 'Passport', 2);

-- Insertar datos en la tabla Ticket
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID) 
VALUES (1, 101, 1);
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID) 
VALUES (2, 102, 2);

-- Insertar datos en la tabla Coupon
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID) 
VALUES (1, '2024-08-25', 'Economy', 0, 'VGML', 1, 1, 1);
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID) 
VALUES (2, '2024-08-25', 'Business', 0, 'SFML', 2, 2, 2);

-- Insertar datos en la tabla FrequentFlyerCard
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID) 
VALUES (1, 5000, 'VGML', 1);
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID) 
VALUES (2, 10000, 'SFML', 2);

-- Insertar datos en la tabla PiecesOfLuggage
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID) 
VALUES (1, 2, 25.50, 1);
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID) 
VALUES (2, 1, 30.00, 2);
