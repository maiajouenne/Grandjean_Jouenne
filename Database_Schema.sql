-- Clients Table
CREATE TABLE Clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    risk_adversity_factor FLOAT NOT NULL
);

-- Wallets Table
CREATE TABLE Wallets (
    wallet_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES Clients(client_id) NOT NULL,
    balance DECIMAL(18, 2) DEFAULT 0.00
);

-- Options Table
CREATE TABLE Options (
    option_id SERIAL PRIMARY KEY,
    wallet_id INT REFERENCES Wallets(wallet_id) NOT NULL,
    stock_symbol VARCHAR(10) NOT NULL,
    option_type VARCHAR(10) NOT NULL, -- 'call' or 'put'
    quantity INT NOT NULL,
    strike_price DECIMAL(18, 2) NOT NULL,
    expiration_date DATE NOT NULL
);

-- Stocks Table
CREATE TABLE Stocks (
    stock_id SERIAL PRIMARY KEY,
    stock_symbol VARCHAR(10) UNIQUE NOT NULL,
    stock_name VARCHAR(255) NOT NULL
);

-- Stock Prices Table
CREATE TABLE StockPrices (
    price_id SERIAL PRIMARY KEY,
    stock_id INT REFERENCES Stocks(stock_id) NOT NULL,
    date DATE NOT NULL,
    closing_price DECIMAL(18, 2) NOT NULL
);
