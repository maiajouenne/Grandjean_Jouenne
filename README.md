# Options Trading Simulation Project

This project simulates a banking system that offers clients the ability to engage in options trading. It focuses on relational database modeling, stored procedures for financial computations, the implementation of triggers, and a comprehensive decision-making process for options trading.

## Table of Contents

- [Project Overview](#project-overview)
- [Database Modelization](#database-modelization)
- [Monte Carlo Simulation](#monte-carlo-simulation)
- [Black-Scholes Computation](#black-scholes-computation)
- [Creation of a View for Option Prices](#creation-of-a-view-for-option-prices)
- [Triggers and Stored Procedure Updates](#triggers-and-stored-procedure-updates)
- [Decision-Making Process](#decision-making-process)
- [Difficulties Faced](#difficulties-faced)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

This project aims to simulate a banking system in PostgreSQL that enables clients to engage in options trading. It combines financial knowledge with database management skills, challenging the developer to construct a comprehensive, data-driven decision-making system in a simulated banking environment.

## Database Modelization

- The `model.sql` file contains the SQL scripts for creating the database schema, including tables for clients, wallets, options, stocks, and historical stock price data.

## Monte Carlo Simulation

- The `monte_carlo.sql` file implements a stored procedure for Monte Carlo simulation to calculate option prices.
- Test cases in the same file demonstrate the functionality of the Monte Carlo simulation.

## Black-Scholes Computation

- The `black_schole.sql` file contains a stored procedure to compute option prices using the Black-Scholes formula.
- Test cases in the same file validate the functionality of the Black-Scholes computation.

## Creation of a View for Option Prices

- The `client_stock_view.sql` file develops a consolidated view displaying option prices for each (client, stock) pair, combining Monte Carlo and Black-Scholes prices.
- Sample queries in the same file demonstrate the usage of the created view.

## Triggers and Stored Procedure Updates

- The `triggers.sql` file implements triggers to automate the update of option prices upon changes in stock prices or client data.
- Test cases validate the functionality of triggers and updated stored procedures.

## Decision-Making Process

- The `Decision_Making/` directory contains scripts related to the decision-making process for options trading.
- Various files cover option ranking, decision logic for buying and exercising options, client portfolio management, and financial dashboards.

## Difficulties Faced

During the development of this project, several challenges were encountered:

1. **Complex Financial Models:** Implementing accurate financial models, such as Monte Carlo simulations and Black-Scholes computations, required a deep understanding of financial mathematics.

2. **Integration of Decision-Making Logic:** Developing a robust decision-making process involved considering numerous factors, including market volatility, risk tolerance, and client portfolio management, which added complexity to the project.

3. **Triggers and Transactions:** Ensuring the correct functioning of triggers and updating stored procedures while maintaining data integrity posed challenges in handling transactions.

