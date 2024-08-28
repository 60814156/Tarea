-- Verificar si la base de datos ya existe
IF DB_ID('FlightManagement3') IS NULL
BEGIN
    -- Crear la base de datos
    EXEC('CREATE DATABASE FlightManagement3');
END
GO

-- Uso de la base de datos recién creada
USE FlightManagement3;
GO

-- Creación de la tabla Country (País)
CREATE TABLE Country (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL  -- NOT NULL garantiza la integridad de datos
);

-- Poblar la tabla Country
INSERT INTO Country (ID, Name) VALUES (1, 'USA');
INSERT INTO Country (ID, Name) VALUES (2, 'Canada');
INSERT INTO Country (ID, Name) VALUES (3, 'Mexico');
INSERT INTO Country (ID, Name) VALUES (4, 'Brazil');
INSERT INTO Country (ID, Name) VALUES (5, 'United Kingdom');

-- Creación de la tabla City (Ciudad)
CREATE TABLE City (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country_ID INT,
    FOREIGN KEY (Country_ID) REFERENCES Country(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Poblar la tabla City
INSERT INTO City (ID, Name, Country_ID) VALUES (1, 'New York', 1);
INSERT INTO City (ID, Name, Country_ID) VALUES (2, 'Toronto', 2);
INSERT INTO City (ID, Name, Country_ID) VALUES (3, 'Mexico City', 3);
INSERT INTO City (ID, Name, Country_ID) VALUES (4, 'Sao Paulo', 4);
INSERT INTO City (ID, Name, Country_ID) VALUES (5, 'London', 5);

-- Creación de la tabla Plane Model
CREATE TABLE PlaneModel (
    ID INT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL,
    Graphic VARBINARY(MAX)
);

-- Poblar la tabla PlaneModel
INSERT INTO PlaneModel (ID, Description) VALUES (1, 'Boeing 747');
INSERT INTO PlaneModel (ID, Description) VALUES (2, 'Airbus A320');
INSERT INTO PlaneModel (ID, Description) VALUES (3, 'Boeing 737');
INSERT INTO PlaneModel (ID, Description) VALUES (4, 'Embraer E190');
INSERT INTO PlaneModel (ID, Description) VALUES (5, 'Airbus A380');

-- Creación de la tabla FlightCategory (Categoría de Vuelo)
CREATE TABLE FlightCategory (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    PriceMultiplier DECIMAL(5,2) CHECK (PriceMultiplier > 0)  -- CHECK garantiza que el multiplicador de precio sea mayor a 0
);

-- Poblar la tabla FlightCategory
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (1, 'Economy', 'Standard economy class', 1.00);
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (2, 'Business', 'Premium business class', 1.75);
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (3, 'First Class', 'Luxury first class', 2.50);
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (4, 'Premium Economy', 'Enhanced economy class', 1.25);
INSERT INTO FlightCategory (ID, Name, Description, PriceMultiplier) VALUES (5, 'Economy Plus', 'Extra legroom economy', 1.15);

-- Creación de la tabla Airport
CREATE TABLE Airport (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    City_ID INT,
    FOREIGN KEY (City_ID) REFERENCES City(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Poblar la tabla Airport
INSERT INTO Airport (ID, Name, City_ID) VALUES (1, 'JFK International', 1);
INSERT INTO Airport (ID, Name, City_ID) VALUES (2, 'Toronto Pearson', 2);
INSERT INTO Airport (ID, Name, City_ID) VALUES (3, 'Benito Juarez', 3);
INSERT INTO Airport (ID, Name, City_ID) VALUES (4, 'Guarulhos', 4);
INSERT INTO Airport (ID, Name, City_ID) VALUES (5, 'Heathrow', 5);

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

-- Poblar la tabla FlightNumber
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID)
VALUES (1, '08:00', 'Morning Flight', 'Domestic', 'Delta', 1, 2, 1);
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID)
VALUES (2, '12:00', 'Noon Flight', 'International', 'American Airlines', 3, 4, 2);
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID)
VALUES (3, '18:00', 'Evening Flight', 'International', 'British Airways', 5, 1, 3);
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID)
VALUES (4, '22:00', 'Night Flight', 'Domestic', 'Air Canada', 2, 3, 4);
INSERT INTO FlightNumber (ID, Departure_Time, Description, Type, Airline, Start_Airport_ID, Goal_Airport_ID, Plane_Model_ID)
VALUES (5, '06:00', 'Early Morning Flight', 'International', 'LATAM', 4, 5, 5);

