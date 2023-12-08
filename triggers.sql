-- Trigger to update option prices when stock prices change
CREATE OR REPLACE FUNCTION update_option_prices_trigger()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE OptionPrices
    SET
        monte_carlo_put_price = m.mc_option_price_put,
        monte_carlo_call_price = m.mc_option_price_call,
        black_scholes_call_price = b.call_option_price,
        black_scholes_put_price = b.put_option_price
    FROM (
        SELECT
            o.client_id,
            o.stock_id,
            mc_option_price_put,
            mc_option_price_call
        FROM Options o
        CROSS JOIN LATERAL (
            SELECT
                mc_option_price_put,
                mc_option_price_call
            FROM monte_carlo_simulation_proc(
                (SELECT closing_price FROM StockPrices WHERE stock_id = o.stock_id ORDER BY date DESC LIMIT 1),
                0.05, 
                0.20, 
                1.0, 
                0.03, 
                100, 
                252, 
                o.strike_price
            )
        ) m
    ) m_data
    JOIN (
        SELECT
            o.client_id,
            o.stock_id,
            call_option_price,
            put_option_price
        FROM Options o
        CROSS JOIN LATERAL (
            SELECT
                call_option_price,
                put_option_price
            FROM black_scholes_option_pricing(
                (SELECT closing_price FROM StockPrices WHERE stock_id = o.stock_id ORDER BY date DESC LIMIT 1),
                o.strike_price,
                1.0, 
                0.05, 
                0.20
            )
        ) b
    ) b_data ON OptionPrices.client_id = m_data.client_id AND OptionPrices.stock_id = m_data.stock_id
    WHERE OptionPrices.client_id = m_data.client_id AND OptionPrices.stock_id = m_data.stock_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update option prices when client data changes
CREATE OR REPLACE FUNCTION update_option_prices_on_client_change()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE OptionPrices
    SET
        monte_carlo_put_price = m.mc_option_price_put,
        monte_carlo_call_price = m.mc_option_price_call,
        black_scholes_call_price = b.call_option_price,
        black_scholes_put_price = b.put_option_price
    FROM (
        SELECT
            o.client_id,
            o.stock_id,
            mc_option_price_put,
            mc_option_price_call
        FROM Options o
        CROSS JOIN LATERAL (
            SELECT
                mc_option_price_put,
                mc_option_price_call
            FROM monte_carlo_simulation_proc(
                (SELECT closing_price FROM StockPrices WHERE stock_id = o.stock_id ORDER BY date DESC LIMIT 1),
                0.05, 
                0.20, 
                1.0, 
                0.03, 
                100, 
                252, 
                o.strike_price
            )
        ) m
    ) m_data
    JOIN (
        SELECT
            o.client_id,
            o.stock_id,
            call_option_price,
            put_option_price
        FROM Options o
        CROSS JOIN LATERAL (
            SELECT
                call_option_price,
                put_option_price
            FROM black_scholes_option_pricing(
                (SELECT closing_price FROM StockPrices WHERE stock_id = o.stock_id ORDER BY date DESC LIMIT 1),
                o.strike_price,
                1.0, 
                0.05, 
                0.20
            )
        ) b
    ) b_data ON OptionPrices.client_id = m_data.client_id AND OptionPrices.stock_id = m_data.stock_id
    WHERE OptionPrices.client_id = m_data.client_id AND OptionPrices.stock_id = m_data.stock_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger definition for stock price changes
CREATE TRIGGER update_option_prices_stock_trigger
AFTER INSERT OR UPDATE ON StockPrices
FOR EACH ROW
EXECUTE FUNCTION update_option_prices_trigger();

-- Trigger definition for client data changes
CREATE TRIGGER update_option_prices_client_trigger
AFTER UPDATE ON Clients
FOR EACH ROW
EXECUTE FUNCTION update_option_prices_on_client_change();

-- Test case to simulate stock price change
UPDATE StockPrices SET closing_price = 110.0 WHERE stock_id = 1 AND date = '2023-01-01';
