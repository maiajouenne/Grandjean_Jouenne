CREATE OR REPLACE FUNCTION black_scholes_option_pricing(
    _S DECIMAL,    -- Current stock price
    _K DECIMAL,    -- Strike price of the option
    _T DECIMAL,    -- Time to maturity in years
    _r DECIMAL,    -- Risk-free interest rate
    _sigma DECIMAL -- Volatility of the stock
)
RETURNS TABLE (
    call_option_price DECIMAL,
    put_option_price DECIMAL
)
AS $$
DECLARE
    d1 DECIMAL;
    d2 DECIMAL;
    Nd1 DECIMAL; -- N(d1)
    Nd2 DECIMAL; -- N(d2)
BEGIN
    d1 := (LN(_S / _K) + (_r + 0.5 * _sigma^2) * _T) / (_sigma * SQRT(_T));
    d2 := d1 - _sigma * SQRT(_T);

    Nd1 := cum_norm_dist(d1);
    Nd2 := cum_norm_dist(d2);

    call_option_price := _S * Nd1 - _K * EXP(-_r * _T) * Nd2;
    put_option_price := _K * EXP(-_r * _T) * (1 - Nd2) - _S * (1 - Nd1);

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cum_norm_dist(x DECIMAL)
RETURNS DECIMAL AS $$
DECLARE
    b1 DECIMAL := 0.319381530;
    b2 DECIMAL := -0.356563782;
    b3 DECIMAL := 1.781477937;
    b4 DECIMAL := -1.821255978;
    b5 DECIMAL := 1.330274429;
    p DECIMAL := 0.2316419;
    t DECIMAL;
    cnd DECIMAL; -- Cumulative Normal Distribution
BEGIN
    t := 1 / (1 + p * ABS(x));
    cnd := 1 - (EXP(-x*x/2) / SQRT(2 * PI())) * (b1*t + b2*t^2 + b3*t^3 + b4*t^4 + b5*t^5);

    IF x < 0 THEN
        cnd := 1 - cnd;
    END IF;

    RETURN cnd;
END;
$$ LANGUAGE plpgsql;