-- Creación de la tabla Airplane
CREATE TABLE Airplane (
    Registration_Number INT PRIMARY KEY,
    Begin_of_Operation DATE,
    Status VARCHAR(50),
    Plane_Model_ID INT,
    FOREIGN KEY (Plane_Model_ID) REFERENCES PlaneModel(ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Poblar la tabla Airplane
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID)
VALUES (101, '2010-01-01', 'Active', 1);
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID)
VALUES (102, '2015-05-20', 'Active', 2);
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID)
VALUES (103, '2012-11-10', 'Active', 3);
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID)
VALUES (104, '2018-08-15', 'Under Maintenance', 4);
INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status, Plane_Model_ID)
VALUES (105, '2020-02-05', 'Active', 5);

-- Creación de la tabla Seat
CREATE TABLE Seat (
    ID INT PRIMARY KEY,
    Size VARCHAR(50),
    Number INT,
    Location VARCHAR(100),
    Plane_Model_ID INT,
    FOREIGN KEY (Plane_Model_ID) REFERENCES PlaneModel(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Poblar la tabla Seat
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID)
VALUES (1, 'Standard', 23, 'Aisle', 1);
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID)
VALUES (2, 'Standard', 24, 'Window', 1);
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID)
VALUES (3, 'Economy', 45, 'Aisle', 2);
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID)
VALUES (4, 'Business', 12, 'Window', 3);
INSERT INTO Seat (ID, Size, Number, Location, Plane_Model_ID)
VALUES (5, 'First Class', 1, 'Middle', 4);

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

-- Poblar la tabla Flight
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID)
VALUES (1, '07:30', '2024-09-01', 'A1', 'Check-In 1', 1, 1);
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID)
VALUES (2, '11:30', '2024-09-01', 'B2', 'Check-In 2', 2, 2);
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID)
VALUES (3, '17:30', '2024-09-01', 'C3', 'Check-In 3', 3, 3);
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID)
VALUES (4, '21:30', '2024-09-01', 'D4', 'Check-In 4', 4, 4);
INSERT INTO Flight (ID, Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_ID, Flight_Category_ID)
VALUES (5, '05:30', '2024-09-02', 'E5', 'Check-In 5', 5, 5);

-- Creación de la tabla Available Seat
CREATE TABLE AvailableSeat (
    ID INT PRIMARY KEY,
    Flight_ID INT,
    Seat_ID INT,
    FOREIGN KEY (Flight_ID) REFERENCES Flight(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (Seat_ID) REFERENCES Seat(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Poblar la tabla AvailableSeat
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID)
VALUES (1, 1, 1);
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID)
VALUES (2, 1, 2);
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID)
VALUES (3, 2, 3);
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID)
VALUES (4, 3, 4);
INSERT INTO AvailableSeat (ID, Flight_ID, Seat_ID)
VALUES (5, 4, 5);

-- Creación de la tabla Customer
CREATE TABLE Customer (
    ID INT PRIMARY KEY,
    Date_of_Birth DATE NOT NULL,
    Name VARCHAR(100) NOT NULL
);

-- Poblar la tabla Customer
INSERT INTO Customer (ID, Date_of_Birth, Name)
VALUES (1, '1985-05-15', 'John Doe');
INSERT INTO Customer (ID, Date_of_Birth, Name)
VALUES (2, '1990-07-20', 'Jane Smith');
INSERT INTO Customer (ID, Date_of_Birth, Name)
VALUES (3, '1975-10-30', 'Carlos Mendez');
INSERT INTO Customer (ID, Date_of_Birth, Name)
VALUES (4, '1988-02-18', 'Emily Davis');
INSERT INTO Customer (ID, Date_of_Birth, Name)
VALUES (5, '1995-11-12', 'Samantha Brown');

