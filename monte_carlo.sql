CREATE OR REPLACE FUNCTION monte_carlo_simulation_proc(
    _S0 DECIMAL,
    _mu DECIMAL,
    _sigma DECIMAL,
    _T DECIMAL,
    _r DECIMAL,
    _num_simulations INT,
    _num_steps INT,
    _K DECIMAL
)
RETURNS TABLE (
    mc_option_price_put DECIMAL,
    mc_option_price_call DECIMAL
)
AS $$
DECLARE
    dt DECIMAL;
    t INT;
    i INT;
    current_price DECIMAL;
    sum_put DECIMAL;
    sum_call DECIMAL;
    random_step DECIMAL;
BEGIN
    -- Initialize parameters
    dt := _T / _num_steps;
    sum_put := 0;
    sum_call := 0;

    -- Monte Carlo Simulation
    FOR i IN 1.._num_simulations LOOP
        current_price := _S0;
        FOR t IN 1.._num_steps LOOP
            random_step := SQRT(dt) * RANDOM();
            current_price := current_price * EXP((_mu - 0.5 * _sigma^2) * dt + _sigma * random_step);
        END LOOP;

        -- Calculate option payoffs
        sum_put := sum_put + GREATEST(_K - current_price, 0);
        sum_call := sum_call + GREATEST(current_price - _K, 0);
    END LOOP;

    -- Calculate option prices
    mc_option_price_put := sum_put / _num_simulations * EXP(-_r * _T);
    mc_option_price_call := sum_call / _num_simulations * EXP(-_r * _T);

    -- Return results
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;


-- Test :
SELECT * FROM monte_carlo_simulation_proc(
    100.0, 
    0.05, 
    0.20, 
    1.0, 
    0.03, 
    100, 
    252, 
    105.0
);