-- Creación de la tabla Documento
CREATE TABLE Documento (
    ID INT PRIMARY KEY,
    Number VARCHAR(50) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Poblar la tabla Documento
INSERT INTO Documento (ID, Number, Type, Customer_ID)
VALUES (1, 'ABC12345', 'Passport', 1);
INSERT INTO Documento (ID, Number, Type, Customer_ID)
VALUES (2, 'DEF67890', 'Driver License', 2);
INSERT INTO Documento (ID, Number, Type, Customer_ID)
VALUES (3, 'GHI11223', 'National ID', 3);
INSERT INTO Documento (ID, Number, Type, Customer_ID)
VALUES (4, 'JKL44556', 'Passport', 4);
INSERT INTO Documento (ID, Number, Type, Customer_ID)
VALUES (5, 'MNO78901', 'Driver License', 5);

-- Creación de la tabla Ticket
CREATE TABLE Ticket (
    Ticketing_Code INT PRIMARY KEY,
    Number INT NOT NULL,
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Poblar la tabla Ticket
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID)
VALUES (1001, 1, 1);
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID)
VALUES (1002, 2, 2);
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID)
VALUES (1003, 3, 3);
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID)
VALUES (1004, 4, 4);
INSERT INTO Ticket (Ticketing_Code, Number, Customer_ID)
VALUES (1005, 5, 5);

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

-- Poblar la tabla Coupon
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID)
VALUES (1, '2024-09-01', 'Economy', 0, 'Veg', 1001, 1, 1);
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID)
VALUES (2, '2024-09-01', 'Business', 0, 'Non-Veg', 1002, 2, 2);
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID)
VALUES (3, '2024-09-01', 'First Class', 1, 'Veg', 1003, 3, 3);
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID)
VALUES (4, '2024-09-01', 'Economy', 0, 'Non-Veg', 1004, 4, 4);
INSERT INTO Coupon (ID, Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID, Available_Seat_ID)
VALUES (5, '2024-09-02', 'Premium Economy', 1, 'Veg', 1005, 5, 5);

-- Creación de la tabla Frequent Flyer Card
CREATE TABLE FrequentFlyerCard (
    FFC_Number INT PRIMARY KEY,
    Miles INT CHECK (Miles >= 0), -- CHECK garantiza que los puntos de millas no sean negativos
    Meal_Code VARCHAR(50),
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Poblar la tabla FrequentFlyerCard
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID)
VALUES (2001, 5000, 'Veg', 1);
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID)
VALUES (2002, 12000, 'Non-Veg', 2);
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID)
VALUES (2003, 8000, 'Veg', 3);
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID)
VALUES (2004, 15000, 'Non-Veg', 4);
INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, Customer_ID)
VALUES (2005, 3000, 'Veg', 5);

-- Creación de la tabla Pieces of Luggage
CREATE TABLE PiecesOfLuggage (
    ID INT PRIMARY KEY,
    Number INT CHECK (Number > 0), -- CHECK garantiza que haya al menos una pieza de equipaje
    Weight DECIMAL(10,2) CHECK (Weight > 0), -- CHECK garantiza que el peso sea mayor a 0
    Coupon_ID INT,
    FOREIGN KEY (Coupon_ID) REFERENCES Coupon(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Poblar la tabla PiecesOfLuggage
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID)
VALUES (1, 2, 23.5, 1);
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID)
VALUES (2, 1, 12.0, 2);
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID)
VALUES (3, 3, 29.7, 3);
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID)
VALUES (4, 2, 18.4, 4);
INSERT INTO PiecesOfLuggage (ID, Number, Weight, Coupon_ID)
VALUES (5, 1, 10.5, 5);

-- Creación de índices para mejorar el rendimiento
CREATE INDEX idx_Airport_Name ON Airport(Name);
CREATE INDEX idx_Flight_Date ON Flight(Flight_Date);
CREATE INDEX idx_Customer_Name ON Customer(Name);

-- Transacción de Ejemplo
BEGIN TRANSACTION;
    INSERT INTO Country (ID, Name) VALUES (6, 'Australia');
    INSERT INTO City (ID, Name, Country_ID) VALUES (6, 'Sydney', 6);
    INSERT INTO Airport (ID, Name, City_ID) VALUES (6, 'Sydney International', 6);
COMMIT;

select * from Country